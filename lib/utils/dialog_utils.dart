import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/l10n/generated/app_localizations.dart';
import 'package:smooth_corner/smooth_corner.dart';

void showCenterMessage(
  BuildContext context,
  String message, {
  int duration = 500,
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Material(
          color: Colors.black,
          shape: SmoothRectangleBorder(
            smoothness: 1,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(milliseconds: duration), () {
    overlayEntry.remove();
  });
}

Future<bool> showConfirmDialog(BuildContext context, String action) async {
  final l10n = AppLocalizations.of(context);

  final result = await showAnimationDialog<bool>(
    context: context,
    width: isMobile ? 280 : 300,
    height: 180,
    pageBuilder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: .centerLeft,
              child: Text(
                action,
                style: TextStyle(fontSize: 25, fontWeight: .bold),
              ),
            ),
            SizedBox(height: 15),
            Align(
              alignment: .centerLeft,
              child: Text(l10n.continueMsg, style: TextStyle(fontSize: 14)),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(l10n.confirm),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
  return result ?? false;
}

Future<T?> showAnimationDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  double width = 300,
  double height = 450,
  required Widget Function(BuildContext context) pageBuilder,
}) async {
  return await showGeneralDialog<T>(
    context: context,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, _) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (barrierDismissible) {
                  Navigator.pop(context);
                }
              },
              child: AnimatedBuilder(
                animation: animation,
                builder: (_, _) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5 * animation.value,
                      sigmaY: 5 * animation.value,
                    ),
                    child: Container(
                      color: Colors.black.withValues(
                        alpha: 0.3 * animation.value,
                      ),
                    ),
                  );
                },
              ),
            ),

            Center(
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                child: FadeTransition(
                  opacity: animation,
                  child: Material(
                    shape: SmoothRectangleBorder(
                      smoothness: 1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: enableCustomColorNotifier.value
                        ? Colors.white
                        : backgroundFilterColor,
                    clipBehavior: .antiAlias,
                    child: Container(
                      color: isMobile ? pageBackgroundColor : panelColor,
                      width: width,
                      height: height,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeLeft: true,
                        removeRight: true,
                        removeTop: true,
                        removeBottom: true,
                        child: pageBuilder(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
