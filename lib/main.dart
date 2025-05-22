import 'commons.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()..init()),
      ],
      child: const QuranTafseer(),
    ),
  );
}
