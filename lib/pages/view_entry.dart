import 'package:flutter/material.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/components/layout/main_layout.dart';
import 'package:particle_music/pages/desktop/landscape_view.dart';
import 'package:particle_music/pages/mini/mini_view.dart';
import 'package:particle_music/pages/mobile/portrait_view.dart';

class ViewEntry extends StatelessWidget {
  const ViewEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: miniModeNotifier,
      builder: (context, miniMode, child) {
        if (miniMode) {
          return MiniView();
        }
        return MainLayout(content: mainView(context));
      },
    );
  }

  Widget mainView(BuildContext context) {
    isLandscape = false;
    if (isMobile) {
      mobileWidth = MediaQuery.widthOf(context);
      mobileHeight = MediaQuery.heightOf(context);
      shortestSide = MediaQuery.of(context).size.shortestSide;

      return OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return PortraitView();
          } else {
            isLandscape = true;
            return LandscapeView();
          }
        },
      );
    }

    isLandscape = true;
    return LandscapeView();
  }
}
