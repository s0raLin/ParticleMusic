import 'dart:io';

import 'package:flutter/material.dart';
import 'package:particle_music/components/lyrics.dart';
import 'package:particle_music/viewmodels/history.dart';
import 'package:particle_music/viewmodels/library.dart';
import 'package:particle_music/viewmodels/logger.dart';
import 'package:particle_music/viewmodels/playlists.dart';

export 'package:particle_music/stores/audio_state.dart';
export 'package:particle_music/stores/ui_state.dart';
export 'package:particle_music/stores/settings_state.dart';
export 'package:particle_music/stores/color_state.dart';
export 'package:particle_music/stores/desktop_lyrics_state.dart';

const String versionNumber = '1.0.16.2';

// ===================================== App =====================================

late Directory appDocs;
late Directory appSupportDir;
late Directory tmpDir;

late double mobileWidth;
late double mobileHeight;
late double shortestSide;

final isMobile = Platform.isAndroid || Platform.isIOS;
late bool isLandscape;

// ===================================== Library =====================================

late Library library;

final ValueNotifier<int> loadedCountNotifier = ValueNotifier(0);
final ValueNotifier<String> currentLoadingFolderNotifier = ValueNotifier('');

final ValueNotifier<bool> loadingLibraryNotifier = ValueNotifier(true);

final ValueNotifier<bool> loadingNavidromeNotifier = ValueNotifier(false);

// ===================================== Lyrics =====================================

LyricLine? currentLyricLine;
bool currentLyricLineIsKaraoke = false;

// ===================================== Images =====================================

final AssetImage addCircleImage = AssetImage('assets/images/add_circle.png');
final AssetImage addImage = AssetImage('assets/images/add.png');
final AssetImage albumImage = AssetImage('assets/images/album.png');
final AssetImage arrowDownImage = AssetImage('assets/images/arrow_down.png');
final AssetImage artistImage = AssetImage('assets/images/artist.png');
final AssetImage checkUpdateImage = AssetImage(
  'assets/images/check_update.png',
);
final AssetImage closeImage = AssetImage('assets/images/close.png');
final AssetImage deleteImage = AssetImage('assets/images/delete.png');
final AssetImage desktopLyricsImage = AssetImage(
  'assets/images/desktop_lyrics.png',
);
final AssetImage exportLogImage = AssetImage('assets/images/export_log.png');
final AssetImage folderImage = AssetImage('assets/images/folder.png');
final AssetImage fullscreenExitImage = AssetImage(
  'assets/images/fullscreen_exit.png',
);
final AssetImage fullscreenImage = AssetImage('assets/images/fullscreen.png');
final AssetImage gridImage = AssetImage('assets/images/grid.png');
final AssetImage infoImage = AssetImage('assets/images/info.png');
final AssetImage languageImage = AssetImage('assets/images/language.png');
final AssetImage listImage = AssetImage('assets/images/list.png');
final AssetImage location = AssetImage('assets/images/location.png');
final AssetImage longArrowDownImage = AssetImage(
  'assets/images/long_arrow_down.png',
);
final AssetImage longArrowUpImage = AssetImage(
  'assets/images/long_arrow_up.png',
);
final AssetImage loopImage = AssetImage('assets/images/loop.png');
final AssetImage lyricsImage = AssetImage('assets/images/lyrics.png');
final AssetImage maximizeImage = AssetImage('assets/images/maximize.png');
final AssetImage miniModeImage = AssetImage('assets/images/mini_mode.png');
final AssetImage minimizeImage = AssetImage('assets/images/minimize.png');
final AssetImage musicNoteImage = AssetImage('assets/images/music_note.png');
final AssetImage navidromeImage = AssetImage('assets/images/navidrome.png');
final AssetImage nextButtonImage = AssetImage('assets/images/next_button.png');
final AssetImage paletteImage = AssetImage('assets/images/palette.png');
final AssetImage pauseCircleImage = AssetImage(
  'assets/images/pause_circle.png',
);
final AssetImage pictureImage = AssetImage('assets/images/picture.png');

final AssetImage playCircleFillImage = AssetImage(
  'assets/images/play_circle_fill.png',
);
final AssetImage playCircleImage = AssetImage('assets/images/play_circle.png');
final AssetImage playOutlinedImage = AssetImage(
  'assets/images/play_outlined.png',
);
final AssetImage playQueueImage = AssetImage('assets/images/play_queue.png');
final AssetImage playlistAddImage = AssetImage(
  'assets/images/playlist_add.png',
);
final AssetImage playlistsImage = AssetImage('assets/images/playlists.png');
final AssetImage playnextCircleImage = AssetImage(
  'assets/images/playnext_circle.png',
);
final AssetImage powerOffImage = AssetImage('assets/images/power_off.png');
final AssetImage previousButtonImage = AssetImage(
  'assets/images/previous_button.png',
);
final AssetImage rankingImage = AssetImage('assets/images/ranking.png');
final AssetImage recentlyImage = AssetImage('assets/images/recently.png');
final AssetImage reloadImage = AssetImage('assets/images/reload.png');
final AssetImage reorderImage = AssetImage('assets/images/reorder.png');
final AssetImage repeatImage = AssetImage('assets/images/repeat.png');
final AssetImage reverseImage = AssetImage('assets/images/reverse.png');
final AssetImage selectImage = AssetImage('assets/images/select.png');
final AssetImage sequenceImage = AssetImage('assets/images/sequence.png');
final AssetImage settingImage = AssetImage('assets/images/setting.png');
final AssetImage shuffleImage = AssetImage('assets/images/shuffle.png');
final AssetImage songsImage = AssetImage('assets/images/songs.png');
final AssetImage speakerOffImage = AssetImage('assets/images/speaker_off.png');
final AssetImage speakerImage = AssetImage('assets/images/speaker.png');
final AssetImage themeImage = AssetImage('assets/images/theme.png');
final AssetImage timerImage = AssetImage('assets/images/timer.png');
final AssetImage unmaximizeImage = AssetImage('assets/images/unmaximize.png');
final AssetImage vibrationImage = AssetImage('assets/images/vibration.png');

// ===================================== Playlist =====================================

late PlaylistsManager playlistsManager;

// ===================================== Keyboard =====================================

bool shiftIsPressed = false;
bool ctrlIsPressed = false;

// ===================================== Windows =====================================

ValueNotifier<bool> isMaximizedNotifier = ValueNotifier(false);
ValueNotifier<bool> isFullScreenNotifier = ValueNotifier(false);

// ===================================== History =====================================

final History history = History();

final rankingChangeNotifier = ValueNotifier(0);
final recentlyChangeNotifier = ValueNotifier(0);

// ===================================== Logger =====================================

final logger = Logger();
