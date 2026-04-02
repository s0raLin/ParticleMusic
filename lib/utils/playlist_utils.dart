import 'dart:convert';
import 'dart:io';

import 'package:particle_music/constants/common.dart';
import 'package:particle_music/viewmodels/my_audio_metadata.dart';

Future<void> setSongList(
  File songFilePathListFile,
  List<MyAudioMetadata> additionalSongList,
  List<MyAudioMetadata> destList,
) async {
  if (!await songFilePathListFile.exists()) {
    await songFilePathListFile.create();
  }

  final jsonString = await songFilePathListFile.readAsString();

  if (jsonString.isNotEmpty) {
    final List<dynamic> songFilePathList = jsonDecode(jsonString);
    for (final path in songFilePathList) {
      if (library.filePathValidSet.contains(path)) {
        final song = library.filePath2Song[path]!;
        destList.add(song);
      } else {
        library.filePath2Song.remove(path);
      }
    }
  }
  destList.addAll(additionalSongList);
}
