import '../commons.dart';

// ========== Surah Recordings Screen ==============

/// Screen displaying available recordings for a specific Surah
///
/// Features:
/// - Lists all available recordings for the Surah
/// - Play and download functionality for each recording
/// - Handles download progress and errors
class SurahRecordingsScreen extends StatelessWidget {
  final String surahName;
  final List<String> recordings;

  const SurahRecordingsScreen({
    super.key,
    required this.surahName,
    required this.recordings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيلات $surahName')),
      body: ListView.builder(
        itemCount: recordings.length,
        itemBuilder: (context, index) => _buildRecordingItem(context, index),
      ),
    );
  }

  /// Builds individual recording item with play/download buttons
  Widget _buildRecordingItem(BuildContext context, int index) {
    final url = recordings[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تسجيل ${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          height6,
          Row(
            children: [
              // _buildPlayButton(context, index, url),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('تشغيل'),
                onPressed: () => _navigateToPlayer(context, index, url),
              ),
              width10,
              // _buildDownloadButton(context, url),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('تحميل'),
                onPressed: () => _downloadRecording(context, url),
              )
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  /// Builds play button that navigates to audio player
  // Widget _buildPlayButton(BuildContext context, int index, String url) {
  //   return ElevatedButton.icon(
  //     icon: const Icon(Icons.play_arrow),
  //     label: const Text('تشغيل'),
  //     onPressed: () => _navigateToPlayer(context, index, url),
  //   );
  // }

  /// Builds download button for offline access
  // Widget _buildDownloadButton(BuildContext context, String url) {
  //   return ElevatedButton.icon(
  //     icon: const Icon(Icons.download),
  //     label: const Text('تحميل'),
  //     onPressed: () => _downloadRecording(context, url),
  //   );
  // }

  /// Navigates to audio player screen
  void _navigateToPlayer(BuildContext context, int index, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahAudioScreen(
          title: '$surahName - تسجيل ${index + 1}',
          url: url,
        ),
      ),
    );
  }

  /// Downloads audio file to device storage
  Future<void> _downloadRecording(BuildContext context, String url) async {
    // TODO the download is not working as of yet
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final dir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('تم التحميل مسبقاً')),
        );
        return;
      }

      await Dio().download(url, filePath);
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('تم التحميل بنجاح')),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التحميل: $e')),
      );
    }
  }
}