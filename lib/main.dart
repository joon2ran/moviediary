import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_movie_screen.dart';
import 'screens/movie_detail_screen.dart';

void main() {
  runApp(MovieDiaryApp());
}

class MovieDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Diary',
      theme: ThemeData(primarySwatch: Colors.indigo),
      routes: {
        '/': (ctx) => HomeScreen(),
        '/add': (ctx) => AddMovieScreen(),
        '/detail': (ctx) => MovieDetailScreen(),
      },
    );
  }
}
