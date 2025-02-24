import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaano_articles_scripe/list_tile.dart';
import 'package:jaano_articles_scripe/riverpod_providers.dart';
import 'article_model.dart';
import 'carousel.dart';
import 'constants.dart';

class ArticlesScreen extends ConsumerWidget {
  final Categories category;

  ArticlesScreen({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articlesProvider(category));
    final carouselIndex = ref.watch(carouselIndexProvider);
    final selectedArticles = ref.watch(selectedArticlesProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Articles - ${category.name}")),
      body: SafeArea(
        child: Column(
          children: [
            const Carousel(),
            Expanded(
              child: articlesAsync.when(
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
                              const Text("Selected:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ...selectedArticles.map((article) => Text(article.title, style: const TextStyle(fontSize: 16))),
                              const Divider(height: 5.0,), // Separator
                            ],
                          ),
                        ),
                  
                      /// List of all articles with checkboxes
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              final article = articles[index];
                              final isSelected = selectedArticles.contains(article);

                              return CustomListTile(article: article, carouselIndex: carouselIndex, isSelected: isSelected);
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
        ]
        ),
      ),
    );
  }
}
