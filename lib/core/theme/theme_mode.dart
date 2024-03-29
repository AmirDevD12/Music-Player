import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier{

  ThemeMode themeMode = ThemeMode.light;
   bool showSplash=true;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(){
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    showSplash=false;
    notifyListeners();
  }

}

class MyThemes {
  final  Color cContainerSong=const Color(0xfff7f8fa);
  TextStyle title(BuildContext context){
    ThemeProvider themeProvider=Provider.of<ThemeProvider>(context);
    TextStyle textStyleTitle= TextStyle(fontWeight: FontWeight.bold,fontFamily: "ibm",fontSize: 15,color:themeProvider.isDarkMode?Colors.white:Colors.black);
    return textStyleTitle;
  }

  TextStyle subTitle(BuildContext context){
    ThemeProvider themeProvider=Provider.of<ThemeProvider>(context);
    TextStyle textStySub= TextStyle(fontFamily: "ibm",fontSize: 15,color: themeProvider.isDarkMode?Colors.white:Colors.black);
    return textStySub;
  }


  static final darkTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: GoogleFonts.ubuntu(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
      bodySmall: GoogleFonts.ubuntu(color: Colors.white, fontSize: 15),
      labelSmall: GoogleFonts.ubuntu(color: Colors.white54, fontSize: 13),
      titleSmall: GoogleFonts.ubuntu(color: Colors.white60, fontSize: 12),
      titleMedium: GoogleFonts.ubuntu(color: Colors.white, fontSize: 18),
      bodyLarge:GoogleFonts.ubuntu(color: Colors.red),
      bodyMedium:GoogleFonts.ubuntu(color: Colors.white),
      displayLarge: GoogleFonts.ubuntu(color: Colors.white),
      displaySmall: GoogleFonts.ubuntu(color: Colors.white),
      headlineMedium: GoogleFonts.ubuntu(color: Colors.white),

      labelLarge: GoogleFonts.ubuntu(color: Colors.white),



    ),
    fontFamily: "ibm",
    canvasColor: Colors.black,
    appBarTheme: const AppBarTheme(color: Color(0xff1a1b1d)),

    iconButtonTheme: const IconButtonThemeData(style: ButtonStyle()),
    primaryIconTheme: const IconThemeData(color: Colors.green),

    unselectedWidgetColor: Colors.black,
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: const Color(0xff1a1b1d),
    primaryColor: Colors.white,
    secondaryHeaderColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white,opacity: 0.8),
  );

  static final lightTheme = ThemeData(
    textTheme: TextTheme(
      titleLarge: GoogleFonts.ubuntu(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
      bodySmall: GoogleFonts.ubuntu(color: Colors.black, fontSize: 15),
      labelSmall: GoogleFonts.ubuntu(color: Colors.black38, fontSize: 13),
      titleSmall: GoogleFonts.ubuntu(color: Colors.black, fontSize: 12),
      titleMedium: GoogleFonts.ubuntu(color: Colors.black, fontSize: 18),
      bodyMedium:GoogleFonts.ubuntu(color: Colors.black),
    ),
      fontFamily: "ibm",
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    unselectedWidgetColor: Colors.black,
    primaryColorLight: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.black , opacity: 0.8),
    colorScheme: const ColorScheme.light()
  );

}