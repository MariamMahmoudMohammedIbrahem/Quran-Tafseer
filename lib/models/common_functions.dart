import '../commons.dart';

Future<List<Surah>> loadSurahs() async {
  // Load JSON file from assets
  final String jsonString =
  await rootBundle.loadString('assets/json/surahs.json');

  // Parse JSON data into Surah objects
  final List<dynamic> jsonData = json.decode(jsonString);

  return jsonData.map((e) => Surah.fromJson(e)).toList();
  /*setState(() {
    surahs = jsonData.map((e) => Surah.fromJson(e)).toList();
  });*/
}

/// Retrieves Surah number from local JSON assets
Future<int?> getSurahNumberFromAssets(String surahName) async {
  final String jsonString = await rootBundle.loadString('assets/json/surahs.json');
  final List<dynamic> surahList = json.decode(jsonString);

  final surahData = surahList.firstWhere(
        (surah) => surah['name'] == surahName,
    orElse: () => null,
  );

  return surahData?['number'];
}