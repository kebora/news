// Api key from the Website
import 'package:flutter/material.dart';

var defaultApiKey = "f3e0b1ee977943a29e0b4a43bfdc4b11";

//Google adMob
var appId = "ca-app-pub-5701966333947165~1865375078";

var productionAdUnitId = "ca-app-pub-5701966333947165/2741125433";

//In development adMob credentials
var testAdUnitId = "ca-app-pub-3940256099942544/5224354917";

//themes
//dark themeData
ThemeData darkThemeData = ThemeData.dark(useMaterial3: true).copyWith(
  primaryColor: const Color(0xFF1DA1F2),
  scaffoldBackgroundColor: const Color(0xFF1C1E21),
  cardColor: const Color(0xFF66757F),
  dividerColor: const Color(0xFF4A4D4E),
  highlightColor: const Color(0xFF4A4D4E),
  splashColor: const Color(0xFF4A4D4E),
  unselectedWidgetColor: const Color(0xFF8899A6),
  iconTheme: const IconThemeData(color: Colors.white),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFAD1F),
    foregroundColor: Colors.black,
  ),
);

//light themeData
ThemeData lightThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  useMaterial3: true,
);
