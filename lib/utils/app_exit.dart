import 'dart:io';

import 'package:particle_music/pages/desktop/extensions/window_controller_extension.dart';
import 'package:particle_music/pages/desktop/single_instance.dart';
import 'package:particle_music/stores/desktop_lyrics_state.dart';
import 'package:window_manager/window_manager.dart';

bool _exited = false;

void exitApp() async {
  if (_exited) {
    return;
  }

  lyricsWindowController!.close();
  await SingleInstance.end();
  // only this allows quick exit on Windows
  if (Platform.isWindows) {
    await windowManager.setPreventClose(false);
    _exited = true;
    windowManager.close();
    return;
  }

  exit(0);
}
