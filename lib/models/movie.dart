import 'dart:io';

/// Represents a movie with its details such as title, rating, review and watch status
class Movie {
  /// Title of the movie
  String title;
  
  /// Rating of the movie (numerical value)
  int rating;
  
  /// Written review/comments about the movie
  String review;
  
  /// Indicates whether the movie has been watched
  bool watched;
  
  /// Date when the movie was watched (nullable)
  DateTime? dateWatched;
  
  /// Path to the movie poster image file (nullable)
  String? imagePath;

  /// Constructor to create a Movie instance
  Movie({
    required this.title,
    required this.rating,
    required this.review,
    required this.watched,
    this.dateWatched,
    this.imagePath,
  });

  /// Converts the Movie instance to a JSON map
  /// Returns a map containing all movie properties
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'rating': rating,
      'review': review,
      'watched': watched,
      'dateWatched': dateWatched?.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  /// Creates a Movie instance from a JSON map
  /// [json] The map containing movie data
  /// Returns a new Movie instance
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      rating: json['rating'],
      review: json['review'],
      watched: json['watched'],
      dateWatched:
          json['dateWatched'] != null
              ? DateTime.tryParse(json['dateWatched'])
              : null,
      imagePath: json['imagePath'],
    );
  }
}