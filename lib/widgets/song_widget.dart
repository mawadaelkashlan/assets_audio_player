import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  final Audio audio;
  const SongWidget({super.key, required this.audio});

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isPlaying = false;
  @override
  void initState() {
    assetsAudioPlayer.open(
      widget.audio,
      autoStart: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: StreamBuilder(
          stream: assetsAudioPlayer.realtimePlayingInfos,
          builder: (cts, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshots.data == null) {
              return const SizedBox.shrink();
            }
            return Text(convertSeconds((isPlaying
                    ? snapshots.data?.currentPosition.inSeconds
                    : snapshots.data?.duration.inSeconds) ??
                0));
          }),
      leading: CircleAvatar(
        child: Center(
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: () {
              if (isPlaying) {
                assetsAudioPlayer.pause();
              } else {
                assetsAudioPlayer.play();
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
        ),
      ),
      title: Text(widget.audio.metas.title ?? 'No title'),
      subtitle: Text(widget.audio.metas.artist ?? 'No artist'),
      onTap: () async {
        // if (isPlaying) {
        //   assetsAudioPlayer.pause();
        // } else {
        //   assetsAudioPlayer.play();
        // }
        // setState(() {
        //   isPlaying = !isPlaying;
        // });
      },
    );
  }

  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondsStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')} : ${secondsStr.padLeft(2, '0')}';
  }
}
