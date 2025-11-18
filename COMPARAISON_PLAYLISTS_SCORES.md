# Comparaison détaillée : Page Playlists vs Page Scores

## Éléments comparés

### 1. LOGO ET NOM DE L'APP (dans layout - identique sur les deux pages)
**Emplacement** : `app/views/layouts/application.html.erb` (lignes 183-186)

**Styles dans layout** :
- `.logo` : `font-size: 1.25rem` (20px)
- `.logo svg` : `width: 32px`, `height: 32px`
- `.nav-link` : `font-size: 0.9rem` (14.4px)

**Styles ajoutés dans playlists** :
- `.logo` : `font-size: 1.25rem !important`
- `.logo svg` : `width: 32px !important`, `height: 32px !important`
- `.nav-link` : `font-size: 0.9rem !important`

**Différence** : Aucune (même layout)

---

### 2. NOTIFICATION "Vous avez une partie en cours" (dans layout - identique sur les deux pages)
**Emplacement** : `app/views/layouts/application.html.erb` (lignes 268-277)

**Styles dans layout** :
- `.flash` : `max-width: 1200px`, `margin: 1rem auto`, `padding: 0 1rem`
- `.flash-notice` : `padding: 0.75rem 1rem`, `border-radius: 0.375rem`
- Texte inline : `font-size: 1rem` (dans style inline)
- Bouton : `px-4 py-2`, `font-size: 1rem` (dans style inline)

**Styles ajoutés dans playlists** :
- `#game-in-progress-notification` : `max-width: 1200px !important`, `margin: 1rem auto !important`, `padding: 0 1rem !important`
- `#game-in-progress-notification .flash-notice` : `padding: 0.75rem 1rem !important`, `font-size: 1rem !important`
- Texte et bouton : `font-size: 1rem !important`

**Différence** : Aucune (même layout, styles ajoutés pour forcer)

---

### 3. TITRE DE LA PAGE

#### Page Scores
**HTML** : `<h1 class="text-2xl font-bold text-white">Classements</h1>`

**Styles CSS** (lignes 440-444) :
```css
h1.text-2xl.font-bold.text-white {
  font-size: 1.5rem !important;  /* 24px */
  font-weight: 700 !important;
  line-height: 1.2 !important;
}
```

**Conteneur** : `<div class="text-center mb-4">`

#### Page Playlists
**HTML** : `<h1 class="text-2xl font-bold text-white">Playlists</h1>`

**Styles CSS** (lignes 519-523) :
```css
h1.text-2xl.font-bold.text-white {
  font-size: 1.5rem !important;  /* 24px */
  font-weight: 700 !important;
  line-height: 1.2 !important;
}
```

**Conteneur** : `<div class="text-center mb-4">`

**Différence** : AUCUNE - Styles identiques

---

### 4. BOUTONS DE FILTRAGE

#### Page Scores
**HTML** :
```html
<button class="score-filter active px-4 py-2 rounded-lg text-sm font-medium text-white bg-purple-600 hover:bg-purple-700 transition-colors" data-target="all">
  Tous les scores
</button>
<button class="score-filter px-4 py-2 rounded-lg text-sm font-medium text-gray-300 bg-gray-700 hover:bg-gray-600 transition-colors" data-target="my">
  Mes scores
</button>
```

**Styles CSS** (ligne 448-450) :
```css
.score-filter.active {
  background-color: #9333ea;
}
```

**Classes Tailwind** :
- `px-4` = `padding-left: 1rem; padding-right: 1rem`
- `py-2` = `padding-top: 0.5rem; padding-bottom: 0.5rem`
- `text-sm` = `font-size: 0.875rem` (14px)
- `font-medium` = `font-weight: 500`

#### Page Playlists
**HTML** :
```html
<button id="all-playlists-btn" class="filter-btn active px-4 py-2 rounded-lg text-sm font-medium text-white bg-purple-600 hover:bg-purple-700 transition-colors" data-filter="all">
  Toutes les playlists
</button>
<button id="my-playlists-btn" class="filter-btn px-4 py-2 rounded-lg text-sm font-medium text-gray-300 bg-gray-700 hover:bg-gray-600 transition-colors" data-filter="my">
  Mes playlists
</button>
```

**Styles CSS** (lignes 547-556) :
```css
.filter-btn {
  font-size: 0.875rem !important;  /* 14px */
  padding: 0.5rem 1rem !important;  /* py-2 px-4 */
  line-height: 1.25rem !important;
  font-weight: 500 !important;
}

.filter-btn.active {
  background-color: #9333ea !important;
}
```

**Classes Tailwind** :
- `px-4` = `padding-left: 1rem; padding-right: 1rem`
- `py-2` = `padding-top: 0.5rem; padding-bottom: 0.5rem`
- `text-sm` = `font-size: 0.875rem` (14px)
- `font-medium` = `font-weight: 500`

**Différence** : AUCUNE - Styles identiques (même padding, même font-size)

---

## RÉSUMÉ DES DIFFÉRENCES

### ✅ Éléments IDENTIQUES :
1. **Logo et nom de l'app** : Même layout, mêmes styles
2. **Notification** : Même layout, mêmes styles
3. **Titre de la page** : Mêmes classes, mêmes styles CSS
4. **Boutons de filtrage** : Mêmes classes Tailwind, mêmes styles CSS

### ⚠️ DIFFÉRENCES DÉTECTÉES :

#### 1. STYLES GLOBAUX HTML/BODY
**Page Playlists** : Styles ajoutés avec `!important`
- `html { font-size: 16px !important; zoom: 1 !important; }`
- `body { font-size: 16px !important; zoom: 1 !important; }`

**Page Scores** : Aucun style global sur html/body dans la page

**Impact** : Les styles dans playlists devraient forcer la taille, mais peut-être qu'un autre style les override.

#### 2. MEDIA QUERIES
**Page Playlists** : 
- `@media (max-width: 768px)` - Réduit `.category-tag` à `font-size: 0.75rem !important`
- `@media (max-width: 768px)` - Ajuste `html, body { max-width: 100vw !important; }`

**Page Scores** :
- `@media (max-width: 640px)` - Seulement pour `.score-section { margin-bottom: 1.5rem; }`

**Impact** : Sur écran < 768px, la page playlists pourrait avoir des ajustements qui affectent la taille.

#### 3. ORDRE DES STYLES
**Page Playlists** : Styles dans `<style>` tag à la fin du fichier (ligne 475+)
**Page Scores** : Styles dans `<style>` tag à la fin du fichier (ligne 438+)

**Impact** : Même ordre, pas de différence.

### 🔍 CAUSE PROBABLE :
Le problème vient probablement d'un **conflit de spécificité CSS** ou d'un **style qui s'applique avant** les styles avec `!important` dans la page playlists. Il faut peut-être :
1. Déplacer les styles en haut de la page (dans le `<head>`)
2. Augmenter la spécificité des sélecteurs
3. Vérifier s'il y a un style dans un fichier CSS externe qui override

