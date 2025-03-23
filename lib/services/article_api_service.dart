import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../article_model.dart';
import '../constants.dart';

class ApiService {
  final client = http.Client();
  // static const String lastFetchKey = 'last_fetch_date';
  // static const String articlesCacheKey = 'cached_articles';

  ///Make HTTP request and get news articles from API
  Future<List<Article>> getArticle(Categories cat) async {

    final prefs = await SharedPreferences.getInstance();
    final String categoryFetchKey = 'last_fetch_date_${cat.name}';
    final String categoryCacheKey = 'cached_articles_${cat.name}';

    final lastFetchDate = prefs.getString(categoryFetchKey) ?? "";
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";
    final currentHour = now.hour;

    // Fetch only if:
    // - The last fetch was on a different day
    // - The current time is >= 6 AM
    if (lastFetchDate == today || currentHour < 6) {
      print("skipping fetch");
      final cachedData = prefs.getString(categoryCacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        List<Article> cachedArticles = await Future.wait(
          jsonList.map((e) => Article.fromJson(e)).toList(),
        );

        print("Loaded ${cachedArticles.length} articles from cache.");
        return cachedArticles;
      } else {
        print("No cached articles found.");
        return []; // No data available
      }//Return empty list to indicate no new fetch
    }

    print("Fetching new articles for category: ${cat.name}");
    print("Base URL: $baseUrl");
    print("News URL: $newsUrl");
    try{
      final uri = Uri.parse('$baseUrl$newsUrl&category=${cat.name}');
      print(uri);
      final response = await client.get(uri);
      var json = jsonDecode(response.body);
      // Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['results'];

      print(body);
      ///retrieve and store articles in list of type article.
      // List<Article> articles = List<Article>.from(body.map((e) async => await Article.fromJson(e)).toList());
      List<Article> articles = await Future.wait(body.map((e) async => Article.fromJson(e)).toList());
      print("article rcvd successfully");
      print(articles);
      prefs.setString(categoryFetchKey, today);
      prefs.setString(categoryCacheKey, jsonEncode(body));
      return articles;
    } catch (e) {
      print("Error fetching articles: $e");
      return [];
    // } finally {
    //   _isFetching = false; // Reset flag after request completes
    }
  }
}