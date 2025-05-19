import '../commons.dart';

// ========== Splash Screen ==============

/// Initial screen shown when the app launches, displaying branding
/// and determining where to navigate next based on onboarding status.
///
/// Features:
/// - Animated logo and text reveal
/// - Checks SharedPreferences for onboarding completion
/// - Navigates to HomeScreen or OnboardingScreen after delay
/// - Displays Quranic verse during animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  static const _splashDuration = Duration(seconds: 8);
  static const _animationDuration = Duration(seconds: 5);
  static const _quranVerse = 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ';

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  /// Starts timer for splash screen and determines next navigation
  void _startSplashTimer() async {
    _timer = Timer(_splashDuration, _navigateBasedOnOnboardingStatus);
  }

  /// Checks onboarding status and navigates to appropriate screen
  Future<void> _navigateBasedOnOnboardingStatus() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => seenOnboarding ? const HomeScreen() : OnboardingScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          _buildAnimatedContent(),
        ],
      ),
    );
  }

  /// Builds the full-screen background image
  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/splashBackground.png',
      fit: BoxFit.cover,
    );
  }

  /// Builds the animated center content (logo + text)
  Widget _buildAnimatedContent() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: _animationDuration,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedLogo(value),
              height16,
              _buildAnimatedText(value),
            ],
          );
        },
      ),
    );
  }

  /// Builds the heart icon with fill animation
  Widget _buildAnimatedLogo(double animationValue) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(
          Icons.favorite,
          size: 120,
          color: MyColors.darkGrey,
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: animationValue,
            child: const Icon(
              Icons.favorite,
              size: 120,
              color: MyColors.redAccent,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the fading in Quran verse text
  Widget _buildAnimatedText(double animationValue) {
    return Opacity(
      opacity: animationValue,
      child: Text(
        _quranVerse,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MyColors.deepGreen,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}