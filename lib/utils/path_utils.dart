import 'dart:io';

import 'package:particle_music/constants/common.dart';

// every installation on iOS may result in a different app documents path
// due to app container isolation, therefore, keep only relative paths
String clipFilePathIfNeed(String path, {bool appSupport = false}) {
  if (Platform.isIOS) {
    int prefixLength = appSupport
        ? appSupportDir.path.length
        : appDocs.path.length;
    return path.substring(prefixLength);
  }
  return path;
}

String revertFilePathIfNeed(String path, {bool appSupport = false}) {
  if (Platform.isIOS) {
    return (appSupport ? appSupportDir.path : appDocs.path) + path;
  }
  return path;
}

String convertDirectoryPathIfNeed(String path) {
  if (Platform.isIOS) {
    path = path.substring(path.indexOf('Documents'));
    path = path.replaceFirst('Documents', 'Particle Music');
  }
  return path;
}

String revertDirectoryPathIfNeed(String path) {
  if (Platform.isIOS) {
    return "${appDocs.parent.path}/${path.replaceFirst('Particle Music', 'Documents')}";
  }
  return path;
}
