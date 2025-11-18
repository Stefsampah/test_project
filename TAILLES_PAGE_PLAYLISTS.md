# Tailles exactes des éléments de la page Playlists

## Structure HTML (éléments visibles en haut de page)

```html
<!-- Navigation (dans layout) -->
<div class="nav-content">
  <a class="logo">...</a>
  <div class="main-menu">...</div>
  <div class="user-menu">...</div>
</div>

<!-- Notification partie en cours (dans layout) -->
<div class="flash" id="game-in-progress-notification">
  <div class="flash-notice">
    <span>🎮 Vous avez une partie en cours : ...</span>
    <a>Reprendre la partie</a>
  </div>
</div>

<!-- Contenu de la page Playlists -->
<div class="min-h-screen bg-gray-900 py-0">
  <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
    <!-- Titre -->
    <div class="text-center mb-4">
      <h1 class="text-2xl font-bold text-white">Playlists</h1>
    </div>
    
    <!-- Boutons de filtrage -->
    <div class="flex justify-center mb-8">
      <div class="flex space-x-2">
        <button class="filter-btn active px-4 py-2 rounded-lg text-sm font-medium">Toutes les playlists</button>
        <button class="filter-btn px-4 py-2 rounded-lg text-sm font-medium">Mes playlists</button>
      </div>
    </div>
  </div>
</div>
```

## Tailles exactes

### 1. NAVIGATION (dans layout - identique partout)

#### `.nav-content` (conteneur)
- **height**: `64px`
- **display**: `flex`
- **align-items**: `center`
- **justify-content**: `space-between`

#### `.logo` (logo + nom de l'app)
- **font-size**: `1.25rem` = **20px**
- **padding**: `0.5rem` = **8px**
- **font-weight**: `bold`

#### `.logo img` (image du logo)
- **width**: `32px` (w-8)
- **height**: `32px` (h-8)
- **margin-right**: `0.5rem` = **8px**

#### `.logo span` (texte "Tube'NPlay")
- **font-size**: Hérite = **20px**

#### `.nav-link` (liens de navigation)
- **font-size**: `0.9rem` = **14.4px**
- **padding**: `0.5rem 0.75rem` = **8px vertical, 12px horizontal**

---

### 2. NOTIFICATION "Vous avez une partie en cours" (dans layout)

#### `.flash` (conteneur)
- **max-width**: `1200px`
- **margin**: `1rem auto` = **16px auto**
- **padding**: `0 1rem` = **0px vertical, 16px horizontal**

#### `.flash-notice` (conteneur de la notification)
- **padding**: `0.75rem 1rem` = **12px vertical, 16px horizontal**
- **border-radius**: `0.375rem` = **6px**
- **margin-bottom**: `1rem` = **16px**
- **font-size**: `1rem` = **16px** (style inline)
- **display**: `flex`
- **align-items**: `center`
- **justify-content**: `space-between`
- **gap**: `1rem` = **16px**

#### `.flash-notice span` (texte de la notification)
- **font-size**: `1rem` = **16px** (style inline)
- **flex**: `1`
- **min-width**: `200px`

#### `.flash-notice a` (bouton "Reprendre la partie")
- **font-size**: `1rem` = **16px** (style inline)
- **padding**: `px-4 py-2` = **1rem horizontal, 0.5rem vertical** = **16px × 8px**
- **border-radius**: `rounded` = **0.25rem** = **4px**
- **font-weight**: `font-semibold` = **600**

---

### 3. CONTENEUR PRINCIPAL DE LA PAGE

#### `.min-h-screen` (conteneur principal)
- **min-height**: `100vh`
- **padding**: `py-0` = **0px vertical**

#### `.max-w-6xl` (conteneur interne)
- **max-width**: `72rem` = **1152px**
- **margin**: `mx-auto` = **0 auto**
- **padding**: `px-4 sm:px-6 lg:px-8` = **16px / 24px / 32px horizontal**

---

### 4. TITRE DE LA PAGE

#### Conteneur du titre
- **text-align**: `center`
- **margin-bottom**: `mb-4` = **1rem** = **16px**

#### `h1.text-2xl.font-bold.text-white` ("Playlists")
- **font-size**: `1.5rem` = **24px** (forcé avec !important, ligne 598)
- **font-weight**: `700` (forcé avec !important)
- **line-height**: `1.2` (forcé avec !important)
- Classes Tailwind: `text-2xl` = 1.5rem = 24px

---

### 5. BOUTONS DE FILTRAGE

#### Conteneur des boutons
- **display**: `flex`
- **justify-content**: `center`
- **margin-bottom**: `mb-8` = **2rem** = **32px**

#### Conteneur interne
- **display**: `flex`
- **gap**: `space-x-2` = **0.5rem** = **8px** entre les boutons

#### `.filter-btn` (bouton de filtrage)
- **font-size**: `0.875rem` = **14px** (text-sm)
- **padding**: `px-4 py-2` = **1rem horizontal, 0.5rem vertical** = **16px × 8px**
- **border-radius**: `rounded-lg` = **0.5rem** = **8px**
- **font-weight**: `font-medium` = **500**
- Classes Tailwind: `text-sm` = 0.875rem = 14px

#### `.filter-btn.active` (bouton actif)
- **background-color**: `#9333ea` (violet)

---

## Résumé des dimensions

| Élément | Taille |
|---------|--------|
| **Navigation** |
| `.nav-content` height | **64px** |
| `.logo` font-size | **20px** (1.25rem) |
| `.logo` padding | **8px** (0.5rem) |
| `.logo img` | **32px × 32px** |
| `.nav-link` font-size | **14.4px** (0.9rem) |
| `.nav-link` padding | **8px × 12px** |
| **Notification** |
| `.flash` max-width | **1200px** |
| `.flash` padding | **0px × 16px** |
| `.flash-notice` padding | **12px × 16px** |
| `.flash-notice` font-size | **16px** (1rem) |
| `.flash-notice span` font-size | **16px** (1rem) |
| `.flash-notice a` font-size | **16px** (1rem) |
| `.flash-notice a` padding | **8px × 16px** (py-2 px-4) |
| **Page Playlists** |
| `.max-w-6xl` max-width | **1152px** (72rem) |
| `.max-w-6xl` padding | **16px / 24px / 32px** (responsive) |
| `h1` font-size | **24px** (1.5rem) |
| `h1` margin-bottom | **16px** (mb-4) |
| `.filter-btn` font-size | **14px** (0.875rem) |
| `.filter-btn` padding | **8px × 16px** (py-2 px-4) |
| `.filter-btn` border-radius | **8px** (rounded-lg) |
| Gap entre boutons | **8px** (space-x-2) |

## Comparaison avec la page Scores

| Élément | Page Scores | Page Playlists | Identique ? |
|---------|-------------|----------------|-------------|
| `.nav-content` height | 64px | 64px | ✅ |
| `.logo` font-size | 20px | 20px | ✅ |
| `.nav-link` font-size | 14.4px | 14.4px | ✅ |
| `.flash-notice` padding | 12px × 16px | 12px × 16px | ✅ |
| `.flash-notice` font-size | 16px | 16px | ✅ |
| `h1` font-size | 24px | 24px | ✅ |
| Boutons font-size | 14px | 14px | ✅ |
| Boutons padding | 8px × 16px | 8px × 16px | ✅ |

**Conclusion** : Tous les éléments ont les mêmes dimensions sur les deux pages.

