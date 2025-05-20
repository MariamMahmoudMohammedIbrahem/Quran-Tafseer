import '../commons.dart';

// ========== Quran Audio Player Screen ==============

/// Screen that provides audio playback for Quranic Surahs.
///
/// Features:
/// - Streams audio from MP3 server
/// - Play/pause controls
/// - Seek functionality (+/- 10 seconds)
/// - Progress tracking
/// - Duration display
class QuranAudioScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const QuranAudioScreen({
    Key? key,
    required this.surahNumber,
    required this.surahName,
  }) : super(key: key);

  @override
  _QuranAudioScreenState createState() => _QuranAudioScreenState();
}

class _QuranAudioScreenState extends State<QuranAudioScreen> {
  late final AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  static const String serverBaseUrl = 'https://server8.mp3quran.net/afs';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _setupAudioListeners();
  }

  /// Sets up audio player event listeners
  void _setupAudioListeners() {
    audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() => currentPosition = position);
      }
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() => totalDuration = duration);
      }
    });

    audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => isPlaying = false);
      }
    });
  }

  /// Builds the audio URL for the current Surah
  String _buildAudioUrl() {
    final paddedNumber = widget.surahNumber.toString().padLeft(3, '0');
    return '$serverBaseUrl/$paddedNumber.mp3';
  }

  /// Starts or resumes audio playback
  Future<void> _playAudio() async {
    try {
      await audioPlayer.play(UrlSource(_buildAudioUrl()));
      setState(() => isPlaying = true);
    } catch (e) {

      if (mounted) {
        setState(() => isPlaying = false);
      }
    }
  }

  /// Pauses audio playback
  Future<void> _pauseAudio() async {
    await audioPlayer.pause();
    setState(() => isPlaying = false);
  }

  /// Seeks to specific position in audio
  Future<void> _seekAudio(Duration position) async {
    await audioPlayer.seek(position);
  }

  /// Formats duration as HH:MM:SS
  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, "0");
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildPlayerBody(),
    );
  }

  /// Builds the screen's app bar
  AppBar _buildAppBar() {
    return AppBar(
      title: Text('سورة ${widget.surahName}'),
    );
  }

  /// Builds the main player interface
  Widget _buildPlayerBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Spacer(),
          _buildSurahImage(),
           height24,
          _buildTimeDisplay(),
          _buildProgressSlider(),
          _buildControlButtons(),
          const Spacer(),
        ],
      ),
    );
  }

  /// Displays the Surah image/placeholder
  Widget _buildSurahImage() {
    return Image.asset(
      'assets/images/quraan_audio_photo.jpg',
      height: 150,

    );
  }

  /// Shows current/total duration
  Widget _buildTimeDisplay() {
    return Text(
      ' ${_formatDuration(totalDuration)} / ${_formatDuration(currentPosition)}',
      style: const TextStyle(fontSize: 16),
    );
  }

  /// Builds the progress slider
  Widget _buildProgressSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Slider(
          value: currentPosition.inSeconds.toDouble(),
          max: totalDuration.inSeconds.toDouble().clamp(1, double.infinity),
          onChanged: (value) => _seekAudio(Duration(seconds: value.toInt())),
          activeColor: MyColors.deepGreen,
          inactiveColor: MyColors.darkGrey,
        ),
      ),
    );
  }

  /// Builds play/pause/seek controls
  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip back 10 seconds
        IconButton(
          icon: const Icon(Icons.forward_10, size: 32),
          onPressed: () => _seekAudio(currentPosition + const Duration(seconds: 10)),
        ),

        // Play/pause button
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle : Icons.play_circle,
            size: 50,
            color: MyColors.deepGreen,
          ),
          onPressed: isPlaying ? _pauseAudio : _playAudio,
        ),

        IconButton(
          icon: const Icon(Icons.replay_10, size: 32),
          onPressed: () => _seekAudio(currentPosition - const Duration(seconds: 10)),
        ),

        // Skip forward 10 seconds
      ],
    );
  }
}