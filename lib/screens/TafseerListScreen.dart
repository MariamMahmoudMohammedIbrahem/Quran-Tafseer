import '../commons.dart';

// ========== Tafseer Screens ==============

/// Main screen displaying list of Surahs with available Tafseer recordings
///
/// Features:
/// - Loads Surah recordings data from JSON
/// - Groups recordings by Surah name
/// - Navigates to recordings list for each Surah
class TafseerListScreen extends StatefulWidget {
  const TafseerListScreen({super.key});

  @override
  _TafseerListScreenState createState() => _TafseerListScreenState();
}

class _TafseerListScreenState extends State<TafseerListScreen> {
  Map<String, List<String>> surahRecordings = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSurahRecordings();
  }

  /// Loads and groups Surah recordings from JSON asset
  Future<void> _loadSurahRecordings() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/quran_mp3_links.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      final Map<String, List<String>> recordings = {};

      for (var item in jsonData) {
        final name = item['sura_name'];
        final url = item['url'];
        if (name != null && url != null) {
          recordings.putIfAbsent(name, () => []);
          recordings[name]!.add(url);
        }
      }

      setState(() {
        surahRecordings = recordings;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ أثناء تحميل التسجيلات';
        isLoading = false;
      });
    }
  }

  /// Corrects URL format for direct download
  String _correctUrl(String url) {
    return url.replaceFirst('details', 'download');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سماع تفسير القرآن')),
      body: _buildBody(),
    );
  }

  /// Builds appropriate body based on current state
  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    return _buildSurahList();
  }

  /// Builds list of Surahs with recordings
  Widget _buildSurahList() {
    return ListView.builder(
      itemCount: surahRecordings.length,
      itemBuilder: (context, index) {
        final surahName = surahRecordings.keys.elementAt(index);
        return _buildSurahItem(context, surahName);
      },
    );
  }

  /// Builds individual Surah list item
  Widget _buildSurahItem(BuildContext context, String surahName) {
    return ListTile(
      title: Text(
        surahName,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => _navigateToRecordings(context, surahName),
    );
  }

  /// Navigates to recordings screen for selected Surah
  void _navigateToRecordings(BuildContext context, String surahName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahRecordingsScreen(
          surahName: surahName,
          recordings: surahRecordings[surahName]!.map(_correctUrl).toList(),
        ),
      ),
    );
  }
}

