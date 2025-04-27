import '../commons.dart';

class QuranReader extends StatefulWidget {
  final String surahName;
  const QuranReader({super.key, required this.surahName});

  @override
  State<QuranReader> createState() => _QuranReaderState();
}

class _QuranReaderState extends State<QuranReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
      ),
      body: Column(
        children: [
          Text("show ayahs here"),
        ],
      ),
    );
  }
}
