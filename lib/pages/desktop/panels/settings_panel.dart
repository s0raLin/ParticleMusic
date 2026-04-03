import 'package:flutter/material.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/pages/desktop/title_bar.dart';
import 'package:particle_music/components/settings_list.dart';

class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleBar(),
        Expanded(child: SettingsList()),
      ],
    );
  }
}

class LicensePagePanel extends StatefulWidget {
  const LicensePagePanel({super.key});

  @override
  State<StatefulWidget> createState() => LicensePagePanelState();
}

class LicensePagePanelState extends State<LicensePagePanel> {
  late Widget searchField;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleBar(),
        Expanded(child: contentWidget(context)),
      ],
    );
  }

  Widget contentWidget(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(),
        listTileTheme: ListTileThemeData(selectedColor: Colors.black),
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
      ),
      child: const LicensePage(
        applicationName: 'Particle Music',
        applicationVersion: versionNumber,
        applicationLegalese: '© 2025-2026 AfalpHy',
      ),
    );
  }
}
