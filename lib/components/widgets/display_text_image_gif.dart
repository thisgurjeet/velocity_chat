import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:real_time_chat_app_riverpod/components/helpers/message_enum.dart';
import 'package:real_time_chat_app_riverpod/components/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final TextStyle st;
  const DisplayTextImageGif({
    super.key,
    required this.message,
    required this.type,
    required this.st,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: st,
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : type == MessageEnum.audio
                ? StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                        constraints: const BoxConstraints(maxWidth: 100),
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await audioPlayer.play(UrlSource(message));
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                        icon: Icon(isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle));
                  })
                : type == MessageEnum.gif
                    ? CachedNetworkImage(imageUrl: message)
                    : CachedNetworkImage(imageUrl: message);
  }
}
