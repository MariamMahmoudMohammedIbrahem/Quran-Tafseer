import '../commons.dart';

// --> Onboarding screen that introduces the app with multiple pages
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController(); // Controller for page view
  int _currentPage = 0; // Current page index

  // --> List of onboarding data (image, title, description)
  List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/quran1.png',
      'title': 'مرحبًا بك',
      'desc': 'اكتشف نور القرآن وابدأ رحلتك الروحية معنا',
    },
    {
      'image': 'assets/images/quran2.png',
      'title': 'قراءة سهلة',
      'desc': 'تصفح القرآن الكريم بسلاسة ووضوح',
    },
    {
      'image': 'assets/images/quran3.png',
      'title': 'تفسير مبسط',
      'desc': 'تعرف على المعاني بطريقة سهلة',
    },
    {
      'image': 'assets/images/quran4.png',
      'title': 'ابدأ الآن',
      'desc': 'املأ قلبك بذكر الله وابدأ رحلتك اليوم',
    },
  ];

  // --> Function to finish onboarding and navigate to home screen
  void finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true); // Save onboarding completion
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen()), // Navigate to home
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_currentPage < onboardingData.length - 1)
            TextButton(
              onPressed: finishOnboarding, // Skip onboarding
              child: Text("Skip", style: TextStyle(color: Colors.blue)),
            ),
        ],
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller, // Page view controller
              itemCount: onboardingData.length, // Number of pages
              onPageChanged: (index) {
                setState(() => _currentPage = index); // Update current page
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      onboardingData[index]['image']!, // Display image
                      height: 200,
                    ),
                    SizedBox(height: 30),
                    Text(
                      onboardingData[index]['title']!, // Display title
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        onboardingData[index]['desc']!, // Display description
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // --> Dots indicator for onboarding pages
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
                  (index) => buildDot(index),
            ),
          ),
          SizedBox(height: 20),
          // --> Show "ابدأ" button only on last page
          if (_currentPage == onboardingData.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: finishOnboarding, // Finish onboarding
                child: Text("ابدأ"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  // --> Build single dot for page indicator
  Widget buildDot(int index) {
    return Container(
      height: 10,
      width: _currentPage == index ? 24 : 10, // Active dot is wider
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.green : Colors.grey, // Active color
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
