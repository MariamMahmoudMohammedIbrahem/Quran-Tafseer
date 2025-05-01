import '../commons.dart';

/// This screen displays a list of Quran Surahs (with unique names)
/// that have Tafsir audio recordings. Clicking on a Surah navigates
/// to the audio player screen.
class TafseerAudioScreen extends StatefulWidget {
  @override
  _TafseerAudioScreenState createState() => _TafseerAudioScreenState();
}

class _TafseerAudioScreenState extends State<TafseerAudioScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Map<String, String> uniqueSurahs = {}; // Holds unique Surah names and their audio URLs

  @override
  void initState() {
    super.initState();
    loadSurahs(); // Load JSON file containing surah names and audio URLs
  }

  Future<void> loadSurahs() async {
    final String jsonString = await rootBundle.loadString('assets/json/quran_mp3_links.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    // Fill uniqueSurahs with unique Surah names
    for (var item in jsonData) {
      final name = item['sura_name'];
      final url = item['url'];
      if (name != null && url != null && !uniqueSurahs.containsKey(name)) {
        uniqueSurahs[name] = url;
      }
    }

    setState(() {}); // Refresh UI after loading data
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Free up audio resources
    super.dispose();
  }

  String correctUrl(String url) {
    return url.replaceFirst('details', 'download'); // Fix URL for direct download
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tafsir Recordings'),
        backgroundColor: Colors.green[800],
      ),
      body: uniqueSurahs.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
        itemCount: uniqueSurahs.length,
        itemBuilder: (context, index) {
          final surahName = uniqueSurahs.keys.elementAt(index);
          final url = uniqueSurahs[surahName]!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.green[800],
                child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              title: Text(
                surahName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: const Text('Tap to listen'),
              trailing: Icon(Icons.play_circle_outline, color: Colors.green[800]),
              onTap: () {
                // Navigate to the audio player screen for this Surah
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahAudioScreen(
                      title: surahName,
                      url: correctUrl(url),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// This screen plays the Tafsir audio of a selected Surah with
/// controls like play, pause, seek, speed adjustment.
class SurahAudioScreen extends StatefulWidget {
  final String title;
  final String url;

  const SurahAudioScreen({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  _SurahAudioScreenState createState() => _SurahAudioScreenState();
}

class _SurahAudioScreenState extends State<SurahAudioScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  bool _isLoading = false;
  String _errorMessage = '';
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackRate = 1.0;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer(); // Setup audio listeners
  }

  Future<void> _setupAudioPlayer() async {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _playerState = state; // Update play/pause/stop status
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _duration = duration; // Total duration of the audio
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() {
        _position = position; // Current playback position
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero; // Reset position when finished
      });
    });
  }

  Future<void> _playAudio() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      await _audioPlayer.play(UrlSource(widget.url)); // Start playing the audio
      await _audioPlayer.setPlaybackRate(_playbackRate); // Set playback speed

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error playing audio: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause(); // Pause audio
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop(); // Stop audio
    setState(() {
      _position = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds'; // Format hh:mm:ss
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Free audio resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.audiotrack, size: 80, color: Colors.green[800]),
            const SizedBox(height: 20),
            Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator() // Show loading while fetching
            else if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage, // Show error message if any
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            Directionality( // Force LTR for the slider
              textDirection: TextDirection.ltr,
              child: Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
                onChanged: (value) async {
                  await _audioPlayer.seek(Duration(seconds: value.toInt())); // Seek in audio
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_duration - _position)), // Remaining time
                  Text(_formatDuration(_position)), // Current time
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.skip_previous, size: 36), onPressed: () {}),
                IconButton(
                  icon: Icon(
                    _playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow,
                    size: 48,
                  ),
                  onPressed: () async {
                    if (_playerState == PlayerState.playing) {
                      await _pauseAudio();
                    } else {
                      await _playAudio();
                    }
                  },
                ),
                IconButton(icon: const Icon(Icons.skip_next, size: 36), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Speed: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<double>(
                  value: _playbackRate,
                  items: const [
                    DropdownMenuItem(value: 0.75, child: Text('0.75x')),
                    DropdownMenuItem(value: 1.0, child: Text('1x')),
                    DropdownMenuItem(value: 1.25, child: Text('1.25x')),
                    DropdownMenuItem(value: 1.5, child: Text('1.5x')),
                    DropdownMenuItem(value: 2.0, child: Text('2x')),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        _playbackRate = value;
                      });
                      await _audioPlayer.setPlaybackRate(value); // Change playback speed
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Audio quality: MP3', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
