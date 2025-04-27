import '../commons.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: MyColors.deepGreen,  // Deep Green
  scaffoldBackgroundColor: MyColors.lightBeige,  // Light Beige
  fontFamily: 'Cairo',
  appBarTheme: const AppBarTheme(
    backgroundColor: MyColors.deepGreen,  // Deep Green
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: MyColors.deepGreen),  // Deep Green icons
  cardColor: MyColors.lightWhite,  // Soft background for cards
);

final ThemeData darkTheme = ThemeData(
  primaryColor: MyColors.darkGreen,  // Dark Green
  scaffoldBackgroundColor: MyColors.blackShade,  // Dark background
  fontFamily: 'Cairo',
  appBarTheme: const AppBarTheme(
    backgroundColor: MyColors.darkGreen,  // Dark Green
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  cardColor: MyColors.darkGrey,  // Dark cards
);
