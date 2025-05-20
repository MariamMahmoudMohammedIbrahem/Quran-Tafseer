import '../commons.dart';

// ========== Tafseer List Screen ==============

/// A screen that displays the list of all Quranic Surahs (chapters)
///
/// This screen loads Surah data from a local JSON file and presents it in
/// a scrollable list. Each item is tappable to navigate to the Tafseer Screen.

class TafseerListScreen extends StatefulWidget {
  const TafseerListScreen({super.key});

  @override
  State<TafseerListScreen> createState() => _TafseerListScreenState();
}

class _TafseerListScreenState extends State<TafseerListScreen> {

  List<Surah> surahs = [];

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

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
                            builder: (context) => TafsirScreen(surahName: surahs[index].name),
                      ));
                    })
              //SurahItem(surah: surahs[index]),
            ),
          ),
    );
  }
}
