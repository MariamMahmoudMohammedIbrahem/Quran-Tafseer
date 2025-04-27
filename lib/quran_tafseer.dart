import 'commons.dart';

class QuranTafseer extends StatelessWidget {
  const QuranTafseer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quraan',
      theme: lightTheme,  // Or use darkTheme if needed
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      // Set locale to Arabic and add localization support
      locale: Locale('ar', ''),  // Arabic locale
      supportedLocales: [
        Locale('en', ''),  // English
        Locale('ar', ''),  // Arabic
      ],
      // Add all necessary delegates
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SurahListScreen(),
    );
  }
}