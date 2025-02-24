import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaano_articles_scripe/riverpod_providers.dart';

import 'article_model.dart';
import 'constants.dart';

class CustomListTile extends ConsumerWidget {
  Article article;
  int carouselIndex;
  bool isSelected;
  CustomListTile({super.key,
    required this.article,
    required this.carouselIndex,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedArticles = ref.watch(selectedArticlesProvider);

    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Container(
        height:
        MediaQuery
            .of(context)
            .size
            .height * 0.18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(homeTileColors[carouselIndex]),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 8.0),
        child: Row(
          children: [
            SizedBox(width: width * 0.005,),
            // Actual image
            Image.network(
              fit: BoxFit.cover,
              width: width * 0.15, //todo: check
              article.source.urlToIcon.toString(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child; /// Show the image once it's loaded
                }
                return Container();
              },
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Error loading image',
                  style: TextStyle(color: Colors.red),
                ); /// Handle errors gracefully
              },
            ),
            // Image.asset("assets/circuit.png", width: width * 0.25,),
            // SizedBox(width: width * 0.025,),
            Expanded(
                child: Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                )
            ),
            SizedBox(width: width * 0.025,),
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                ref.read(selectedArticlesProvider.notifier).toggleSelection(article);
              },
            ),
            SizedBox(width: width * 0.025,),
          ],
        ),

      ),
    );
  }
}