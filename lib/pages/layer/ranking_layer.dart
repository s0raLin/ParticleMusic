import 'package:flutter/material.dart';
import 'package:particle_music/pages/desktop/panels/ranking_panel.dart';
import 'package:particle_music/pages/mobile/pages/ranking_page.dart';

class RankingLayer extends StatelessWidget {
  const RankingLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return RankingPage();
        } else {
          return RankingPanel();
        }
      },
    );
  }
}
