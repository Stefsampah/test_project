feat: unify reward system and fix display issues

## 🎯 Major Changes

### Unified Reward System
- **Removed confusion** between "generic" and "specific" rewards
- **Added mandatory content_type** for all rewards
- **Simplified logic** to one reward per level per user
- **Eliminated duplicates** by checking only reward_type

### Code Improvements
- Added `validates :content_type, presence: true` to Reward model
- Refactored `check_random_rewards` method for unified approach
- Created `select_random_reward_data` method for consistent content selection
- Updated `check_reward_condition` to prevent duplicates

### UI/UX Enhancements
- **Fixed SQL error** in rewards controller (`order(created_at: :desc)` instead of `order(:created_at, :desc)`)
- **Updated my_rewards view** to show only unlocked rewards
- **Added "next accessible reward" card** with orange background for progress tracking
- **Improved user experience** with clearer reward progression

### Technical Details
- **Reward structure**: All rewards now have mandatory content_type
- **Challenge rewards**: 15 playlist types (challenge_reward_playlist_1-15)
- **Exclusif rewards**: podcast_exclusive, blog_article, documentary
- **Premium rewards**: exclusive_photos, backstage_video
- **Ultime rewards**: personal_voice_message, dedicated_photo

### Migration
- Created `clean_generic_rewards.rb` script for data migration
- **17 generic rewards** identified and processed
- **6 users** with challenge playlist rewards for testing
- **Admin user** has 6 challenge playlist rewards (ID: 19-24)

## 🎮 User Impact
- **Cleaner interface**: Only unlocked rewards displayed
- **Progress tracking**: Orange card shows next accessible reward
- **No more confusion**: All rewards have specific content
- **Better UX**: Consistent reward system across the platform

## 🔧 Developer Benefits
- **Simplified codebase**: Removed complex conditional logic
- **Better maintainability**: Unified reward creation system
- **Clearer architecture**: One reward type per level
- **Easier testing**: Consistent reward structure

## 📊 Testing
- **Test users identified**: admin@example.com, user@example.com, theo@example.com
- **Challenge playlists**: 6 playlists with 10 videos each
- **Reward progression**: 3, 6, 9, 12 badges for different levels
- **Content types**: All rewards have specific, usable content

## 🎯 Result
**Unified, consistent, and user-friendly reward system** that eliminates confusion and provides a better gaming experience.
