import '../commons.dart';

// ========== Quran Audio List Screen ==============

/// Screen that displays a list of Quranic Surahs for audio playback selection.
///
/// Features:
/// - Loads Surah data from local JSON file
/// - Displays loading indicator while fetching data
/// - Navigates to audio player screen when Surah is selected
/// - Shows Surah details (type and verse count)
class QuranAudioListScreen extends StatefulWidget {
  @override
  _QuranAudioListScreenState createState() => _QuranAudioListScreenState();
}

/// State management for QuranAudioListScreen
class _QuranAudioListScreenState extends State<QuranAudioListScreen> {
  List<dynamic> surahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  /// Loads Surah data from local JSON asset file
  ///
  /// TODO: Add error handling for JSON parsing failures
  /// TODO: Implement caching mechanism for better performance
  Future<void> _loadSurahs() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/surahs.json');
      final data = json.decode(jsonString);

      setState(() {
        surahs = data;
        isLoading = false;
      });
    } catch (e) {
      // TODO: Show error message to user
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// Builds the screen's app bar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('اختر السورة'),
      // TODO: Add search functionality in app bar
    );
  }

  /// Builds the main content body based on loading state
  Widget _buildBody() {
    return isLoading
        ? _buildLoadingIndicator()
        : _buildSurahList();
  }

  /// Shows loading indicator while data is being fetched
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Builds the scrollable list of Surahs
  Widget _buildSurahList() {
    return ListView.builder(
      itemCount: surahs.length,
      itemBuilder: (context, index) => _buildSurahItem(index),
    );
  }

  /// Builds individual Surah list item
  Widget _buildSurahItem(int index) {
    final surah = surahs[index];
    return ListTile(
      title: Text(
        surah['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${surah['type']} - ${surah['ayahCount']} آية',
        style: const TextStyle(color: MyColors.darkGrey),
      ),
      trailing: const Icon(Icons.play_arrow, color: MyColors.red),
      onTap: () => _navigateToAudioScreen(context, surah),
    );
  }

  /// Navigates to the audio player screen for selected Surah
  void _navigateToAudioScreen(BuildContext context, dynamic surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuranAudioScreen(
          surahNumber: surah['number'],
          surahName: surah['name'],
        ),
      ),
    );
  }
}
