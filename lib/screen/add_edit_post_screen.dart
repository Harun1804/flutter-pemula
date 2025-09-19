import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/post_cubit.dart';
import '../model/post.dart';

class AddEditPostScreen extends StatefulWidget {
  final Post? post;
  const AddEditPostScreen({super.key, this.post});

  @override
  State<AddEditPostScreen> createState() => _AddEditPostScreenState();
}

class _AddEditPostScreenState extends State<AddEditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _yearController = TextEditingController();
  final _publisherController = TextEditingController();
  final _titleFocus = FocusNode();
  final _authorFocus = FocusNode();
  final _yearFocus = FocusNode();
  final _publisherFocus = FocusNode();
  File? _cover;
  final picker = ImagePicker();

  late PostCubit postCubit;

  Future getImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _cover = File(pickedFile.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No Image Selected')),
          );
        }
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      });
    }
  }

  @override
  void initState() {
    postCubit = PostCubit();
    if (widget.post != null) {
      _titleController.text = widget.post?.title ?? "";
      _authorController.text = widget.post?.author ?? "";
      _yearController.text = widget.post?.year.toString() ?? "";
      _publisherController.text = widget.post?.publisher ?? "";
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _publisherController.dispose();
    _titleFocus.dispose();
    _authorFocus.dispose();
    _yearFocus.dispose();
    _publisherFocus.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.post != null) {
      postCubit.updatePost(
        id: widget.post?.id ?? 0,
        title: _titleController.text,
        author: _authorController.text,
        year: int.parse(_yearController.text),
        publisher: _publisherController.text,
        cover: _cover,
      );
    } else if (_cover != null) {
      postCubit.createPost(
        title: _titleController.text,
        author: _authorController.text,
        year: int.parse(_yearController.text),
        publisher: _publisherController.text,
        cover: _cover!,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Insert Image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post == null ? 'Add New Post' : 'Edit Post',
        ),
      ),
      body: BlocListener<PostCubit, PostState>(
        bloc: postCubit,
        listener: (context, state) {
          if (state is PostCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }

          if (state is PostUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }

          if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: _cover == null
                        ? const Text('No Image Selected')
                        : Image.file(
                      _cover!,
                      height: 200,
                      width: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextButton(
                    onPressed: getImage,
                    child: const Text('Selected Image'),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _titleController,
                    focusNode: _titleFocus,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Insert Title';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: _authorController,
                    focusNode: _authorFocus,
                    decoration: const InputDecoration(
                      labelText: 'Author',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Insert Author';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    controller: _yearController,
                    focusNode: _yearFocus,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Insert Year';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: _publisherController,
                    focusNode: _publisherFocus,
                    decoration: const InputDecoration(
                      labelText: 'Publisher',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Insert Publisher';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submitData,
                      child: Text(widget.post == null ? 'Submit' : 'Update'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
