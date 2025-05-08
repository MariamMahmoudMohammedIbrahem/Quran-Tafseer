import '../commons.dart';

// ========== Onboarding Screen ==============

/// Screen that introduces the app features through a guided tour.
///
/// This screen:
/// - Displays a series of onboarding pages with images and descriptions
/// - Tracks completion in SharedPreferences
/// - Provides skip and completion options
/// - Uses a page indicator for navigation
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

/// State management for the OnboardingScreen
class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  /// List of onboarding content (images, titles, descriptions)
  ///

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'مرحبًا بك',
      'desc': 'اكتشف نور القرآن وابدأ رحلتك الروحية معنا',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'قراءة سهلة',
      'desc': 'تصفح القرآن الكريم بسلاسة ووضوح',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'تفسير مبسط',
      'desc': 'تعرف على المعاني بطريقة سهلة',
    },
    {
      'image': 'assets/images/onboarding4.png',
      'title': 'ابدأ الآن',
      'desc': 'املأ قلبك بذكر الله وابدأ رحلتك اليوم',
    },
  ];

  /// Completes the onboarding flow and navigates to home screen
  ///
  /// Marks onboarding as seen in SharedPreferences and replaces
  /// the current route with the HomeScreen
  Future<void> finishOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Skip button (shown on all pages except last)
          if (_currentPage < onboardingData.length - 1)
            TextButton(
              onPressed: finishOnboarding,
              child: Text(
                "تخطي",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MyColors.blackShade,
                ),
              ),
            ),
        ],
        backgroundColor: MyColors.lightWhite,
        elevation: 0,
      ),
      body: Column(
        children: [
          // PageView for onboarding content
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return OnboardingPageContent(
                  image: onboardingData[index]['image']!,
                  title: onboardingData[index]['title']!,
                  description: onboardingData[index]['desc']!,
                );
              },
            ),
          ),

          // Page indicator dots

          // Spacing and "Get Started" button (shown only on last page)
          _buildPageIndicator(),
          height24,
          if (_currentPage == onboardingData.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: finishOnboarding,
                child: const Text("ابدأ"),
              ),
            ),
          height40,
        ],
      ),
    );
  }

  /// Builds the row of page indicator dots
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
            (index) => buildDot(index, _currentPage),
      ),
    );
  }

  /// Creates an individual dot for the page indicator
  ///
  /// [index]: The dot's position in the indicator
  /// [currentPage]: The currently active page index
  // Widget _buildDot(int index, int currentPage) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 4),
  //     width: currentPage == index ? 12 : 8,
  //     height: currentPage == index ? 12 : 8,
  //     decoration: BoxDecoration(
  //       color: currentPage == index ? MyColors.deepGreen : MyColors.darkGrey,
  //       shape: BoxShape.circle,
  //     ),
  //   );
  // }
}

// ========== Onboarding Page Content Widget ==============

/// Reusable widget for displaying onboarding page content
///
/// Shows an image, title, and description in a centered column layout
class OnboardingPageContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPageContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Onboarding image
        Image.asset(
          image,
          height: 200,
        ),

        // Spacing
        height32,

        // Title text
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        // Description text
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}