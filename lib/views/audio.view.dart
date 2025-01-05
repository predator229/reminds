import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reminds/models/helper.display.view.dart';

class AudioView extends StatefulWidget {
  final String audioUri;
  final HelperDisplayView helper;

  const AudioView({super.key, required this.audioUri, required this.helper});

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  static const double widthSize = 200.0;
  // static const double heightSize = 10.0;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    await _audioPlayer.setUrl(widget.audioUri);

    _audioPlayer.durationStream.listen((newDuration) {
      setState(() => duration = newDuration ?? Duration.zero);
    });

    _audioPlayer.positionStream.listen((newPosition) {
      setState(() => position = newPosition);
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
          position = Duration.zero;
        });
      }
    });
  }

  Future<void> _playPauseAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Row(
      mainAxisAlignment: widget.helper.rowAlinment,
      children: [
        SizedBox(
          width: widget.helper.avatarSize,
          height: widget.helper.avatarSize,
        ),
        Container(
          width: widthSize,
          // height: heightSize,
          decoration: BoxDecoration(
            color: widget.helper.bgMessage,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: widget.helper.columAlinment,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!widget.helper.isMe)
                    Container(
                      width: widget.helper.avatarSize,
                      height: widget.helper.avatarSize,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(widget.helper.avatarPath),
                      ),
                    ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: widget.helper.columAlinment,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.blue,
                              ),
                              onPressed: _playPauseAudio,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Slider(
                                value: position.inSeconds.toDouble(),
                                min: 0,
                                max: duration.inSeconds.toDouble() > 0
                                    ? duration.inSeconds.toDouble()
                                    : 1,
                                onChanged: (value) async {
                                  await _audioPlayer.seek(
                                    Duration(seconds: value.toInt()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${_formatDuration(position)} / ${_formatDuration(duration)}',
                            style: TextStyle(fontSize: 10, color: brightness == Brightness.dark && !widget.helper.isMe ? const Color.fromARGB(255, 111, 110, 110) :  Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
