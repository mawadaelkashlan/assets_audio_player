import 'package:advanced_task1/pages/playlist_page.dart';
import 'package:advanced_task1/widgets/sound_player_widget.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final playlistEx = Playlist(audios: [
    Audio('assets/sample1.mp3',
        metas: Metas(title: 'Song 1', artist: 'Artist 1')),
    Audio('assets/sample2.mp3',
        metas: Metas(title: 'Song 2', artist: 'Artist 2')),
    Audio('assets/sample3.mp3',
        metas: Metas(title: 'Song 3', artist: 'Artist 3')),
    Audio('assets/sample4.mp3',
        metas: Metas(title: 'Song 4', artist: 'Artist 4')),
  ]);
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PlaylistPage(
                            playlist: playlistEx,
                          )));
            },
            icon: Icon(Icons.playlist_add_check_circle_outlined),
            color: Colors.white,
            iconSize: 30,
          )
        ],
      ),
      body: SoundPlayer(
        playlist: playlistEx,
      ),
    );
  }
}
