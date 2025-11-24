# 🌍 Guide d'Internationalisation (i18n) - Tube'NPlay

## 📋 Vue d'ensemble

L'application supporte maintenant **Français** et **Anglais** grâce à Rails i18n.

## 🔧 Comment utiliser les traductions

### Syntaxe de base

Dans les vues ERB, remplacez les textes en dur par :

```erb
<!-- Avant -->
<h1>Playlists</h1>

<!-- Après -->
<h1><%= t('playlists.title') %></h1>
```

### Structure des clés de traduction

Les clés sont organisées par section dans les fichiers `config/locales/fr.yml` et `config/locales/en.yml` :

```yaml
fr:
  nav:
    playlists: "Playlists"
    scores: "Classements"
  home:
    title: "Tube'NPlay"
    description: "..."
```

### Exemples d'utilisation

#### 1. Textes simples
```erb
<%= t('nav.playlists') %>
<%= t('home.title') %>
```

#### 2. Dans les liens
```erb
<%= link_to t('nav.playlists'), playlists_path %>
```

#### 3. Dans les boutons
```erb
<%= f.submit t('common.save') %>
```

#### 4. Avec interpolation (variables)
```erb
<%= t('games.points', count: 10) %>
<!-- En français: "10 points" -->
<!-- En anglais: "10 points" -->
```

## 📝 Méthode pour remplacer les textes

### Étape 1 : Identifier le texte à traduire
```erb
<!-- Texte en dur à remplacer -->
<h2>Découvrez nos Playlists</h2>
```

### Étape 2 : Choisir une clé logique
- Section : `home`
- Clé : `discover_playlists`
- Clé complète : `home.discover_playlists`

### Étape 3 : Ajouter dans les fichiers de traduction

**config/locales/fr.yml :**
```yaml
home:
  discover_playlists: "Découvrez nos Playlists"
```

**config/locales/en.yml :**
```yaml
home:
  discover_playlists: "Discover our Playlists"
```

### Étape 4 : Remplacer dans la vue
```erb
<h2><%= t('home.discover_playlists') %></h2>
```

## 🎯 Sections de traduction disponibles

- `nav.*` - Navigation (playlists, scores, badges, etc.)
- `home.*` - Page d'accueil
- `playlists.*` - Pages playlists
- `scores.*` - Pages scores/classements
- `badges.*` - Pages badges
- `rewards.*` - Pages récompenses
- `games.*` - Pages de jeu
- `common.*` - Textes communs (boutons, actions)

## 🔄 Changer la langue

### Automatique
- La langue est détectée depuis :
  1. Le paramètre URL `?locale=fr` ou `?locale=en`
  2. La session utilisateur
  3. Le header `Accept-Language` du navigateur
  4. La langue par défaut (français)

### Manuel
- Utiliser les boutons **FR** / **EN** dans la navigation
- Ou visiter `/locale/fr` ou `/locale/en`

## ✅ Checklist pour traduire une page

1. [ ] Identifier tous les textes en dur dans la vue
2. [ ] Créer des clés logiques dans les fichiers de traduction
3. [ ] Ajouter les traductions FR et EN
4. [ ] Remplacer les textes par `t('key')` dans la vue
5. [ ] Tester avec les deux langues

## 📚 Ressources

- [Documentation Rails i18n](https://guides.rubyonrails.org/i18n.html)
- Fichiers de traduction : `config/locales/fr.yml` et `config/locales/en.yml`

