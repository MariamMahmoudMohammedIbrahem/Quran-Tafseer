export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

export 'dart:convert'; // JSON encoding/decoding

// Localization support
export 'package:flutter_localizations/flutter_localizations.dart'; // For app localization

export 'quran_tafseer.dart'; // App

export 'constants/constants.dart'; // constants
export 'models/surah.dart';
export 'styles/colors.dart';
export 'styles/sizes.dart';
export 'styles/themes.dart';
export 'styles/styles.dart';
export 'utils/ui_utils.dart';

export 'package:shared_preferences/shared_preferences.dart'; // local storage

export 'package:audioplayers/audioplayers.dart'; // Audio player for playing surah recitations

export 'dart:async';

// screens
export 'screens/home_screen.dart'; // Home screen
export 'screens/surah_audio_screen.dart'; // Screen for playing Tafseer audio
export 'screens/TafseerListScreen.dart'; // List of Tafseer options screen
export 'screens/onboarding_screen.dart'; // Onboarding screen
export 'screens/quran_reader.dart'; // Quran reader screen
export 'screens/settings_screen.dart';
export 'screens/splash_screen.dart'; // Splash screen
export 'screens/surah_list_screen.dart'; // Screen showing list of Surahs
export 'screens/tafsir_screen.dart';
