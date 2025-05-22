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
    _loadSurahs();
  }

  /// Loads Surah data from the local JSON file
  ///
  /// TODO: Consider implementing caching mechanism for better performance
  /// TODO: Add error handling for JSON parsing failures

  Future<void> _loadSurahs() async {
    final loadedSurahs = await loadSurahs();
    setState(() {
      surahs = loadedSurahs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سور القرآن الكريم")),
      backgroundColor: MyColors.red,
      //backgroundColor: themeNotifier.value == ThemeMode.dark? MyColors.black : MyColors.red,
      body: surahs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                  itemCount: surahs.length,
                  itemBuilder: (context, index) =>
                      surahCard(context, surahs[index], () {
                        // TODO: Consider using named routes instead of direct navigation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuranReader(surahName: surahs[index].name)),
                        );
                      })
                  //SurahItem(surah: surahs[index]),
                  ),
            ),
    );
  }
}