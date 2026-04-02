import 'dart:async';

import 'package:flutter/material.dart';
import 'package:particle_music/viewmodels/setting_manager.dart';

ValueNotifier<bool> vibrationOnNotifier = ValueNotifier(true);

ValueNotifier<bool> timedPause = ValueNotifier(false);
ValueNotifier<int> remainTimes = ValueNotifier(0);
ValueNotifier<bool> pauseAfterCompleted = ValueNotifier(false);
bool needPause = false;
Timer? pauseTimer;

final playlistsUseLargePictureNotifier = ValueNotifier(true);

final enableCustomColorNotifier = ValueNotifier(false);
final enableCustomLyricsPageNotifier = ValueNotifier(false);

final updateColorNotifier = ValueNotifier(0);

final ValueNotifier<Locale?> localeNotifier = ValueNotifier(null);

final exitOnCloseNotifier = ValueNotifier(false);

late SettingManager settingManager;
