import 'package:flutter/material.dart';
import 'package:particle_music/viewmodels/folder.dart';
import 'package:particle_music/pages/desktop/panels/single_folder_panel.dart';
import 'package:particle_music/pages/mobile/pages/single_folder_page.dart';

class SingleFolderLayer extends StatelessWidget {
  final Folder folder;

  const SingleFolderLayer({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return SingleFolderPage(folder: folder);
        } else {
          return SingleFolderPanel(folder: folder);
        }
      },
    );
  }
}
