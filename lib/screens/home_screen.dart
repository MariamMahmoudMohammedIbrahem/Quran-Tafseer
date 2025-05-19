import '../commons.dart';

// ========== Home Screen Components ==============

/// A reusable custom button widget for home screen actions.
///
/// Features:
/// - Customizable title, colors, and tap handler
/// - Full-width button with consistent styling
/// - Default colors from app theme
///
/// Example:
/// ```dart
/// HomeButton(
///   title: 'Read Quran',
///   onTap: () => navigateToQuran(),
///   color: MyColors.deepGreen,
///   textColor: MyColors.lightWhite,
/// )
/// ```
class HomeButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  const HomeButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color = MyColors.deepGreen,
    this.textColor = MyColors.lightWhite,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      // style: ElevatedButton.styleFrom(
      //   backgroundColor: color,
      //   minimumSize: const Size(double.infinity, 50),
      //
      // ),
      style: elevatedButtonStyle(color),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,

        ),
      ),
    );
  }
}

// ========== Main Home Screen ==============

/// The primary home screen of the Quran application.
///
/// Displays:
/// - App logo/image
/// - Four main action buttons
/// - Consistent app bar styling
///
/// Navigation:
/// - Quran reading
/// - Quran audio
/// - Tafseer (under development)
/// - Tafseer audio
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightBeige,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  /// Builds the consistent app bar for the home screen
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'تطبيق القرآن الكريم',
        style: TextStyle(color: MyColors.lightWhite),
      ),
      backgroundColor: MyColors.deepGreen,
      centerTitle: true,
      iconTheme: const IconThemeData(color: MyColors.lightWhite),

    );
  }

  /// Constructs the main content body of the home screen
  Widget _buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAppLogo(),
            height40,
            _buildActionButtons(context),
            height32,
          ],
        ),
      ),
    );
  }

  /// Displays the application logo/image
  Widget _buildAppLogo() {
    return Image.asset(
      'assets/images/homescreen_photo.png',
      height: 120,

    );
  }

  /// Creates the column of action buttons
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          buildHomeButton(
            title: 'قراءة القرآن الكريم',
            onTap: () => _navigateTo(context, SurahListScreen()),
          ),
          height16,
          buildHomeButton(
            title: 'سماع القرآن الكريم',
            onTap: () => _navigateTo(context, QuranAudioListScreen()),
          ),
          height16,
          buildHomeButton(
            title: 'قراءة تفسير القرآن',
            onTap: () => _navigateTo(context, TafseerListScreen()),
          ),
          height16,
          buildHomeButton(
            title: 'سماع تفسير القرآن',
            onTap: () => _navigateTo(context, TafseerAudioScreen()),
          ),
        ],
      ),
    );
  }

  /// Button for navigating to Quran reading screen
  // Widget _buildQuranReadingButton(BuildContext context) {
  //   return HomeButton(
  //     title: 'قراءة القرآن الكريم',
  //     color: MyColors.darkGreen,
  //     textColor: MyColors.lightWhite,
  //     onTap: () => _navigateTo(context, SurahListScreen()),
  //   );
  // }
  //
  // /// Button for navigating to Quran audio screen
  // Widget _buildQuranAudioButton(BuildContext context) {
  //   return HomeButton(
  //     title: 'سماع القرآن الكريم',
  //     color: MyColors.darkGreen,
  //     textColor: MyColors.lightWhite,
  //     onTap: () => _navigateTo(context, QuranAudioListScreen()),
  //   );
  // }
  //
  // /// Button for (future) Tafseer reading feature
  // Widget _buildTafseerReadingButton(BuildContext context) {
  //   return HomeButton(
  //     title: 'قراءة تفسير القرآن',
  //     color: MyColors.darkGreen,
  //     textColor: MyColors.lightWhite,
  //     onTap: () => _showUnderDevelopmentSnackbar(context),
  //   );
  // }
  //
  // /// Button for navigating to Tafseer audio screen
  // Widget _buildTafseerAudioButton(BuildContext context) {
  //   return HomeButton(
  //     title: 'سماع تفسير القرآن',
  //     color: MyColors.darkGreen,
  //     textColor: MyColors.lightWhite,
  //     onTap: () => _navigateTo(context, TafseerListScreen()),
  //   );
  // }

  Widget buildHomeButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return HomeButton(
      title: title,
      color: MyColors.darkGreen,
      textColor: MyColors.lightWhite,
      onTap: onTap,
    );
  }


  /// Helper method for navigation
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Shows under development notification
  void _showUnderDevelopmentSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('الميزة تحت التطوير')),
    );
  }
}