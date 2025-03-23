import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaano_articles_scripe/services/firestore_service.dart';
import 'package:jaano_articles_scripe/widgets/list_tile.dart';
import 'package:jaano_articles_scripe/services/riverpod_providers.dart';
import '../article_model.dart';
import '../widgets/carousel.dart';
import '../constants.dart';

class ArticlesScreen extends ConsumerWidget {
  // final Categories category;

  ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final carouselIndex = ref.watch(carouselIndexProvider);
    final articlesState = ref.watch(articlesProvider);
    var selectedArticles = ref.watch(selectedArticlesProvider);
    final articlesNotifier = ref.read(articlesProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('addPostFrameCallback: articlesState = $articlesState');

      if (articlesState is AsyncData) return; // Avoid re-fetching

      articlesNotifier.fetchArticles(categories[carouselIndex]);
    });

    ///re-fetch articles everytime category is changed
    ref.listen<int>(carouselIndexProvider, (previousIndex, newIndex) {
      articlesNotifier.fetchArticles(categories[newIndex]);
      selectedArticles.clear();
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const Carousel(),
            Expanded(
              child: articlesState.when(
                data: (articles) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        /// Display selected articles at the top
                        if (selectedArticles.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Selected:",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                ...selectedArticles.map((article) =>
                                    CustomListTile(
                                        article: article,
                                        carouselIndex: carouselIndex,
                                        isSelected: true)),
                              ],
                            ),
                          ),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "All Articles:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// List of all articles with checkboxes
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              final article = articles[index];
                              final isSelected =
                                  selectedArticles.contains(article);

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(children: [
                                  CustomListTile(
                                      article: article,
                                      carouselIndex: carouselIndex,
                                      isSelected: isSelected),
                                ]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Error: $err")),
              ),
            ),
            const SizedBox(height: 15,),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            var ser = FirestoreService();
            for (final article in selectedArticles) {
              ser.addArticle(article);
              print("added article ${article.title}");
            }
          },
        backgroundColor: const Color(0xFF090438),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40.0,
        ),
          ),
    );
  }
}
