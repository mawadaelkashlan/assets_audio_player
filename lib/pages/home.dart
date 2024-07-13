import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(
        autoStart: false,
        loopMode: LoopMode.playlist,
        Playlist(audios: [
          Audio('assets/sample1.mp3', metas: Metas(title: 'Song 1')),
          Audio('assets/sample2.mp3', metas: Metas(title: 'Song 2')),
          Audio('assets/sample3.mp3', metas: Metas(title: 'Song 3')),
          Audio('assets/sample4.mp3', metas: Metas(title: 'Song 4')),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Audio Player',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Center(
        child: StreamBuilder(
            stream: assetsAudioPlayer.realtimePlayingInfos,
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.pink.shade400,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            assetsAudioPlayer.getCurrentAudioTitle == ''
                                ? 'please play your songs'
                                : assetsAudioPlayer.getCurrentAudioTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: snapshots.data?.current?.index == 0
                                      ? null
                                      : () {
                                          assetsAudioPlayer.previous();
                                        },
                                  icon: Icon(Icons.skip_previous)),
                              getBtnWidget,
                              IconButton(
                                  onPressed: snapshots.data?.current?.index ==
                                          (assetsAudioPlayer.playlist?.audios
                                                      .length ??
                                                  0) -
                                              1
                                      ? null
                                      : () {
                                          assetsAudioPlayer.next();
                                        },
                                  icon: Icon(Icons.skip_next)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Slider(
                              value: snapshots.data?.currentPosition.inSeconds
                                      .toDouble() ??
                                  0.0,
                              min: 0,
                              max: snapshots.data?.duration.inSeconds
                                      .toDouble() ??
                                  0,
                              onChanged: (value) {
                                assetsAudioPlayer
                                    .seek(Duration(seconds: value.toInt()));
                              }),
                          Text(
                            "${convertSeconds(snapshots.data?.currentPosition.inSeconds ?? 0)} / ${convertSeconds(snapshots.data?.duration.inSeconds ?? 0)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondsStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')} : ${secondsStr.padLeft(2, '0')}';
  }

  Widget get getBtnWidget =>
      assetsAudioPlayer.builderIsPlaying(builder: (context, isPlaying) {
        return FloatingActionButton.large(
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 60,
          ),
          onPressed: () {
            if (isPlaying) {
              assetsAudioPlayer.pause();
            } else {
              assetsAudioPlayer.play();
            }
            setState(() {});
          },
          shape: CircleBorder(),
        );
      });
}
