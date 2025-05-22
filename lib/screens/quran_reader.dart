import '../commons.dart';
import 'package:http/http.dart' as http;

class QuranReader extends StatefulWidget {
  final String surahName;
  final int? initialAyahIndex;

  const QuranReader({
    super.key,
    required this.surahName,
    this.initialAyahIndex,
  });

  @override
  State<QuranReader> createState() => _QuranReaderState();
}

class _QuranReaderState extends State<QuranReader> {
  List<String> ayahs = [];
  bool isLoading = true;
  String errorMessage = '';
  static const String _apiBaseUrl = 'https://api.alquran.cloud/v1/surah';
  late BookmarkProvider bookmarkProvider;
  final ScrollController _scrollController = ScrollController(); // ← Scroll controller

  @override
  void initState() {
    super.initState();
    _loadSurahData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bookmarkProvider = Provider.of<BookmarkProvider>(context);
  }

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

        if (widget.initialAyahIndex != null &&
            widget.initialAyahIndex! < ayahs.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              widget.initialAyahIndex! * 80.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        }
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
    final fontSize = Provider.of<ThemeProvider>(context).fontSize;
    return Scaffold(
      appBar: AppBar(title: Text(widget.surahName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: MyColors.red),
        ),
      )
          : ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          final ayahId = '${widget.surahName}_$index';
          final isBookmarked =
          bookmarkProvider.isBookmarked(ayahId);

          return GestureDetector(
            onLongPress: () {
              final ayahText = ayahs[index];
              final bookmark = Bookmark(
                id: ayahId,
                surahName: widget.surahName,
                ayahIndex: index,
                snippet: ayahText,
                createdAt: DateTime.now(),
              );

              if (isBookmarked) {
                bookmarkProvider.removeBookmark(ayahId);
              } else {
                bookmarkProvider.addBookmark(bookmark);
              }

              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: isBookmarked
                    ? Colors.amber.shade100
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: MyColors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${index + 1}. ${ayahs[index]}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'UthmanicHafs',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
