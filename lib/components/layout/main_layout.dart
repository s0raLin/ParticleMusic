import 'package:flutter/material.dart';
import 'package:particle_music/components/layout/play_queue_sidebar.dart';
import 'package:particle_music/constants/common.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'dart:math';

class MainLayout extends StatelessWidget {
  final Widget content;
  final Widget? bottomBar;

  const MainLayout({super.key, required this.content, this.bottomBar});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Stack(children: [content, if (bottomBar != null) bottomBar!]);
    }

    return Stack(
      children: [
        content,
        if (bottomBar != null)
          Positioned(left: 0, right: 0, bottom: 0, child: bottomBar!),
        _buildPlayQueueOverlay(context),
        _buildPlayQueuePanel(context),
      ],
    );
  }

  Widget _buildPlayQueueOverlay(BuildContext context) {
    if (isMobile) return const SizedBox.shrink();

    return ValueListenableBuilder(
      valueListenable: displayPlayQueuePageNotifier,
      builder: (context, display, _) {
        if (display) {
          return GestureDetector(
            onTap: () {
              displayPlayQueuePageNotifier.value = false;
            },
            child: Container(color: Colors.black.withAlpha(25)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPlayQueuePanel(BuildContext context) {
    if (isMobile) return const SizedBox.shrink();

    return Positioned(
      top: 75,
      bottom: 100,
      right: 0,
      child: ValueListenableBuilder(
        valueListenable: displayPlayQueuePageNotifier,
        builder: (context, display, _) {
          return AnimatedSlide(
            offset: display ? Offset.zero : Offset(1, 0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
            child: Material(
              elevation: 1,
              color: sidebarColor.withAlpha(255),
              shape: SmoothRectangleBorder(
                smoothness: 1,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
              ),
              child: SizedBox(
                width: max(350, MediaQuery.widthOf(context) * 0.2),
                child: const PlayQueueSidebar(),
              ),
            ),
          );
        },
      ),
    );
  }
}
