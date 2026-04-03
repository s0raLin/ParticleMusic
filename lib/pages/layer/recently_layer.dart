import 'package:flutter/material.dart';
import 'package:particle_music/pages/desktop/panels/recently_panel.dart';
import 'package:particle_music/pages/mobile/pages/recently_page.dart';

class RecentlyLayer extends StatelessWidget {
  const RecentlyLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return RecentlyPage();
        } else {
          return RecentlyPanel();
        }
      },
    );
  }
}
