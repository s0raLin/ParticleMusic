import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/l10n/generated/app_localizations.dart';
import 'package:particle_music/l10n/generated/app_localizations_en.dart';
import 'package:particle_music/pages/desktop/desktop_lyrics.dart';
import 'package:particle_music/pages/desktop/extensions/window_controller_extension.dart';
import 'package:particle_music/pages/desktop/keyboard.dart';
import 'package:particle_music/pages/desktop/my_tray_listener.dart';
import 'package:particle_music/pages/desktop/my_window_listener.dart';
import 'package:particle_music/pages/desktop/single_instance.dart';
import 'package:particle_music/viewmodels/audio_handler.dart';
import 'package:particle_music/viewmodels/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class AppInitializer {
  static Future<void> init() async {
    appDocs = await getApplicationDocumentsDirectory();
    appSupportDir = await getApplicationSupportDirectory();
    tmpDir = await getTemporaryDirectory();

    if (isMobile) {
      await logger.init();
    } else {
      await windowManager.ensureInitialized();
      final windowController = await WindowController.fromCurrentEngine();

      if (windowController.arguments == 'desktop_lyrics') {
        await _setupDesktopLyricsWindow(windowController);
        runApp(DesktopLyrics());
        return;
      }

      await logger.init();

      if (kReleaseMode) {
        await SingleInstance.start();
      }

      keyboardInit();

      await _setupMainWindow(windowController);
      await _setupTray();
    }

    await initAudioService();
    await Loader.init();
  }

  static Future<void> postLaunch() async {
    logger.output('App start');
    await Loader.load();
    if (!isMobile) {
      await initDesktopLyrics();
    }
  }

  static Future<void> _setupMainWindow(
    WindowController windowController,
  ) async {
    await windowController.mainCustomInitialize();
    WindowOptions windowOptions = WindowOptions(
      size: Platform.isWindows ? Size(1050 + 16, 700 + 9) : Size(1050, 700),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setPreventClose(true);
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setMinimumSize(
        Platform.isLinux
            ? Size(1102, 752)
            : Platform.isWindows
            ? Size(1050 + 16, 700 + 9)
            : Size(1050, 700),
      );
    });
    windowManager.addListener(MyWindowListener());
  }

  static Future<void> _setupDesktopLyricsWindow(
    WindowController windowController,
  ) async {
    await windowController.desktopLyricsCustomInitialize();
    WindowOptions windowOptions = WindowOptions(
      title: "Desktop Lyrics",
      size: Platform.isLinux ? Size(850, 200) : Size(800, 150),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
      skipTaskbar: Platform.isMacOS ? false : true,
      alwaysOnTop: true,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setAsFrameless();
    });
  }

  static Future<void> _setupTray() async {
    await trayManager.setIcon(
      Platform.isWindows
          ? 'assets/app_icon.ico'
          : Platform.isMacOS
          ? 'assets/mac_tray.png'
          : 'assets/linux_tray.png',
      isTemplate: true,
    );

    if (!Platform.isLinux) {
      await trayManager.setToolTip('Particle Music');
    }

    Locale systemLocale = PlatformDispatcher.instance.locale;
    await _setTrayMenu(systemLocale);

    localeNotifier.addListener(() async {
      Locale? locale = localeNotifier.value;
      locale ??= PlatformDispatcher.instance.locale;
      await _setTrayMenu(locale);
    });

    trayManager.addListener(MyTrayListener());
  }

  static Future<void> _setTrayMenu(Locale locale) async {
    late AppLocalizations l10n;
    try {
      l10n = lookupAppLocalizations(locale);
    } catch (_) {
      l10n = AppLocalizationsEn();
    }
    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(key: 'show', label: l10n.showApp),
          MenuItem.separator(),
          MenuItem(key: 'skipToPrevious', label: l10n.skip2Previous),
          MenuItem(key: 'togglePlay', label: l10n.playOrPause),
          MenuItem(key: 'skipToNext', label: l10n.skip2Next),
          MenuItem.separator(),
          MenuItem(key: 'unlock', label: l10n.unlockDeskLrc),
          MenuItem.separator(),
          MenuItem(key: 'exit', label: l10n.exit),
        ],
      ),
    );
  }
}
