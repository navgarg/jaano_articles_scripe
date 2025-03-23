import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../article_model.dart';
import 'article_api_service.dart';
import 'claude_api_service.dart';

enum PointType{quizPoints, articlePoints}
class FirestoreService {

  CollectionReference ref = FirebaseFirestore.instance.collection("articles");
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addArticle(Article article) async {
    String? resp = await getClaudeSummary(article.articleLink);
    print("got summary");
    print(resp);
    List<Question> quests = await getClaudeQuestions(resp);
    print("got questions");
    print(quests);
    article.content = resp;
    article.questions = quests;

    print("in add article");
    try {
      print("in try");
      DocumentReference dateDoc = ref.doc(date);
      CollectionReference artsCollection = dateDoc.collection('arts');

      // Check if the article already exists by title or unique identifier
      QuerySnapshot existingArticles = await artsCollection
          .where("id", isEqualTo: article.articleId)
          .get();

      if (existingArticles.docs.isNotEmpty) {
        print("Article already exists in Firestore: ${article.title}");
        return; // Stop duplicate insertion
      }
      DocumentReference articleDoc = await artsCollection.add(article.toMap());


      String articleId = articleDoc.id;
      await articleDoc.update({"id": articleId});

      print("Added article");
      await articleDoc.collection('source').add(article.source.toMap());

      print("added source");
      for (var question in article.questions!) {
        await articleDoc.collection('questions').add(question.toMap());
      }
      print("added questions");

      print("Article added successfully!");
    } catch (e) {
      print("Error adding article: $e");
    }
  }

}
