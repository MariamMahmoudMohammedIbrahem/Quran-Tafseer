import '../commons.dart';

class TafsirScreen extends StatefulWidget {
  const TafsirScreen({super.key});

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("Tafseer Screen")),
      ),
    );
  }
}
