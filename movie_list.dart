import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<dynamic> _movies = [];
  bool error = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    String apiUrl = 'https://hoblist.com/api/movieList';

    try {
      error = false;
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'category': 'movies',
          'language': 'kannada',
          'genre': 'all',
          'sort': 'voting',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data); // Print API response in the console
        setState(() {
          _movies = data['result'];
        });
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (wrong) {
      error = true;
      setState(() {});
      print('Error: $error');
    }
  }

  void _showCompanyInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Company Info'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Company: Geeksynergy Technologies Pvt Ltd'),
              SizedBox(height: 8),
              Text('Address: Sanjayanagar, Bengaluru-56'),
              SizedBox(height: 8),
              Text('Phone: XXXXXXXXX09'),
              SizedBox(height: 8),
              Text('Email: XXXXXX@gmail.com'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showCompanyInfoDialog,
          ),
        ],
      ),
      body: error
          ? Text('error')
          : ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          movie['poster'],
                          height: 135,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            '${movie['title']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Text(
                          'Language: ${movie['language']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Genre: ${movie['genre']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Voting: ${movie['voting']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Director: ${movie['director']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
