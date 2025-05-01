import '../commons.dart';

// --> Main home screen with buttons to navigate to different app features
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تطبيق القرآن الكريم'), // App title
        backgroundColor: Colors.green[800], // Green app bar
        centerTitle: true, // Center the title
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center all items vertically
            children: [
              Image.asset('assets/images/q.png', height: 120), // Quran image
              SizedBox(height: 40),
              // --> Button to navigate to Quran reading screen
              HomeButton(
                title: 'قراءة القرآن الكريم',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SurahListScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              // --> Button for listening to Quran (not implemented yet)
              HomeButton(
                title: 'سماع القرآن الكريم',
                onTap: () {
                  // Show snack bar indicating the feature is under development
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('الميزة تحت التطوير')),
                  );
                },
              ),
              SizedBox(height: 20),
              // --> Button for reading tafseer (not implemented yet)
              HomeButton(
                title: 'قراءة تفسير القرآن',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('الميزة تحت التطوير')),
                  );
                },
              ),
              SizedBox(height: 20),
              // --> Button to navigate to tafseer audio screen
              HomeButton(
                title: 'سماع تفسير القرآن',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TafseerListScreen()),
                  );
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// --> Reusable button widget used in the home screen
class HomeButton extends StatelessWidget {
  final String title; // Button title
  final VoidCallback onTap; // Action when pressed

  const HomeButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, // Handle button press
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700], // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        elevation: 5, // Shadow elevation
      ),
    );
  }
}
