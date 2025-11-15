# Commandes pour vérifier tous les utilisateurs

Dans la console Rails, exécutez :

```ruby
# Voir tous les utilisateurs
User.all.each do |user|
  puts "ID: #{user.id} | Username: #{user.username || 'AUCUN'} | Email: #{user.email} | Admin: #{user.admin?}"
end
```

Ou plus simple :

```ruby
User.all.each { |u| puts "#{u.username || 'sans username'}: #{u.email}" }
```

