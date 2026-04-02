import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:particle_music/components/lyrics.dart';

WindowController? lyricsWindowController;
bool lyricsWindowVisible = false;

LyricLine? desktopLyricLine;
Duration desktopLyricsCurrentPosition = Duration.zero;
bool desktopLyricsIsKaraoke = false;

final updateDesktopLyricsNotifier = ValueNotifier(0);

final showDesktopLrcOnAndroidNotifier = ValueNotifier(false);
final lockDesktopLrcOnAndroidNotifier = ValueNotifier(false);

final verticalDesktopLrcNotifier = ValueNotifier(false);
