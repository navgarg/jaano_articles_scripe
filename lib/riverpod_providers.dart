import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'article_api_service.dart';
import 'article_model.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final articlesProvider = FutureProvider.family<List<Article>, Categories>((ref, cat) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getArticle(cat);
});

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