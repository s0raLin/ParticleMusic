import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/components/cover_art_widget.dart';
import 'package:particle_music/components/layout/main_layout.dart';
import 'package:particle_music/components/layout/sidebar_panel.dart';
import 'package:particle_music/components/layout/bottom_bar.dart';
import 'package:particle_music/pages/layer/layers_manager.dart';

class LandscapeView extends StatelessWidget {
  const LandscapeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(content: _buildContent(context), bottomBar: null);
  }

  Widget _buildContent(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ValueListenableBuilder(
          valueListenable: updateColorNotifier,
          builder: (context, value, child) {
            if (enableCustomColorNotifier.value) {
              return SizedBox.shrink();
            }
            return CoverArtWidget(song: backgroundSong);
          },
        ),
        ValueListenableBuilder(
          valueListenable: updateColorNotifier,
          builder: (context, value, child) {
            if (enableCustomColorNotifier.value) {
              return Container(color: Colors.white);
            }
            final pageWidth = MediaQuery.widthOf(context);
            final pageHight = MediaQuery.heightOf(context);

            return ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: pageWidth * 0.03,
                  sigmaY: pageHight * 0.03,
                ),
                child: Container(color: backgroundFilterColor.withAlpha(180)),
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: updateColorNotifier,
          builder: (context, value, child) {
            return Row(
              children: [
                const SidebarPanel(),
                Expanded(
                  child: Material(
                    color: panelColor,
                    child: IndexedStack(
                      index: layersManager.layerStack.length - 1,
                      children: layersManager.layerStack,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: const BottomBar()),
        // LandscapeLyricsPage is handled by pages
      ],
    );
  }
}
