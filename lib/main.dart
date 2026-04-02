import 'package:flutter/material.dart';
import 'package:particle_music/constants/app_theme.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/components/loading_page.dart';
import 'package:particle_music/l10n/generated/app_localizations.dart';
import 'package:particle_music/pages/portrait_view/overlay_lyrics.dart';
import 'package:particle_music/pages/view_entry.dart';
import 'package:particle_music/utils/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.init();
  runApp(const ParticleMusicApp());
  await AppInitializer.postLaunch();
}

class ParticleMusicApp extends StatelessWidget {
  const ParticleMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: localeNotifier,
      builder: (context, locale, child) {
        return ValueListenableBuilder(
          valueListenable: updateColorNotifier,
          builder: (context, _, _) {
            return MaterialApp(
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: AppTheme.build(),
              title: 'Particle Music',
              home: child,
            );
          },
        );
      },
      child: ValueListenableBuilder(
        valueListenable: loadingLibraryNotifier,
        builder: (context, value, child) {
          if (value) {
            return const LoadingPage();
          }
          return MediaQuery.removePadding(
            context: context,
            removeLeft: true,
            removeRight: true,
            child: ViewEntry(),
          );
        },
      ),
    );
  }
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: OverlayLyrics()));
}
