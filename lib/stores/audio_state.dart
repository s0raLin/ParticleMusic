import 'package:flutter/material.dart';
import 'package:particle_music/viewmodels/audio_handler.dart';
import 'package:particle_music/viewmodels/my_audio_metadata.dart';

late MyAudioHandler audioHandler;

List<MyAudioMetadata> playQueue = [];

final ValueNotifier<MyAudioMetadata?> currentSongNotifier = ValueNotifier(null);
final ValueNotifier<bool> isPlayingNotifier = ValueNotifier(false);
final ValueNotifier<int> playModeNotifier = ValueNotifier(0);
final ValueNotifier<double> volumeNotifier = ValueNotifier(0.3);
