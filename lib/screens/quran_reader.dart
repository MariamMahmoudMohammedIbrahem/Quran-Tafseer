import '../commons.dart';

/// Screen to display the selected Surah
class QuranReader extends StatefulWidget {
  final String surahName; // Name of the Surah to display

  const QuranReader({super.key, required this.surahName});

  @override
  State<QuranReader> createState() => _QuranReaderState();
}

class _QuranReaderState extends State<QuranReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Display the Surah name in the AppBar
        title: Text(widget.surahName),
      ),
      body: Column(
        children: [
          // Ayahs of the Surah will be displayed here later
          Text("show ayahs here"),
        ],
      ),
    );
  }
}
