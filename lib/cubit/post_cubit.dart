import 'dart:ffi';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/post.dart';
import '../resource/remote_resource.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  void fetchPost() async {
    emit(PostLoading());
    try {
      final result = await RemoteResource().fetchPost();
      result.fold(
            (error) => emit(PostError(message: error)),
            (posts) => emit(PostLoaded(posts: posts)),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  void createPost({
    required String title,
    required String author,
    required int year,
    required String publisher,
    required File cover,
  }) async {
    emit(PostLoading());
    try {
      final result = await RemoteResource().createPost(cover, title, author, year, publisher);
      result.fold(
            (error) => emit(PostError(message: error)),
            (response) => emit(PostCreated(message: response)),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  void updatePost({
    required int id,
    required String title,
    required String author,
    required int year,
    required String publisher,
    required File? cover,
  }) async {
    emit(PostLoading());
    try {
      final result = await RemoteResource().updatePost(
        id,
        title,
        author,
        year,
        publisher,
        cover,
      );
      result.fold(
            (error) => emit(PostError(message: error)),
            (response) => emit(PostUpdated(message: response)),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  void deletePost(int id) async {
    emit(PostLoading());
    try {
      final result = await RemoteResource().deletePost(id);
      result.fold(
            (error) => emit(PostError(message: error)),
            (response) => emit(PostDeleted(message: response)),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
}
