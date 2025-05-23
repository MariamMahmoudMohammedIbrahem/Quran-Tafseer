import '../commons.dart';

class TafsirScreen extends StatefulWidget {

  final String surahName;
  final String EnglishName;

  const TafsirScreen({super.key, required this.surahName, required this.EnglishName});

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen> {

  List<dynamic> ayat = [];
  int? openedIndex;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString('assets/json/tafseer/${widget.EnglishName}.json');
    final data = json.decode(response);

    if (data != null && data['ayahs'] != null) {
      setState(() {
        ayat = data['ayahs'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تفسير سورة ${widget.surahName}")),
      body: ListView.builder(
        itemCount: ayat.length,
        itemBuilder: (context, index) {
          final ayah = ayat[index];
          final isOpen = openedIndex == index;

          return Column(
            children: [
              ListTile(
                title: Text('تفسير الآية رقم ${ayah['number']}'),
                trailing: Icon(isOpen ? Icons.expand_less : Icons.expand_more),
                onTap: () {
                  setState(() {
                    openedIndex = isOpen ? null : index;
                  });
                },
              ),
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("النص: ${ayah['text']}"),
                      SizedBox(height: 8),
                      Text("التفسير: ${ayah['tafseer']}"),
                      Divider(),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
