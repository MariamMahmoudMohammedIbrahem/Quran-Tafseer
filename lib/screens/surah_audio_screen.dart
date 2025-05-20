import 'package:quraan_tafseer/commons.dart';
// ========== Surah Audio Player Screen ==============

/// Screen that provides audio playback controls for Tafsir recordings.
///
/// Features include:
/// - Play/pause functionality
/// - Seek controls (forward/backward 10 seconds)
/// - Playback speed adjustment
/// - Progress tracking
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
    _setupAudioPlayer();
  }

  /// Sets up audio player event listeners
  void _setupAudioPlayer() {
    // Player state changes (playing/paused/stopped)
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _playerState = state);
    });

    // Total duration available
    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration);
    });

    // Current playback position
    _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });

    // Playback completion
    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });
  }

  /// Starts audio playback
  ///
  /// TODO: Implement buffering state
  /// TODO: Add offline playback capability
  Future<void> _playAudio() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      await _audioPlayer.play(UrlSource(widget.url));
      await _audioPlayer.setPlaybackRate(_playbackRate);

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error playing audio: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  /// Pauses current playback
  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  /// Stops playback and resets position
  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() => _position = Duration.zero);
  }

  /// Formats duration as HH:MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: MyColors.darkGreen,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Audio icon and title
            Icon(Icons.audiotrack, size: 80, color: MyColors.darkGrey),
            height24,
            Text(widget.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            // Loading/error states
            height32,
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: MyColors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),

            // Progress slider
            Directionality(
              textDirection: TextDirection.ltr,
              child: Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble()
                    .clamp(0, _duration.inSeconds.toDouble()),
                onChanged: (value) async {
                  await _audioPlayer.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),

            // Time indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_duration - _position)),
                  Text(_formatDuration(_position)),
                ],
              ),
            ),

            // Playback controls
            height24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Skip forward 10 seconds
                IconButton(
                  icon: const Icon(Icons.forward_10, size: 36),
                  onPressed: () async {
                    final newPosition = _position + const Duration(seconds: 10);
                    await _audioPlayer.seek(newPosition < _duration
                        ? newPosition
                        : _duration);
                  },
                ),

                // Play/pause button
                IconButton(
                  icon: Icon(
                    _playerState == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
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

                // Skip backward 10 seconds (left button)
                IconButton(
                  icon: const Icon(Icons.replay_10, size: 36),
                  onPressed: () async {
                    final newPosition = _position - const Duration(seconds: 10);
                    await _audioPlayer.seek(newPosition > Duration.zero
                        ? newPosition
                        : Duration.zero);
                  },
                ),
              ],
            ),

            // Playback speed controls
            height24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Speed: ', style: TextStyle(fontSize: 16)),
                width10,
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
                      setState(() => _playbackRate = value);
                      await _audioPlayer.setPlaybackRate(value);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}