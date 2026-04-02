import 'package:flutter/material.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/l10n/generated/app_localizations.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isMobile
          ? pageBackgroundColor
          : panelColor.withAlpha(255),
      body: ValueListenableBuilder(
        valueListenable: loadingNavidromeNotifier,
        builder: (context, value, child) {
          if (value) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: iconColor),
                  SizedBox(height: 15),
                  Text(l10n.loadingNavidrome),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: iconColor),
                SizedBox(height: 15),
                ValueListenableBuilder(
                  valueListenable: currentLoadingFolderNotifier,
                  builder: (context, value, child) {
                    return Text('${l10n.loadingFolder}: $value');
                  },
                ),
                SizedBox(height: 5),
                ValueListenableBuilder(
                  valueListenable: loadedCountNotifier,
                  builder: (context, value, child) {
                    return Text('${l10n.loadedSongs}: $value');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
