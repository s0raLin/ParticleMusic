import 'dart:async';

import 'package:flutter/material.dart';
import 'package:particle_music/viewmodels/my_audio_metadata.dart';

final miniModeNotifier = ValueNotifier(false);

final ValueNotifier<String> sidebarHighlighLabel = ValueNotifier('');

MyAudioMetadata? backgroundSong;

final ValueNotifier<bool> displayPlayQueuePageNotifier = ValueNotifier(false);

final ValueNotifier<bool> displayLyricsPageNotifier = ValueNotifier(false);
final ValueNotifier<bool> immersiveModeNotifier = ValueNotifier(false);
Timer? immersiveModeTimer;

double lyricsFontSizeOffset = 0;
final lyricsFontSizeOffsetChangeNotifier = ValueNotifier(0);
final updateLyricsNotifier = ValueNotifier(0);
