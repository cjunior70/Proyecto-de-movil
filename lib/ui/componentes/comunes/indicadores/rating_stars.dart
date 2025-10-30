import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double itemSize;
  final bool showRatingNumber;
  final bool allowHalfRating;
  final void Function(double)? onRatingUpdate;

  const RatingStars({
    super.key,
    required this.rating,
    this.itemSize = 18,
    this.showRatingNumber = true,
    this.allowHalfRating = true,
    this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: rating,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: allowHalfRating,
          itemCount: 5,
          itemSize: itemSize,
          itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: onRatingUpdate ?? (rating) {},
          ignoreGestures: onRatingUpdate == null,
        ),
        if (showRatingNumber) ...[
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}