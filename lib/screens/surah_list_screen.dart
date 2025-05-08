import '../commons.dart';

// ========== Quran Surah List Screen ==============

/// A screen that displays the list of all Quranic Surahs (chapters)
///
/// This screen loads Surah data from a local JSON file and presents it in
/// a scrollable list. Each item is tappable to navigate to the Quran reader.
class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  List<Surah> surahs = [];

  @override
  void initState() {
    super.initState();
    loadSurahs();
  }

  /// Loads Surah data from the local JSON file
  ///
  /// TODO: Consider implementing caching mechanism for better performance
  /// TODO: Add error handling for JSON parsing failures
  Future<void> loadSurahs() async {
    // Load JSON file from assets
    final String jsonString = await rootBundle.loadString('assets/json/surahs.json');

    // Parse JSON data into Surah objects
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      surahs = jsonData.map((e) => Surah.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سور القرآن الكريم")),
      body: surahs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: surahs.length,
          itemBuilder: (context, index) => SurahItem(surah: surahs[index]),
        ),
      ),
    );
  }
}

// ========== Surah List Item Widget ==============

/// A custom ListTile widget that displays information about a single Surah
///
/// Shows the Surah number, name, type (Makki/Madani), and verse count.
/// Tapping the item navigates to the Quran reader for that Surah.
class SurahItem extends StatelessWidget {
  final Surah surah;

  const SurahItem({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // Surah number in a circular avatar
        leading: CircleAvatar(
          backgroundColor: MyColors.deepGreen,
          child: Text('${surah.number}', style: const TextStyle(color: MyColors.black)),
        ),
        // Main Surah name with larger font
        title: Text(surah.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Surah type (Makki/Madani)
        subtitle: Text(surah.type),
        // Verse count displayed on the right side
        trailing: Text('${surah.ayahCount} آية'),
        onTap: () {
          // TODO: Consider using named routes instead of direct navigation
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuranReader(surahName: surah.name)),
          );
        },
      ),
    );
  }
}