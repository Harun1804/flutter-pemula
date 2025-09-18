import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pemula/cubit/post_cubit.dart';
import 'package:flutter_pemula/model/post.dart';
import 'package:flutter_pemula/screen/add_edit_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];

  @override
  void initState() {
    loadPost();
    super.initState();
  }

  void loadPost() {
    context.read<PostCubit>().fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Golang"),
      ),
      body: BlocConsumer<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PostLoaded) {
              posts = state.posts;
              if (posts.isEmpty) {
                return const Center(child: Text('Post Empty'));
              }
              return _postList();
            }
            if (state is PostError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Something went wrong'));
          },
          listener: (context, state) {
            if (state is PostDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              loadPost();
            }
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditPostScreen(),
              ),
            );
            if (result == true) {
              loadPost();
            }
          },
          child: Icon(Icons.add),
      ),
    );
  }

  Widget _postList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '${post.coverUrl}',
                      width: 60,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Detail (wrap with Expanded)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${post.title}',
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${post.author}, ${post.year}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${post.publisher}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<PostCubit>().deletePost(post.id ?? 0);
                          setState(() {
                            posts.removeWhere(
                              (post) => post.id == posts[index].id);
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  )
                ],
              )
            ),
          );
        },
      ),
    );
  }
}