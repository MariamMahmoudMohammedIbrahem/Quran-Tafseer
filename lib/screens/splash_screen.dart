import '../commons.dart';
//unused code
/// Splash screen that appears when the app starts
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer; // Timer to control navigation delay

  @override
  void initState() {
    super.initState();

    // Start a 20-second timer, then navigate to HomeScreen
    _timer = Timer(Duration(seconds: 20), () {
      if (mounted) { // Ensure the widget is still in the widget tree
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: Islamic pattern image
          Image.asset(
            'assets/z2.png',
            fit: BoxFit.cover,
          ),

          // Content: animated heart + Quranic verse
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(seconds: 5), // Animation duration
              builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Heart animation with progressive fill from bottom to top
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 120,
                          color: Colors.grey[300], // Grey background heart
                        ),
                        ClipRect(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            heightFactor: value, // Filling percentage
                            child: Icon(
                              Icons.favorite,
                              size: 120,
                              color: Colors.redAccent, // Red fill color
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Gradual appearance of the Quranic verse
                    Opacity(
                      opacity: value,
                      child: Text(
                        'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
