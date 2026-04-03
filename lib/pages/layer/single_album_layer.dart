import 'package:flutter/material.dart';
import 'package:particle_music/viewmodels/artists_albums_manager.dart';
import 'package:particle_music/pages/desktop/panels/single_album_panel.dart';
import 'package:particle_music/pages/mobile/pages/single_album_page.dart';

class SingleAlbumLayer extends StatelessWidget {
  final Album album;
  const SingleAlbumLayer({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return SingleAlbumPage(album: album);
        } else {
          return SingleAlbumPanel(album: album);
        }
      },
    );
  }
}
