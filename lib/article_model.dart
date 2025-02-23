import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleSource{
  String? name;
  String? id;
  String? url;
  String? urlToIcon;

  ArticleSource({
    required this.id,
    required this.name,
    required this.url,
    required this.urlToIcon,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'url': url,
      'urlToIcon': urlToIcon,
    };
  }

  factory ArticleSource.fromJson(Map<String, dynamic> json){
    return ArticleSource(id: json["source_id"], name: json["source_name"], url: json["source_url"], urlToIcon: json["source_icon"]);
  }
}

class Question{
  String question;
  String? answer;

  Question({required this.question, required this.answer});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json){
    return Question(question: json["question"], answer: json["answer"]);
  }
}
///predefined categories, to avoid confusion with strings
enum Categories {business, technology, sports, science, health, environment, other;
}


class Article {
  List<Question>? questions;
  String title;
  String articleLink;
  String? description;
  String? content;
  String? publishedDate;
  String? imageLink;
  bool isCompleted;
  Categories category;
  ArticleSource source;
  String articleId;
  Article(
      {required this.source,
        required this.questions,
        required this.title,
        required this.category,
        required this.description,
        required this.articleLink,
        required this.imageLink,
        required this.publishedDate,
        required this.articleId,
        required this.content,
        required this.isCompleted,
      });

  Map<String, dynamic> toMap() {
    return {
      'article_id': articleId,
      'title': title,
      'content': content,
      'category': category.toString(),
      'description': description,
      'articleLink': articleLink,
      'imageLink': imageLink,
      'publishedDate': publishedDate,
    };
  }

  Article copyWith({
    String? articleId,
    ArticleSource? source,
    String? title,
    String? description,
    String? articleLink,
    String? imageLink,
    String? publishedDate,
    String? content,
    List<Question>? questions,
    Categories? category,
    bool? isCompleted,
  }) {
    return Article(
      articleId: articleId ?? this.articleId,
      source: source ?? this.source,
      title: title ?? this.title,
      description: description ?? this.description,
      articleLink: articleLink ?? this.articleLink,
      imageLink: imageLink ?? this.imageLink,
      publishedDate: publishedDate ?? this.publishedDate,
      content: content ?? this.content,
      questions: questions ?? this.questions,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  ///this method is only called if data for the day is not already present in firebase.
  static Future<Article> fromJson(Map<String, dynamic> json) async {
    print("in fromJson");
    Categories cat;
    try{
      cat = Categories.values.firstWhere((e) => e.toString() == 'Categories.' + json['category'][0]);
    }
    catch (e) {
      cat = Categories.other;
    }
    print(cat);

    // String? resp = await getClaudeSummary(json['link'] as String);
    print("summary");
    // print(resp);
    print("summary");
    // List<Question> quests = await getClaudeQuestions(resp);
    // print(quests);
    print("run");
    print(json["title"]);
    print(json["description"]);
    print(json["link"]);
    print(json["image_url"]);
    print(json["pubDate"]);
    // print(resp);
    print(json["article_id"]);
    // print(quests);
    print(cat);

    return Article(
        source: ArticleSource.fromJson(json),
        title: json['title'],
        description: json['description'],
        articleLink: json['link'],
        imageLink: json['image_url'],
        publishedDate: json['pubDate'],
        content: "resp",
        articleId: json["article_id"],
        questions: [],
        category: cat,
        isCompleted: false
    );
  }
}



