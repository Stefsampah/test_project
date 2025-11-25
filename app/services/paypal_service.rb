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
      Rails.logger.error "PayPal non configuré - Mode simulation activé"
      return { success: false, mode: 'simulation' }
    end

    access_token = get_access_token
    return { success: false, error: 'Impossible d\'obtenir le token PayPal' } unless access_token

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

      response = http.request(request)
      
      if response.code == '201'
        data = JSON.parse(response.body)
        payment_id = data['id']
        
        # Trouver l'URL d'approbation
        approval_link = data['links'].find { |link| link['rel'] == 'approval_url' }
        
        if approval_link
          Rails.logger.info "Paiement PayPal créé: #{payment_id}"
          return {
            success: true,
            payment_id: payment_id,
            approval_url: approval_link['href'],
            mode: Rails.configuration.paypal[:mode]
          }
        else
          Rails.logger.error "URL d'approbation PayPal introuvable"
          return { success: false, error: 'URL d\'approbation introuvable' }
        end
      else
        Rails.logger.error "Erreur création paiement PayPal: #{response.body}"
        return { success: false, error: response.body }
      end
    rescue => e
      Rails.logger.error "Erreur PayPal: #{e.message}"
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

