class Surah {
  final int number;
  final String name;
  final String type;
  final int ayahCount;

  Surah({
    required this.number,
    required this.name,
    required this.type,
    required this.ayahCount,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      type: json['type'],
      ayahCount: json['ayahCount'],
    );
  }
}
