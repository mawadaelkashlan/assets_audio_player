import 'package:advanced_task1/widgets/song_widget.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;
  const PlaylistPage({super.key, required this.playlist});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text(
            'Playlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: ListView(
          children: [
            for (var song in widget.playlist.audios) SongWidget(audio: song)
          ],
        ));
  }
}
