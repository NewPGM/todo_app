import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  final String id;
  late final String title;
  late final String content;

  Post({required this.id, required this.title, required this.content});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
      };
}

class PostService {
  static const String baseUrl = 'https://example.com/api';
  static const Duration timeout = Duration(seconds: 10);

  static Future<List<Post>> fetchPosts() async {
    final client = http.Client();
    try {
      print('Sending request to $baseUrl/posts');
      final response =
          await client.get(Uri.parse('$baseUrl/posts')).timeout(timeout);
      print('Received response');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load posts: $e');
    } finally {
      client.close();
    }
  }

  static Future<Post> fetchPost(String id) async {
    final client = http.Client();
    try {
      print('Sending request to $baseUrl/posts/$id');
      final response =
          await client.get(Uri.parse('$baseUrl/posts/$id')).timeout(timeout);
      print('Received response');
      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load post: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load post: $e');
    } finally {
      client.close();
    }
  }

  static Future<void> addPost(Post post) async {
    final client = http.Client();
    try {
      print('Sending request to $baseUrl/posts');
      final response = await client
          .post(
            Uri.parse('$baseUrl/posts'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(post.toJson()),
          )
          .timeout(timeout);
      print('Received response');
      if (response.statusCode != 201) {
        throw Exception('Failed to add post: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add post: $e');
    } finally {
      client.close();
    }
  }

  static Future<void> updatePost(Post post) async {
    final client = http.Client();
    try {
      print('Sending request to $baseUrl/posts/${post.id}');
      final response = await client
          .put(
            Uri.parse('$baseUrl/posts/${post.id}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(post.toJson()),
          )
          .timeout(timeout);
      print('Received response');
      if (response.statusCode != 200) {
        throw Exception('Failed to update post: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update post: $e');
    } finally {
      client.close();
    }
  }

  static Future<void> deletePost(String id) async {
    final client = http.Client();
    try {
      print('Sending request to $baseUrl/posts/$id');
      final response =
          await client.delete(Uri.parse('$baseUrl/posts/$id')).timeout(timeout);
      print('Received response');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete post: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete post: $e');
    } finally {
      client.close();
    }
  }
}
