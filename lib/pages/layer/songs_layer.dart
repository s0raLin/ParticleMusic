import 'package:flutter/material.dart';
import 'package:particle_music/pages/desktop/panels/songs_panel.dart';
import 'package:particle_music/pages/mobile/pages/songs_page.dart';

class SongsLayer extends StatelessWidget {
  const SongsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return SongsPage();
        } else {
          return SongsPanel();
        }
      },
    );
  }
}
