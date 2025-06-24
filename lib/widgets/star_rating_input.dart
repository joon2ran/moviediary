import 'package:flutter/material.dart';

/// A widget that displays an interactive star rating system
/// Allows users to select a rating from 1 to 5 stars by tapping on stars
class StarRatingInput extends StatelessWidget {
  /// Current rating value (1-5)
  final int rating;

  /// Callback function triggered when user changes the rating
  /// [newRating] The new rating value selected by the user
  final Function(int) onRatingChanged;

  /// Creates a StarRatingInput widget
  /// [rating] The initial/current rating to display
  /// [onRatingChanged] Function to call when rating is changed
  StarRatingInput({required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // Generate 5 interactive star icons
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            // Fill star if index is less than current rating
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
          // When pressed, update rating to index + 1 (as index is 0-based)
          onPressed: () => onRatingChanged(index + 1),
        );
      }),
    );
  }
}