import 'package:flutter/material.dart';
import 'package:particle_music/viewmodels/artists_albums_manager.dart';
import 'package:particle_music/pages/mobile/pages/local_navidrome_pageview.dart';

class SingleArtistPage extends StatelessWidget {
  final Artist artist;
  const SingleArtistPage({super.key, required this.artist});
  @override
  Widget build(BuildContext context) {
    return LocalNavidromePageview(
      displayNavidromeNotifier: artist.displayNavidromeNotifier,
      localSongList: artist.songList,
      navidromeSongList: artist.navidromeSongList,
      artist: artist,
    );
  }
}
