feat: complete reward system unification and cleanup

## 🎯 Complete System Unification

### ✅ All Generic Rewards Eliminated
- **Removed all 26 generic rewards** (content_type empty/null)
- **100% unified system** - all rewards now have mandatory content_type
- **No more confusion** between generic and specific rewards
- **Consistent user experience** across the platform

### 🔧 Technical Improvements
- Added `validates :content_type, presence: true` to Reward model
- Refactored `check_random_rewards` for unified approach
- Created `select_random_reward_data` for consistent content selection
- Updated `check_reward_condition` to prevent duplicates
- Fixed SQL error in rewards controller (`order(created_at: :desc)`)

### 🎨 UI/UX Enhancements
- **Updated my_rewards view** to show only unlocked rewards
- **Added "next accessible reward" card** with orange background
- **Improved progress tracking** with visual indicators
- **Cleaner interface** with consistent design

### 📊 Final Statistics
- **admin@example.com**: 7 challenge rewards (all with content_type)
- **user@example.com**: 3 rewards (1 challenge + 2 premium)
- **driss@example.com**: 2 premium rewards
- **theo@example.com**: 11 rewards (6 challenge + 2 exclusif + 3 premium)
- **vb@example.com**: 0 rewards
- **test@example.com**: 0 rewards

### 🎁 Reward Types by Level
- **Challenge (3 badges)**: 15 playlist types (challenge_reward_playlist_1-15)
- **Exclusif (6 badges)**: podcast_exclusive, blog_article, documentary
- **Premium (9 badges)**: exclusive_photos, backstage_video
- **Ultime (12 badges)**: personal_voice_message, dedicated_photo

### 🚀 User Impact
- **Cleaner interface**: Only unlocked rewards displayed
- **Progress tracking**: Orange card shows next accessible reward
- **No more confusion**: All rewards have specific, usable content
- **Better UX**: Consistent reward system across the platform

### 🔧 Developer Benefits
- **Simplified codebase**: Removed complex conditional logic
- **Better maintainability**: Unified reward creation system
- **Clearer architecture**: One reward type per level
- **Easier testing**: Consistent reward structure

## 🎯 Result
**100% unified, consistent, and user-friendly reward system** that eliminates all confusion and provides an excellent gaming experience.
