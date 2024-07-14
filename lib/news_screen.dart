import 'package:flutter/material.dart';
import 'post_service.dart';
import 'post_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      List<Post> posts = await PostService.fetchPosts();
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      // Handle the error here, e.g., show a message to the user
      print('Error loading posts: $e');
    }
  }

  void _addPost() async {
    // Example of adding a post
    Post newPost =
        Post(id: 'new_id', title: 'New Post', content: 'New content');
    setState(() {
      _posts.add(newPost);
    });

    // Add to the server or actual database
    // await PostService.addPost(newPost);
  }

  void _deletePost(String id) async {
    setState(() {
      _posts.removeWhere((post) => post.id == id);
    });

    // Delete from the server or actual database
    // await PostService.deletePost(id);
  }

  void _editPost(String id) {
    // Edit the post content
    int index = _posts.indexWhere((post) => post.id == id);
    if (index != -1) {
      setState(() {
        _posts[index].title = 'Edited Post Title';
        _posts[index].content = 'Edited Content';
      });

      // Save the changes to the server or actual database
      // await PostService.updatePost(_posts[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addPost,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Dismissible(
            key: Key(post.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deletePost(post.id);
            },
            child: ListTile(
              title: Text(post.title),
              subtitle: Text(post.content),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(id: post.id),
                  ),
                );
              },
              onLongPress: () {
                _editPost(post.id);
              },
            ),
          );
        },
      ),
    );
  }
}
