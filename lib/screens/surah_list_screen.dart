import '../commons.dart';

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

  Future<void> loadSurahs() async {
    final String jsonString = await rootBundle.loadString('assets/surahs.json');
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
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Text('${surah.number}', style: TextStyle(color: Colors.black)),
        ),
        title: Text(surah.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(surah.type),
        trailing: Text('${surah.ayahCount} آية'),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> QuranReader(surahName: surah.name),),);
        },
      ),
    );
  }
}
