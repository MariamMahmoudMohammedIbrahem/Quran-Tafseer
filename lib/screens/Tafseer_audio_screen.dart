import '../commons.dart';

// ========== Tafseer Audio Screens ==============

/// Screen that displays a list of Quranic Surahs with available Tafsir audio recordings.
///
/// This screen:
/// - Loads Surah data from a JSON file
/// - Filters for unique Surah names
/// - Provides navigation to individual audio player screens
/// - Manages audio player resources
class TafseerAudioScreen extends StatefulWidget {
  const TafseerAudioScreen({super.key});

  @override
  TafseerAudioScreenState createState() => TafseerAudioScreenState();
}

class TafseerAudioScreenState extends State<TafseerAudioScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Map<String, String> uniqueSurahs = {}; // Maps Surah names to their audio URLs

  @override
  void initState() {
    super.initState();
    loadSurahs();
  }

  /// Loads and processes Surah data from JSON assets
  ///
  Future<void> loadSurahs() async {
    // Load JSON data from assets
    final String jsonString = await rootBundle.loadString('assets/json/quran_mp3_links.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    // Process JSON to extract unique Surahs
    for (var item in jsonData) {
      final name = item['sura_name'];
      final url = item['url'];
      if (name != null && url != null && !uniqueSurahs.containsKey(name)) {
        uniqueSurahs[name] = url;
      }
    }

    setState(() {}); // Trigger UI update
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Clean up audio resources
    super.dispose();
  }

  /// Corrects the URL format for direct audio download
  String correctUrl(String url) {
    return url.replaceFirst('details', 'download');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tafsir Recordings'),
        backgroundColor: MyColors.deepGreen,
      ),
      body: uniqueSurahs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: uniqueSurahs.length,
        itemBuilder: (context, index) {
          final surahName = uniqueSurahs.keys.elementAt(index);
          final url = uniqueSurahs[surahName]!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: MyColors.deepGreen,
                foregroundColor: MyColors.darkGreen,
                child: Text('${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              title: Text(
                surahName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: const Text('Tap to listen'),
              trailing: Icon(Icons.play_circle_outline, color: MyColors.darkGreen),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahAudioScreen(
                      title: surahName,
                      url: correctUrl(url),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

