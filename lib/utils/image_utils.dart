import 'dart:typed_data';

import 'package:audio_tags_lofty/audio_tags_lofty.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:particle_music/api/navidrome_client.dart';
import 'package:particle_music/viewmodels/my_audio_metadata.dart';

Future<Uint8List?> loadPictureBytes(MyAudioMetadata? song) async {
  if (song == null) {
    return null;
  }

  if (song.pictureLoaded) {
    return song.pictureBytes;
  }
  final result = song.isNavidrome
      ? await navidromeClient.getPictureBytes(song.id!)
      : await readPictureAsync(song.filePath!);
  song.pictureBytes = result;
  song.pictureLoaded = true;
  return result;
}

Future<Color> computeCoverArtColor(MyAudioMetadata? song) async {
  if (song?.coverArtColor != null) {
    return song!.coverArtColor!;
  }
  final bytes = await loadPictureBytes(song);
  if (bytes == null) {
    return Colors.grey;
  }

  final decoded = image.decodeImage(bytes);
  if (decoded == null) return Colors.grey;

  // simple average of top pixels
  double r = 0, g = 0, b = 0, count = 0;
  for (int y = 0; y < decoded.height; y += 5) {
    for (int x = 0; x < decoded.width; x += 5) {
      final pixel = decoded.getPixel(x, y);

      r += pixel.r.toDouble();
      g += pixel.g.toDouble();
      b += pixel.b.toDouble();
      count++;
    }
  }
  r /= count;
  g /= count;
  b /= count;
  int luminance = image.getLuminanceRgb(r, g, b).toInt();
  int maxLuminace = 200;
  if (luminance > maxLuminace) {
    r -= luminance - maxLuminace;
    g -= luminance - maxLuminace;
    b -= luminance - maxLuminace;
  }
  final color = Color.fromARGB(255, r.toInt(), g.toInt(), b.toInt());
  song!.coverArtColor = color;
  return color;
}
