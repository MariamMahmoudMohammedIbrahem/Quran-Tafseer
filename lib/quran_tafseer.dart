import 'commons.dart';

class QuranTafseer extends StatelessWidget {
  const QuranTafseer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()..init()), // تحميل البيانات المحفوظة
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final double scale = themeProvider.fontSize / 18.0;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quraan',
            theme: lightTheme.copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: scale,
                fontFamily: 'Cairo',
              ),
            ),
            darkTheme: darkTheme.copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: scale,
                fontFamily: 'Cairo',
              ),
            ),
            themeMode: themeProvider.themeMode,
            locale: const Locale('ar', ''),
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
