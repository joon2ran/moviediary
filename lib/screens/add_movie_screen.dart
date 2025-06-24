import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/movie.dart';
import '../widgets/star_rating_input.dart';

/// Screen for adding a new movie to the collection
class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

/// State class for AddMovieScreen that handles form input and image selection
class _AddMovieScreenState extends State<AddMovieScreen> {
  /// Key for the form validation
  final _formKey = GlobalKey<FormState>();
  
  /// Movie details
  String _title = '';
  int _rating = 0;
  String _review = '';
  bool _watched = false;
  DateTime? _selectedDate;
  
  /// Image handling properties
  File? _selectedImage;
  String? _savedImagePath;
  final ImagePicker _picker = ImagePicker();

  /// Opens a date picker dialog and updates the selected date
  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Opens the device gallery to select a movie poster image
  /// Saves the selected image to the app's documents directory
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${dir.path}/$fileName');
      setState(() {
        _selectedImage = savedImage;
        _savedImagePath = savedImage.path;
      });
    }
  }

  /// Validates and saves the form data
  /// Creates a new Movie object and returns it to the previous screen
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newMovie = Movie(
        title: _title,
        rating: _rating,
        review: _review,
        watched: _watched,
        dateWatched: _watched ? (_selectedDate ?? DateTime.now()) : null,
        imagePath: _savedImagePath,
      );
      Navigator.pop(context, newMovie);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Movie')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Movie Title'),
                onSaved: (value) => _title = value ?? '',
                validator:
                    (value) => value!.isEmpty ? 'Enter a movie title' : null,
              ),
              SizedBox(height: 16),
              Text('Rating:'),
              StarRatingInput(
                rating: _rating,
                onRatingChanged: (val) => setState(() => _rating = val),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Review',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onSaved: (value) => _review = value ?? '',
              ),
              SwitchListTile(
                title: Text('Watched'),
                value: _watched,
                onChanged: (val) => setState(() => _watched = val),
              ),
              if (_watched)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No date selected'
                            : 'Date: ${_selectedDate!.toIso8601String().split("T")[0]}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: Text('Select Date'),
                    ),
                  ],
                ),
              Row(
                children: [
                  _selectedImage != null
                      ? Image.file(_selectedImage!, width: 100, height: 100)
                      : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey.shade300,
                        child: Icon(Icons.image),
                      ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.photo),
                    label: Text('Add Poster'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveForm, child: Text('Save Movie')),
            ],
          ),
        ),
      ),
    );
  }
}