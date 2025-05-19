import '../commons.dart';
import 'package:http/http.dart' as http;

// ========== Quran Reader Screen ==============

/// Screen that displays the full text of a Quranic Surah (chapter) in Arabic.
///
/// Features:
/// - Loads Surah data from local JSON to get Surah number
/// - Fetches Surah text from AlQuran Cloud API
/// - Displays verses in a scrollable list
/// - Handles loading and error states
class QuranReader extends StatefulWidget {
  final String surahName;

  const QuranReader({super.key, required this.surahName});

  @override
  State<QuranReader> createState() => _QuranReaderState();
}

class _QuranReaderState extends State<QuranReader> {
  List<String> ayahs = [];
  bool isLoading = true;
  String errorMessage = '';
  static const String _apiBaseUrl = 'https://api.alquran.cloud/v1/surah';

  @override
  void initState() {
    super.initState();
    _loadSurahData();
  }

  /// Loads Surah data from local JSON and initiates API fetch
  Future<void> _loadSurahData() async {
    try {
      final surahNumber = await getSurahNumberFromAssets(widget.surahName);
      if (surahNumber != null) {
        await _fetchSurahText(surahNumber);
      } else {
        setState(() {
          errorMessage = 'السورة غير موجودة في الملف';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ أثناء قراءة الملف: $e';
        isLoading = false;
      });
    }
  }

  /// Retrieves Surah number from local JSON assets
  /*
  Future<int?> _getSurahNumberFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/json/surahs.json');
    final List<dynamic> surahList = json.decode(jsonString);

    final surahData = surahList.firstWhere(
          (surah) => surah['name'] == widget.surahName,
      orElse: () => null,
    );

    return surahData?['number'];
  }
  */

  /// Fetches Surah text from AlQuran Cloud API
  Future<void> _fetchSurahText(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/$surahNumber/ar.alafasy'),

      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> ayahList = data['data']['ayahs'];

        setState(() {
          ayahs = ayahList.map((ayah) => ayah['text'] as String).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'فشل تحميل السورة: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'حدث خطأ أثناء تحميل السورة: $e';
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
      title: Text(widget.surahName),
      // TODO: Add bookmark
    );
  }

  /// Builds the main content body based on current state
  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingIndicator();
    } else if (errorMessage.isNotEmpty) {
      return _buildErrorDisplay();
    } else {
      return _buildSurahText();
    }
  }

  /// Shows loading indicator while fetching data
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Displays error message if loading fails
  Widget _buildErrorDisplay() {
    return Center(
      child: Text(
        errorMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: MyColors.red),
      ),
    );
  }

  /// Builds the scrollable list of Quran verses
  Widget _buildSurahText() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ayahs.length,
      itemBuilder: (context, index) => _buildAyahItem(index),
    );
  }

  /// Builds individual verse item
  Widget _buildAyahItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '${index + 1}. ${ayahs[index]}',
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'UthmanicHafs', // TODO: Add proper font
        ),
      ),
    );
  }
}