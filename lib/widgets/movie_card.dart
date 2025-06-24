import 'dart:io';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:intl/intl.dart';

/// A widget that displays a movie as a card in a list
/// Shows movie poster, title, rating, and watch status
class MovieCard extends StatelessWidget {
  /// Movie object containing the data to display
  final Movie movie;
  
  /// Whether to color the card based on watch status
  /// If true, watched movies are blue-tinted, unwatched are grey
  final bool colorByWatchStatus;
  
  /// Callback function when delete button is pressed
  final VoidCallback onDelete;
  
  /// Optional callback function when card is tapped
  final VoidCallback? onTap;

  /// Creates a MovieCard widget
  /// [movie] The movie to display
  /// [onDelete] Function to call when delete is pressed
  /// [colorByWatchStatus] Whether to apply watch status-based coloring
  /// [onTap] Optional function to call when card is tapped
  MovieCard({
    required this.movie,
    required this.onDelete,
    this.colorByWatchStatus = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    /// Background color based on watch status if enabled
    final backgroundColor =
        colorByWatchStatus
            ? (movie.watched ? Colors.blue.shade50 : Colors.grey.shade100)
            : Colors.white;

    /// Format the watch date text
    final String dateText =
        movie.watched && movie.dateWatched != null
            ? 'Watched on: ${DateFormat('yyyy-MM-dd').format(movie.dateWatched!)}'
            : 'To Watch';

    return Container(
      color: backgroundColor,
      child: ListTile(
        // Display movie poster as circle avatar if available, otherwise show placeholder
        leading:
            movie.imagePath != null && File(movie.imagePath!).existsSync()
                ? CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: FileImage(File(movie.imagePath!)),
                )
                : CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.movie, color: Colors.grey.shade700),
                ),

        title: Text(movie.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display star rating
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < movie.rating ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                  size: 16,
                ),
              ),
            ),
            SizedBox(height: 4),
            // Display watch status or date
            Text(
              dateText,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}