import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:restart_app/restart_app.dart';
import 'package:technews/constants.dart';
import 'package:technews/controllers/category_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    //controller for the category textField
    final CategoryController categoryController = Get.put(CategoryController());
    //AdMob
    RewardedAd? rewardedAd;
    //
    final adUnitId = Platform.isAndroid ? testAdUnitId : productionAdUnitId;
    // final adUnitId = productionAdUnitId;

    //load ad function
    /// Loads a rewarded ad.
    void loadAd() {
      RewardedAd.load(
          adUnitId: adUnitId,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) {
              ad.fullScreenContentCallback = FullScreenContentCallback(
                  // Called when the ad showed the full screen content.
                  onAdShowedFullScreenContent: (ad) {},
                  // Called when an impression occurs on the ad.
                  onAdImpression: (ad) {},
                  // Called when the ad failed to show full screen content.
                  onAdFailedToShowFullScreenContent: (ad, err) {
                    // Dispose the ad here to free resources.
                    ad.dispose();
                  },
                  // Called when the ad dismissed full screen content.
                  onAdDismissedFullScreenContent: (ad) {
                    // Dispose the ad here to free resources.
                    ad.dispose();
                  },
                  // Called when a click is recorded for an ad.
                  onAdClicked: (ad) {});

              debugPrint('$ad loaded.');
              // Keep a reference to the ad so you can show it later.
              rewardedAd = ad;
            },
            // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) {
              debugPrint('RewardedAd failed to load: $error');
            },
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontFamily: "Montserrat"),
        ),
        backgroundColor:
            Get.isDarkMode ? Colors.black12 : Colors.purple.shade50,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.category,
              color: Colors.red[200],
            ),
            title: const Text(
              "Change News category",
            ),
            subtitle: Text(
              "Current Default: ${GetStorage().read("category")}",
              style: const TextStyle(fontFamily: "Montserrat"),
            ),
            onTap: () => Get.defaultDialog(
              title: "Change topic",
              content: ListTile(
                title: TextField(
                  onChanged: categoryController.onChanged,
                  decoration: InputDecoration(
                    hintText: "E.g. Science",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              confirm: ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  loadAd();
                  rewardedAd!.show(onUserEarnedReward:
                      (AdWithoutView ad, RewardItem rewardItem) {
                    // Reward the user for watching an ad.
                    if (categoryController.text.value.isNotEmpty) {
                      Restart.restartApp();
                    }
                  });
                },
                child: const Text("Watch 1 ad to Save"),
              ),
              cancel: TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.sunny_snowing,
              color: Colors.red[200],
            ),
            title: const Text(
              "Change App Theme",
            ),
            subtitle: const Text(
              "Change between dark and light themes",
              style: TextStyle(fontFamily: "Montserrat"),
            ),
            onTap: () => saveCurrentTheme(),
          ),
          ListTile(
            leading: Icon(
              Icons.close_rounded,
              color: Colors.red[200],
            ),
            title: const Text(
              "Exit Application",
            ),
            subtitle: const Text(
              "Application will be closed",
              style: TextStyle(
                fontFamily: "Montserrat",
              ),
            ),
            onTap: () {
              Get.defaultDialog(
                title: "Exit App",
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: const Text("Sure"),
                  ),
                ],
                middleText: "Are you sure?",
              );
            },
          ),
        ],
      ),
    );
  }
}

void saveCurrentTheme() {
  Get.changeTheme(
    Get.isDarkMode ? lightThemeData : darkThemeData,
  );
  //
  Get.isDarkMode
      ? GetStorage().write("theme", false)
      : GetStorage().write("theme", true);
  //
}
