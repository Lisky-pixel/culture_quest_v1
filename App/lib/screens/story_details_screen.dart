import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/story.dart';

class StoryDetailsScreen extends StatefulWidget {
  const StoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<StoryDetailsScreen> createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          _isLoading =
              state == PlayerState.playing && _position == Duration.zero;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
          _isLoading = false;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    // Handle audio player errors
    _audioPlayer.onLog.listen((message) {
      if (message.contains('ERROR') || message.contains('WARN')) {
        print('Audio Player Log: $message');
      }
    });
  }

  Future<void> _togglePlayPause(String audioUrl) async {
    try {
      // Check if audioUrl is valid
      if (audioUrl.isEmpty || audioUrl.contains('example.com')) {
        _showErrorSnackBar('Audio not available for this story');
        return;
      }

      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        setState(() {
          _isLoading = true;
        });
        await _audioPlayer.play(UrlSource(audioUrl));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlaying = false;
        });

        String errorMessage = 'Unable to play audio';
        if (e.toString().contains('404')) {
          errorMessage = 'Audio file not found';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error - check your connection';
        } else if (e.toString().contains('format')) {
          errorMessage = 'Unsupported audio format';
        }

        _showErrorSnackBar(errorMessage);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = ModalRoute.of(context)?.settings.arguments as Story?;
    int selectedIndex = 2;
    void onItemTapped(int index) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/events');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/stories');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/artisans');
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }

    if (story == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Story Details')),
        body: const Center(child: Text('No story data provided.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Stories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 1.2,
                child: _buildStoryImage(story),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        story.text,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (story.audioUrl != null && story.audioUrl!.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F1EE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _buildAudioPlayerImage(story),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      story.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      story.narrator?.name ?? 'CultureQuest',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: _isAudioAvailable(story)
                                      ? const Color(0xFFF1872D)
                                      : Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(
                                          _isPlaying
                                              ? Icons.pause
                                              : (_isAudioAvailable(story)
                                                  ? Icons.play_arrow
                                                  : Icons.play_disabled),
                                          color: Colors.white,
                                        ),
                                  onPressed: _isAudioAvailable(story)
                                      ? () => _togglePlayPause(story.audioUrl!)
                                      : () => _showErrorSnackBar(
                                          'Audio not available for this story'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (story.audioUrl != null &&
                          story.audioUrl!.isNotEmpty &&
                          _duration.inSeconds > 0)
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: const Color(0xFFF1872D),
                                      inactiveTrackColor: Colors.grey.shade300,
                                      thumbColor: const Color(0xFFF1872D),
                                      overlayColor: const Color(0xFFF1872D)
                                          .withOpacity(0.2),
                                      trackHeight: 3,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                      ),
                                    ),
                                    child: Slider(
                                      value: _position.inSeconds.toDouble(),
                                      max: _duration.inSeconds.toDouble(),
                                      onChanged: (value) async {
                                        await _audioPlayer.seek(
                                          Duration(seconds: value.toInt()),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(_position),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(_duration),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Artisans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildStoryImage(Story story) {
    if (story.imageUrl == null ||
        story.imageUrl!.isEmpty ||
        story.imageUrl!.contains('example.com')) {
      return _buildPlaceholderContainer();
    }

    return Image.network(
      story.imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade100,
                Colors.pink.shade100,
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholderContainer();
      },
    );
  }

  Widget _buildAudioPlayerImage(Story story) {
    if (story.imageUrl == null ||
        story.imageUrl!.isEmpty ||
        story.imageUrl!.contains('example.com')) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade100,
              Colors.pink.shade100,
            ],
          ),
        ),
        child: const Icon(
          Icons.music_note,
          color: Colors.orange,
          size: 20,
        ),
      );
    }

    return Image.network(
      story.imageUrl!,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade100,
                Colors.pink.shade100,
              ],
            ),
          ),
          child: const Icon(
            Icons.music_note,
            color: Colors.orange,
            size: 20,
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade100,
            Colors.pink.shade100,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: Colors.orange,
        ),
      ),
    );
  }

  bool _isAudioAvailable(Story story) {
    return story.audioUrl != null &&
        story.audioUrl!.isNotEmpty &&
        !story.audioUrl!.contains('example.com');
  }
}
