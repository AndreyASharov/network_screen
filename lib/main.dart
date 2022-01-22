import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Ошибка загрузки данных');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;
  final String body;
  Album({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body']);
  }
}

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  late Future<Album> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Данные из сети'),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    const Text('Заголовок', style: TextStyle(fontSize: 20)),
                    Text(snapshot.data!.title,
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                    const Text('Сообщение', style: TextStyle(fontSize: 20)),
                    Text(snapshot.data!.body),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
      home: Scaffold(
    body: Post(),
  )));
}
