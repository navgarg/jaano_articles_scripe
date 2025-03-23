import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'article_api_service.dart';
import '../article_model.dart';
import 'firestore_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final articlesProvider =
NotifierProvider<ArticlesNotifier, AsyncValue<List<Article>>>(ArticlesNotifier.new);

class ArticlesNotifier extends Notifier<AsyncValue<List<Article>>> {
  @override
  AsyncValue<List<Article>> build() => const AsyncValue.loading();
  // ArticlesNotifier() : super(const AsyncValue.loading());



  Future<void> fetchArticles(Categories selectedCategory) async {
    // if (state.isRefreshing) return;

    print("Selected category");
    print(selectedCategory);
    print("Selected category");

    // FirestoreService client = FirestoreService();
    state = const AsyncLoading();
    try {
      // final articles = await client.getFirebaseArticles(selectedCategory);
      final articles = await ApiService().getArticle(selectedCategory);
      if(articles.isEmpty){
        print("request alr in prog");
        state = const AsyncLoading();
        return;
      }
      // final completedArticleIds = await client.getCompletedArticles("user.id");
      // print("got completed articles");
      // print(completedArticleIds);
      // final updatedArticles = articles.map((article) {
      //   return article.copyWith(
      //     isCompleted: completedArticleIds.contains(article.articleId),
      //   );
      // }).toList();
      // print(updatedArticles);
      state = AsyncValue.data(articles); // Update the state with fetched articles
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

}

final carouselIndexProvider = StateProvider<int>((ref) => 0);

final selectedCategoryProvider = Provider<Categories>((ref) {
  print("page changed");
  final currentIndex = ref.watch(carouselIndexProvider);
  List<Categories> categoryEnums = ["economy", "nature", "food", "science", "sports", "technology"]
      .map((str) => Categories.values.byName(str))
      .toList();

  return categoryEnums[currentIndex]; // Map index to the enum or category list
});

class SelectedArticlesNotifier extends StateNotifier<Set<Article>> {
  SelectedArticlesNotifier() : super({}); // Initialize with an empty set

  void toggleSelection(Article article) {
    if (state.contains(article)) {
      state = {...state}..remove(article); // Remove if already selected
    } else {
      state = {...state}..add(article); // Add if not selected
    }
  }
}

// Provider to access selected articles
final selectedArticlesProvider =
StateNotifierProvider<SelectedArticlesNotifier, Set<Article>>(
        (ref) => SelectedArticlesNotifier());