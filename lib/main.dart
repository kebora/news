import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:technews/constants.dart';
import 'package:technews/settings.dart';
import 'package:technews/widgets/news_updates.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await GetStorage.init();

  /// Initialize the getStorage() value for key : theme
  /// if none already exists
  if ({GetStorage().read("theme")}.isEmpty) {
    await GetStorage().write("theme", false);
  }
  if (!GetStorage().hasData("category")) {
    GetStorage().write("category", 'Technology');
  }

  ///
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News',
      theme:
          GetStorage().read("theme") == false ? lightThemeData : darkThemeData,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Get.isDarkMode ? Colors.black12 : Colors.purple.shade50,
        title: const Text(
          "News",
          style: TextStyle(fontFamily: "Montserrat"),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const SettingsPage()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const SafeArea(
        child: NewsUpdates(),
      ),
    );
  }
}
