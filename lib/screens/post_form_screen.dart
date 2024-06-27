import 'package:flutter/material.dart';

import 'package:api_integration_demo/models/post.dart';
import 'package:api_integration_demo/service/post_service.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post;
  final Function(Post) onSave;

  const PostFormScreen({super.key, this.post, required this.onSave});

  @override
  _PostFormScreenState createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final PostService postService = PostService();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _savePost() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        userId: widget.post?.userId ?? 1,
        id: widget.post?.id ?? 0,
        title: _titleController.text,
        body: _bodyController.text,
      );

      if (widget.post == null) {
        postService.createPost(post).then((newPost) {
          widget.onSave(newPost);
          Navigator.of(context).pop();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create post: $error')),
          );
        });
      } else {
        postService.updatePost(post).then((updatedPost) {
          widget.onSave(updatedPost);
          Navigator.of(context).pop();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update post: $error')),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Create Post' : 'Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePost,
                child: Text(widget.post == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
