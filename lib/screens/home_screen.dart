import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

/// Filter options for movie list display
enum MovieFilter { all, watched, toWatch }

/// Main screen of the application displaying the list of movies
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State management for HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  /// Currently selected filter for movie list
  MovieFilter _selectedFilter = MovieFilter.all;
  
  /// List of all movies in the application
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  /// Loads movies from SharedPreferences storage
  Future<void> _loadMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('movies');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      setState(() {
        _movies = decoded.map((e) => Movie.fromJson(e)).toList();
      });
    }
  }

  /// Saves current movie list to SharedPreferences storage
  Future<void> _saveMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_movies.map((m) => m.toJson()).toList());
    await prefs.setString('movies', jsonString);
  }

  /// Returns filtered list of movies based on selected filter
  List<Movie> get _filteredMovies {
    switch (_selectedFilter) {
      case MovieFilter.watched:
        return _movies.where((movie) => movie.watched).toList();
      case MovieFilter.toWatch:
        return _movies.where((movie) => !movie.watched).toList();
      default:
        return _movies;
    }
  }

  /// Removes a movie from the list and updates storage
  void _deleteMovie(Movie movie) {
    setState(() {
      _movies.remove(movie);
    });
    _saveMovies();
  }

  /// Handles the FAB press to add a new movie
  void _onFabPressed() async {
    final newMovie = await Navigator.pushNamed(context, '/add');
    if (newMovie != null && newMovie is Movie) {
      setState(() {
        _movies.add(newMovie);
      });
      _saveMovies();
    }
  }

  /// Opens detail view for a movie and handles possible actions (delete/update)
  void _openDetail(Movie movie) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: movie,
    );

    if (result == 'delete') {
      setState(() {
        _movies.remove(movie);
      });
      _saveMovies();

      // Show snackbar with undo option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${movie.title} deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _movies.add(movie);
              });
              _saveMovies();
            },
          ),
        ),
      );
    } else if (result is Movie) {
      // Update existing movie
      final index = _movies.indexOf(movie);
      if (index != -1) {
        setState(() {
          _movies[index] = result;
        });
        _saveMovies();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Diary'),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: _onFabPressed),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: DropdownButton<MovieFilter>(
              value: _selectedFilter,
              onChanged: (value) {
                if (value != null) setState(() => _selectedFilter = value);
              },
              items:
                  MovieFilter.values.map((filter) {
                    return DropdownMenuItem(
                      value: filter,
                      child: Text(filter.name.toUpperCase()),
                    );
                  }).toList(),
            ),
          ),
          Expanded(
            child:
                _filteredMovies.isEmpty
                    ? Center(child: Text('No movies to display'))
                    : ListView.builder(
                      itemCount: _filteredMovies.length,
                      itemBuilder:
                          (ctx, i) => MovieCard(
                            movie: _filteredMovies[i],
                            colorByWatchStatus:
                                _selectedFilter == MovieFilter.all,
                            onDelete: () => _deleteMovie(_filteredMovies[i]),
                            onTap: () => _openDetail(_filteredMovies[i]),
                          ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: Icon(Icons.add),
      ),
    );
  }
}