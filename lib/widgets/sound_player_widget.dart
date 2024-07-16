import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SoundPlayer extends StatefulWidget {
  final Playlist playlist;
  const SoundPlayer({super.key, required this.playlist});

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  double volumeEx = 1.0;
  double playSpeedEx = 1.0;
  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(
      playSpeed: playSpeedEx,
      volume: volumeEx,
      autoStart: false,
      loopMode: LoopMode.playlist,
      widget.playlist,
    );
    assetsAudioPlayer.playSpeed.listen((event) {
      playSpeedEx = event;
    });
    assetsAudioPlayer.volume.listen((event) {
      volumeEx = event;
    });
    assetsAudioPlayer.playSpeed.listen((event) {
      print('>>>>>${event}');
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                    height: 500,
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
                          Column(
                            children: [
                              Text(
                                'Volume',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SegmentedButton(
                                      onSelectionChanged: (values) {
                                        volumeEx = values.first.toDouble();
                                        assetsAudioPlayer.setVolume(volumeEx);
                                        setState(() {});
                                      },
                                      segments: const [
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_up),
                                          value: 1.0,
                                        ),
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_down),
                                          value: 0.5,
                                        ),
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_mute),
                                          value: 0,
                                        ),
                                      ],
                                      selected: {
                                        volumeEx
                                      }),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Speed',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SegmentedButton(
                                      onSelectionChanged: (values) {
                                        playSpeedEx = values.first.toDouble();
                                        assetsAudioPlayer
                                            .setPlaySpeed(playSpeedEx);
                                        setState(() {});
                                      },
                                      segments: const [
                                        ButtonSegment(
                                          icon: Text('1X'),
                                          value: 1.0,
                                        ),
                                        ButtonSegment(
                                          icon: Text('2X'),
                                          value: 4.0,
                                        ),
                                        ButtonSegment(
                                          icon: Text('3X'),
                                          value: 8.0,
                                        ),
                                        ButtonSegment(
                                          icon: Text('4X'),
                                          value: 16.0,
                                        ),
                                      ],
                                      selected: {
                                        playSpeedEx
                                      }),
                                ],
                              ),
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