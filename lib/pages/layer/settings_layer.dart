import 'package:flutter/material.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/pages/desktop/panels/settings_panel.dart';
import 'package:particle_music/pages/mobile/pages/settings_page.dart';

class SettingsLayer extends StatelessWidget {
  const SettingsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return SettingsPage();
        } else {
          return SettingsPanel();
        }
      },
    );
  }
}

class LicenseLayer extends StatelessWidget {
  const LicenseLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return LicensePage(
            applicationName: 'Particle Music',
            applicationVersion: versionNumber,
            applicationLegalese: '© 2025-2026 AfalpHy',
          );
        } else {
          return LicensePagePanel();
        }
      },
    );
  }
}
