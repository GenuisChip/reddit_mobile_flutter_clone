import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControllerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoControllerWidget({super.key, required this.controller});

  @override
  State<VideoControllerWidget> createState() => _VideoControllerWidgetState();
}

class _VideoControllerWidgetState extends State<VideoControllerWidget> {
  bool isPlaying = true;
  late Duration currentDuration;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      widget.controller.value.duration;
      widget.controller.position.then((value) {
        setState(() {
          currentDuration = value!;
        });
      });
      if (isPlaying == widget.controller.value.isPlaying) return;
      if (mounted) {
        setState(() {
          isPlaying = widget.controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (isPlaying) {
              widget.controller.pause();
            } else {
              widget.controller.play();
            }
          },
          child: isPlaying
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
        ),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width * .7,
              color: Colors.white,
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(
                height: 10,
                width: (MediaQuery.of(context).size.width * .7) *
                    currentDuration.inMilliseconds /
                    widget.controller.value.duration.inMilliseconds,
                color: Colors.red,
              ),
            ),
          ],
        ),
        Text(
            "${currentDuration.inMinutes < 9 ? '0${currentDuration.inMinutes}' : currentDuration.inMinutes}:${currentDuration.inSeconds < 9 ? '0${currentDuration.inSeconds}' : currentDuration.inSeconds}"),
        GestureDetector(
          child: const Icon(Icons.volume_off),
        )
      ],
    );
  }
}
