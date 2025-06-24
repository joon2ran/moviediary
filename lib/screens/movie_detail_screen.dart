import 'dart:io';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:intl/intl.dart';

/// Screen that displays detailed information about a specific movie
/// Shows movie poster, rating, review, and watch status
class MovieDetailScreen extends StatefulWidget {
  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

/// State class for MovieDetailScreen that manages the movie data display
class _MovieDetailScreenState extends State<MovieDetailScreen> {
  /// Movie object containing all the details to be displayed
  late Movie movie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize movie object from navigation arguments
    movie = ModalRoute.of(context)!.settings.arguments as Movie;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster section
            Center(
              child:
                  movie.imagePath != null && File(movie.imagePath!).existsSync()
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(movie.imagePath!),
                          width: 200,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Container(
                        width: 200,
                        height: 300,
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.movie,
                          size: 80,
                          color: Colors.grey.shade700,
                        ),
                      ),
            ),
            SizedBox(height: 16),
            // Rating section with star display
            Text("Rating", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < movie.rating ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Review section
            Text("Review", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              movie.review.isNotEmpty ? movie.review : "No review available.",
              style: TextStyle(fontSize: 16),
              softWrap: true,
            ),
            SizedBox(height: 16),
            // Watch status section with date if watched
            Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              movie.watched
                  ? "Watched on ${DateFormat('yyyy-MM-dd').format(movie.dateWatched!)}"
                  : "Not Watched",
            ),
          ],
        ),
      ),
    );
  }
}