import 'dart:convert';

import 'package:fetchcustomejson/model/custom_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomeApi(),
    );
  }
}

class CustomeApi extends StatefulWidget {
  const CustomeApi({super.key});

  @override
  State<CustomeApi> createState() => _CustomeApiState();
}

class _CustomeApiState extends State<CustomeApi> {
  List<Posts> posts = [];

  Future<List<Posts>> getApi() async {
    var response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        Posts post = Posts(title: i['title'], body: i['body']);
        posts.add(post);
      }
      return posts;
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getApi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title.toString()),
                    );
                  },
                );
              } else {
                return Text("sorry");
              }
            },
          ))
        ],
      )),
    );
  }
}
