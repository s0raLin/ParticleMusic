import 'package:flutter/material.dart';
import 'package:particle_music/pages/desktop/panels/playlists_panel.dart';
import 'package:particle_music/pages/mobile/pages/playlists_page.dart';

class PlaylistsLayer extends StatelessWidget {
  const PlaylistsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return PlaylistsPage();
        } else {
          return PlaylistsPanel();
        }
      },
    );
  }
}
