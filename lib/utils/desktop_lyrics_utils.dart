import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/components/lyrics.dart';
import 'package:particle_music/pages/desktop/extensions/window_controller_extension.dart';

Future<void> updateDesktopLyrics() async {
  if (isMobile) {
    FlutterOverlayWindow.shareData({
      'position': audioHandler.getPosition().inMicroseconds,
      'lyric_line': currentLyricLine?.toMap(),
      'isKaraoke': currentLyricLineIsKaraoke,
    });
    return;
  }

  await lyricsWindowController?.updateLyric(
    audioHandler.getPosition(),
    currentLyricLine,
    currentLyricLineIsKaraoke,
  );
}

void getDesktopLyricFromMap(dynamic data) {
  final raw = data as Map;
  final map = Map<String, dynamic>.from(raw);

  desktopLyricsCurrentPosition = Duration(microseconds: map['position'] as int);
  final lyricLineMap = map['lyric_line'] as Map?;
  desktopLyricLine = lyricLineMap != null
      ? LyricLine.fromMap(lyricLineMap)
      : null;

  desktopLyricsIsKaraoke = map['isKaraoke'] as bool;
  updateDesktopLyricsNotifier.value++;
}
