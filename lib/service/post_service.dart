import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  final String postUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Fetch all posts
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(postUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Post> posts = body.map((dynamic item) {
        return Post.fromJson(item);
      }).toList();
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Fetch a single post by ID
  Future<Post> fetchPostById(int id) async {
    final response = await http.get(Uri.parse('$postUrl/$id'));

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Create a new post
  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse(postUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  // Update an existing post
  Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$postUrl/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update post');
    }
  }

  // Delete a post
  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$postUrl/$id'));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete post');
    }
  }
}
