### Task
-Add light/dark theme switching.

-Improve UI to match figma design.

-Add new screens (bookmarks, settings).

### Summary
-This PR enhances the app's theme system and structure by refining visuals, adding theme toggles, and introducing new screens such as bookmarks and surah-related interfaces.

### Changes Made
-Customized text color and background for better readability in both dark and light modes (TODO apply this to all screens)

-Added toggle logic using Switch for theme switching.

-Introduced multiple new screens:

-BookmarksScreen (manage and navigate bookmarks)

-bookmark.dart (Bookmark data model)

-bookmark_provider.dart (Bookmark manager with SharedPreferences)

-main_navigation_screen.dart (App bottom navigation layout)

-quran_options_screen.dart (Quran read/listen options)

-settings_screen.dart (Theme & font settings)

-tafseer_options_screen.dart (Tafsir read/listen options)