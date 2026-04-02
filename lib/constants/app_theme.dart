import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:particle_music/constants/common.dart';
import 'package:particle_music/pages/portrait_view/pages/custom_page_transition_builder.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AppTheme {
  static ThemeData build() {
    return ThemeData(
      textTheme: Platform.isWindows
          ? GoogleFonts.notoSerifScTextTheme()
                .apply(bodyColor: textColor, displayColor: textColor)
                .copyWith(
                  bodyLarge: GoogleFonts.notoSerifSc(fontWeight: .w500),
                  bodyMedium: GoogleFonts.notoSerifSc(fontWeight: .w500),
                )
          : TextTheme(
              bodyLarge: TextStyle(color: textColor),
              bodyMedium: TextStyle(color: textColor),
              displayLarge: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
      iconTheme: IconThemeData(color: iconColor),
      colorScheme: ColorScheme.light(onSurface: textColor),
      cupertinoOverrideTheme: Platform.isIOS
          ? CupertinoThemeData(primaryColor: textColor)
          : null,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {TargetPlatform.android: CustomPageTransitionBuilder()},
      ),
      splashColor: isMobile ? null : Colors.transparent,
      highlightColor: isMobile ? null : Colors.transparent,
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
          elevation: 1,
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          shadowColor: Colors.black12,
          shape: SmoothRectangleBorder(
            smoothness: 1,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: textColor.withAlpha(50),
        cursorColor: textColor,
        selectionHandleColor: textColor,
      ),
    );
  }
}
