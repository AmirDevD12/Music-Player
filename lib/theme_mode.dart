import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier{

  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(){
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

}

class MyThemes {
  static final darkTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: GoogleFonts.ubuntu(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
      bodySmall: GoogleFonts.ubuntu(color: Colors.white, fontSize: 15),
      labelSmall: GoogleFonts.ubuntu(color: Colors.white54, fontSize: 13),
      titleSmall: GoogleFonts.ubuntu(color: Colors.white60, fontSize: 12),
      titleMedium: GoogleFonts.ubuntu(color: Colors.white, fontSize: 18),
        bodyLarge:GoogleFonts.ubuntu(color: Colors.red),
        bodyMedium:GoogleFonts.ubuntu(color: Colors.white),


    ),
    canvasColor: Colors.red,
    cardColor: const Color(0xff1a1b1d),

    iconButtonTheme: IconButtonThemeData(style: ButtonStyle()),
    primaryIconTheme: IconThemeData(color: Colors.green),
    backgroundColor: Colors.white,
    unselectedWidgetColor: Colors.red,
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: const Color(0xff1a1b1d),
    primaryColor: Colors.white,
    secondaryHeaderColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white,opacity: 0.8),
    // textSelectionTheme: const TextSelectionThemeData(
    //   cursorColor: Colors.red,
    //   selectionColor: Colors.green,
    //   selectionHandleColor: Colors.blue,
    // )
    // colorScheme: const ColorScheme.dark()
  );

  static final lightTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: GoogleFonts.ubuntu(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
      bodySmall: GoogleFonts.ubuntu(color: Colors.black, fontSize: 15),
      labelSmall: GoogleFonts.ubuntu(color: Colors.black38, fontSize: 13),
      titleSmall: GoogleFonts.ubuntu(color: Colors.black, fontSize: 12),
      bodyMedium:GoogleFonts.ubuntu(color: Colors.black),
    ),

    unselectedWidgetColor: Colors.black,
    primaryColorLight: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blueAccent,
    secondaryHeaderColor: Colors.black,

    iconTheme: const IconThemeData(color: Colors.black , opacity: 0.8),


    colorScheme: const ColorScheme.light()
  );

}