import 'package:flutter/material.dart';
import 'package:particle_music/components/sidebar/sidebar.dart';

class SidebarPanel extends StatelessWidget {
  final void Function()? closeDrawer;

  const SidebarPanel({super.key, this.closeDrawer});

  @override
  Widget build(BuildContext context) {
    return Sidebar(closeDrawer: closeDrawer);
  }
}
