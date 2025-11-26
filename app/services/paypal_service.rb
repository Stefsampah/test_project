require 'net/http'
require 'json'
require 'uri'

class PayPalService
  def self.get_access_token
    return nil if Rails.configuration.paypal[:client_id].blank? || Rails.configuration.paypal[:client_secret].blank?

    uri = URI("#{Rails.configuration.paypal[:base_url]}/v1/oauth2/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request.basic_auth(Rails.configuration.paypal[:client_id], Rails.configuration.paypal[:client_secret])
    request.set_form_data('grant_type' => 'client_credentials')

    response = http.request(request)
    
    if response.code == '200'
      data = JSON.parse(response.body)
      data['access_token']
    else
      Rails.logger.error "Erreur obtention token PayPal: #{response.body}"
      nil
    end
  end

  def self.create_payment(amount:, currency: 'EUR', description:, return_url:, cancel_url:, metadata: {})
    # Vérifier si PayPal est configuré
    if Rails.configuration.paypal[:client_id].blank? || Rails.configuration.paypal[:client_secret].blank?
      Rails.logger.error "❌ PayPal non configuré - impossible de créer un paiement"
      Rails.logger.error "Client ID présent: #{Rails.configuration.paypal[:client_id].present?}"
      Rails.logger.error "Client Secret présent: #{Rails.configuration.paypal[:client_secret].present?}"
      return { success: false, error: 'PayPal non configuré' }
    end

    Rails.logger.info "🔑 Obtention du token PayPal..."
    access_token = get_access_token
    unless access_token
      Rails.logger.error "❌ Impossible d'obtenir le token PayPal"
      return { success: false, error: 'Impossible d\'obtenir le token PayPal' }
    end
    Rails.logger.info "✅ Token PayPal obtenu"

    begin
      uri = URI("#{Rails.configuration.paypal[:base_url]}/v1/payments/payment")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      payment_data = {
        intent: 'sale',
        payer: {
          payment_method: 'paypal'
        },
        redirect_urls: {
          return_url: return_url,
          cancel_url: cancel_url
        },
        transactions: [{
          amount: {
            total: sprintf('%.2f', amount),
            currency: currency
          },
          description: description,
          custom: metadata.to_json
        }]
      }

      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request['Authorization'] = "Bearer #{access_token}"
      request.body = payment_data.to_json

      Rails.logger.info "📤 Envoi de la requête PayPal à: #{uri.path}"
      Rails.logger.debug "Données du paiement: #{payment_data.to_json}"
      
      response = http.request(request)
      
      Rails.logger.info "📥 Réponse PayPal - Code: #{response.code}"
      Rails.logger.debug "Réponse PayPal: #{response.body}"
      
      if response.code == '201'
        data = JSON.parse(response.body)
        payment_id = data['id']
        
        # Trouver l'URL d'approbation
        approval_link = data['links'].find { |link| link['rel'] == 'approval_url' }
        
        if approval_link
          Rails.logger.info "✅ Paiement PayPal créé: #{payment_id}"
          Rails.logger.info "🔗 URL d'approbation: #{approval_link['href']}"
          return {
            success: true,
            payment_id: payment_id,
            approval_url: approval_link['href'],
            mode: Rails.configuration.paypal[:mode]
          }
        else
          Rails.logger.error "❌ URL d'approbation PayPal introuvable dans la réponse"
          Rails.logger.error "Links disponibles: #{data['links']&.map { |l| l['rel'] }&.inspect}"
          return { success: false, error: 'URL d\'approbation introuvable' }
        end
      else
        error_data = begin
          JSON.parse(response.body)
        rescue
          response.body
        end
        Rails.logger.error "❌ Erreur création paiement PayPal (Code #{response.code}): #{error_data}"
        error_message = error_data.is_a?(Hash) ? (error_data['message'] || error_data['name'] || response.body) : response.body
        return { success: false, error: error_message }
      end
    rescue => e
      Rails.logger.error "❌ Exception PayPal: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.first(5).join("\n")
      return { success: false, error: e.message }
    end
  end

  def self.execute_payment(payment_id:, payer_id:)
    # Vérifier si PayPal est configuré
    if Rails.configuration.paypal[:client_id].blank? || Rails.configuration.paypal[:client_secret].blank?
      Rails.logger.error "PayPal non configuré"
      return { success: false, error: 'PayPal non configuré' }
    end

    access_token = get_access_token
    return { success: false, error: 'Impossible d\'obtenir le token PayPal' } unless access_token

    begin
      uri = URI("#{Rails.configuration.paypal[:base_url]}/v1/payments/payment/#{payment_id}/execute")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      execute_data = {
        payer_id: payer_id
      }

      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request['Authorization'] = "Bearer #{access_token}"
      request.body = execute_data.to_json

      response = http.request(request)
      
      if response.code == '200'
        data = JSON.parse(response.body)
        transaction = data['transactions'].first
        amount = transaction['amount']['total']
        currency = transaction['amount']['currency']
        
        Rails.logger.info "Paiement PayPal exécuté avec succès: #{payment_id}"
        return {
          success: true,
          payment: data,
          amount: amount,
          currency: currency
        }
      else
        Rails.logger.error "Erreur exécution paiement PayPal: #{response.body}"
        return { success: false, error: response.body }
      end
    rescue => e
      Rails.logger.error "Erreur PayPal: #{e.message}"
      return { success: false, error: e.message }
    end
  end

  def self.get_payment(payment_id)
    # Vérifier si PayPal est configuré
    if Rails.configuration.paypal[:client_id].blank? || Rails.configuration.paypal[:client_secret].blank?
      return { success: false, error: 'PayPal non configuré' }
    end

    access_token = get_access_token
    return { success: false, error: 'Impossible d\'obtenir le token PayPal' } unless access_token

    begin
      uri = URI("#{Rails.configuration.paypal[:base_url]}/v1/payments/payment/#{payment_id}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.path)
      request['Authorization'] = "Bearer #{access_token}"

      response = http.request(request)
      
      if response.code == '200'
        data = JSON.parse(response.body)
        return { success: true, payment: data }
      else
        Rails.logger.error "Erreur récupération paiement PayPal: #{response.body}"
        return { success: false, error: response.body }
      end
    rescue => e
      Rails.logger.error "Erreur PayPal: #{e.message}"
      return { success: false, error: e.message }
    end
  end
end

