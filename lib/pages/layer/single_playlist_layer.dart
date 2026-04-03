import 'package:flutter/material.dart';
import 'package:particle_music/pages/desktop/panels/single_playlist_panel.dart';
import 'package:particle_music/viewmodels/playlists.dart';
import 'package:particle_music/pages/mobile/pages/single_playlist_page.dart';

class SinglePlaylistLayer extends StatelessWidget {
  final Playlist playlist;

  const SinglePlaylistLayer({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return SinglePlaylistPage(playlist: playlist);
        } else {
          return SinglePlaylistPanel(playlist: playlist);
        }
      },
    );
  }
}
