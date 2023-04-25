import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:restart_app/restart_app.dart';
import 'package:technews/models/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:technews/constants.dart';
import 'package:technews/settings.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<Articles>> fetchNews() async {
  var category = GetStorage().hasData("category")
      ? GetStorage().read("category")
      : "Technology";

  var apiKey =
      GetStorage().hasData("api") ? GetStorage().read("api") : defaultApiKey;

  var endPoint = "https://newsapi.org/v2/everything?q=$category&apiKey=$apiKey";

  final response = await http.get(Uri.parse(endPoint));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final List<dynamic> articleList = jsonData['articles'];
    return articleList.map((json) => Articles.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch news');
  }
}

Future<void> _launchUrl(String articleUrl) async {
  if (!await launchUrl(Uri.parse(articleUrl))) {
    throw Exception('Could not launch url');
  }
}

class NewsUpdates extends StatefulWidget {
  const NewsUpdates({super.key});

  @override
  State<NewsUpdates> createState() => _NewsUpdatesState();
}

class _NewsUpdatesState extends State<NewsUpdates> {
  late Future<List<Articles>> newsFeed;

  ///Will try to implement response to changes with [didChangeDependencies]
  @override
  void initState() {
    super.initState();
    newsFeed = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: newsFeed,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final articles = snapshot.data;
          return ListView.builder(
            itemCount: articles!.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Column(
                children: [
                  Image.network("${article.urlToImage}"),
                  ListTile(
                    title: Text(
                      "${article.title}",
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      "${article.description}",
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                      ),
                    ),
                    onTap: () => _launchUrl("${article.url}"),
                  ),
                ],
              );
            },
          );
        }
        if (snapshot.hasError) {
          if ((snapshot.error).toString() ==
              "Exception: Failed to fetch news") {
            return SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset("assets/images/disconnected.json", height: 200),
                  Text(
                    "Your current search category is:${GetStorage().read("category")}",
                    style: const TextStyle(fontFamily: "Montserrat"),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.to(() => const SettingsPage()),
                    child: const Text("Change category"),
                  )
                ],
              ),
            );
          }
          log("${snapshot.error}");
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("assets/images/disconnected.json", height: 200),
                Text(
                  "Your current search category is:${GetStorage().read(
                        "category",
                      ) == "" ? "Empty" : "${GetStorage().read(
                      "category",
                    )}"}",
                  style: const TextStyle(fontFamily: "Montserrat"),
                ),
                ElevatedButton(
                  onPressed: () => Get.to(() => const SettingsPage()),
                  child: const Text("Change category"),
                ),
                ElevatedButton(
                  onPressed: () => Restart.restartApp(),
                  child: const Text("Restart App"),
                ),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Loading"),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
