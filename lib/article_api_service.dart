import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'article_model.dart';
import 'constants.dart';

class ApiService {
  final client = http.Client();
  static bool _isFetching = false;

  ///Make HTTP request and get news articles from API
  Future<List<Article>> getArticle(Categories cat) async {
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
      // List<Article> articles = [];
      // for (var e in body) {
      //   articles.add(await Article.fromJson(e));
      // }
      // for (var art in articles) {
      //   FirestoreService service = FirestoreService();
      //   service.addArticle(art);
      // }

      // List<Article> arts = articles.where((art) => art.category == cat).toList();
      print("article rcvd successfully");
      print(articles);
      return articles;
    } catch (e) {
      print("Error fetching articles: $e");
      return [];
    // } finally {
    //   _isFetching = false; // Reset flag after request completes
    }
  }
}