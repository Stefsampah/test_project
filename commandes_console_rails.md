# 📧 Commandes pour vérifier les emails dans la console Rails

## Commande à copier-coller dans la console Rails :

```ruby
# Vérifier les 4 utilisateurs
['user', 'ja', 'driss', 'admin'].each do |username|
  user = User.find_by(username: username)
  if user
    puts "#{username}: #{user.email}"
  else
    puts "#{username}: NON TROUVÉ"
  end
end
```

## Alternative : Voir tous les utilisateurs

```ruby
User.all.each do |user|
  puts "#{user.username || 'sans username'}: #{user.email}"
end
```

## Pour voir plus de détails :

```ruby
['user', 'ja', 'driss', 'admin'].each do |username|
  user = User.find_by(username: username)
  if user
    puts "\n👤 #{username}:"
    puts "   Email: #{user.email}"
    puts "   ID: #{user.id}"
    puts "   Admin: #{user.admin?}"
  else
    puts "\n❌ #{username}: NON TROUVÉ"
  end
end
```

