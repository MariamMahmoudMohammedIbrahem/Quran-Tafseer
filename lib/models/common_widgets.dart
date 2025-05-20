import 'package:quraan_tafseer/commons.dart';

// ========== Surah List Item Widget ==============

/// A custom ListTile widget that displays information about a single Surah
///
/// Shows the Surah number, name, type (Makki/Madani), and verse count.
/// Tapping the item navigates to the Quran reader for that Surah.
Widget surahCard (BuildContext context,Surah surah, final onTap){
  return Card(
      child: ListTile(
        // Surah number in a circular avatar
        leading: CircleAvatar(
          backgroundColor: MyColors.deepGreen,
          child: Text('${surah.number}',
              style: const TextStyle(color: MyColors.black)),
        ),
        // Main Surah name with larger font
        title: Text(surah.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Surah type (Makki/Madani)
        subtitle: Text(surah.type),
        // Verse count displayed on the right side
        trailing: Text('${surah.ayahCount} آية'),
        onTap: onTap
        /*() {
          // TODO: Consider using named routes instead of direct navigation
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuranReader(surahName: surah.name)),
          );
        },*/
      )
  );
}

