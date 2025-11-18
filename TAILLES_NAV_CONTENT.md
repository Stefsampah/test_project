# Tailles exactes des éléments de `.nav-content`

## Structure HTML
```html
<div class="nav-content">
  <!-- Logo -->
  <a class="logo">
    <img class="w-8 h-8 mr-2">
    <span>Tube'<span style="color: #9333ea;">N</span>Play</span>
  </a>
  
  <!-- Menu principal -->
  <div class="main-menu">
    <a class="nav-link">...</a>
  </div>
  
  <!-- Menu utilisateur -->
  <div class="user-menu">
    <span class="nav-link">...</span>
    <a class="nav-link">...</a>
  </div>
  
  <!-- Bouton menu mobile -->
  <button class="mobile-menu-button">
    <svg class="w-6 h-6">...</svg>
  </button>
</div>
```

## Tailles exactes (depuis `app/views/layouts/application.html.erb`)

### 1. `.nav-content` (conteneur principal)
- **height**: `64px` (ligne 33)
- **display**: `flex`
- **align-items**: `center`
- **justify-content**: `space-between`

### 2. `.logo` (lien avec logo et nom)
- **font-size**: `1.25rem` = **20px** (ligne 40)
- **font-weight**: `bold`
- **padding**: `0.5rem` = **8px** (ligne 44)
- **border-radius**: `0.375rem` = **6px**

### 3. `.logo img` (image du logo)
- **width**: `32px` (ligne 54)
- **height**: `32px` (ligne 55)
- **margin-right**: `0.5rem` = **8px** (ligne 56)
- Classes Tailwind: `w-8 h-8` = 32px × 32px

### 4. `.logo span` (texte "Tube'NPlay")
- **font-size**: Hérite de `.logo` = `1.25rem` = **20px**
- Le "N" en violet: `color: #9333ea` (style inline)

### 5. `.main-menu` (menu principal)
- **display**: `flex` (ligne 60)
- **gap**: `1.5rem` = **24px** (ligne 61)

### 6. `.nav-link` (liens de navigation)
- **font-size**: `0.9rem` = **14.4px** (ligne 72)
- **padding**: `0.5rem 0.75rem` = **8px vertical, 12px horizontal** (ligne 73)
- **border-radius**: `0.375rem` = **6px** (ligne 74)

### 7. `.user-menu` (menu utilisateur)
- **display**: `flex` (ligne 65)
- **gap**: `1rem` = **16px** (ligne 66)

### 8. `.mobile-menu-button` (bouton menu mobile)
- **padding**: `0.5rem` = **8px** (ligne 93)
- **display**: `none` (par défaut, ligne 88)

### 9. `.mobile-menu-button svg` (icône hamburger)
- Classes Tailwind: `w-6 h-6` = **24px × 24px**

## Résumé des dimensions

| Élément | Taille |
|---------|--------|
| `.nav-content` height | **64px** |
| `.logo` font-size | **20px** (1.25rem) |
| `.logo` padding | **8px** (0.5rem) |
| `.logo img` | **32px × 32px** |
| `.logo img` margin-right | **8px** (0.5rem) |
| `.nav-link` font-size | **14.4px** (0.9rem) |
| `.nav-link` padding | **8px × 12px** (0.5rem × 0.75rem) |
| `.main-menu` gap | **24px** (1.5rem) |
| `.user-menu` gap | **16px** (1rem) |
| `.mobile-menu-button` padding | **8px** (0.5rem) |
| `.mobile-menu-button svg` | **24px × 24px** (w-6 h-6) |

## Responsive (mobile < 1024px)

### `.logo` (ligne 165-168)
- **font-size**: `1rem` = **16px**
- **padding**: `0.25rem` = **4px**

### `.logo svg` (ligne 170-173)
- **width**: `24px`
- **height**: `24px`

