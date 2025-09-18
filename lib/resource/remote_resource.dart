import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../model/post.dart';
import '../model/post_action_response.dart';

class RemoteResource {
  final baseUrl = 'http://192.168.88.39:4000';

  Future<Either<String, List<Post>>> fetchPost() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/books'));
      if (response.statusCode != 200) {
        return Left('Failed to fetch post');
      }
      final post = PostActionResponse.fromJson(json.decode(response.body) as Map<String, dynamic>);
      return Right(post.data ?? []);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> createPost(
      File? cover,
      String title,
      String author,
      int year,
      String publisher
      ) async {
    try {
      final request =
      http.MultipartRequest('POST', Uri.parse('$baseUrl/api/books'));
      request.fields['title'] = title;
      request.fields['author'] = author;
      request.fields['year'] = year.toString();
      request.fields['publisher'] = publisher;
      if (cover != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'cover',
            cover.path,
          ),
        );
      }
      final req = await request.send();
      final response = await http.Response.fromStream(req);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final message = json.decode(response.body)['message'];
        return Right(message);
      } else {
        throw Left('Failed to create post');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updatePost(
      int id,
      String title,
      String author,
      int year,
      String publisher,
      File? cover,
      ) async {
    try {
      final request =
      http.MultipartRequest('PUT', Uri.parse('$baseUrl/api/books/$id'));
      request.fields['title'] = title;
      request.fields['author'] = author;
      request.fields['year'] = year.toString();
      request.fields['publisher'] = publisher;
      if (cover != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'cover',
            cover.path,
          ),
        );
      }
      final req = await request.send();
      final response = await http.Response.fromStream(req);
      final message = json.decode(response.body)['message'];
      if (response.statusCode == 200) {
        return Right(message);
      } else if (response.statusCode == 422) {
        return Right(message);
      } else {
        throw Left('Failed to update post');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/api/books/$id'));
      if (response.statusCode != 200) {
        return Left('Failed to delete post');
      }
      final result = PostActionResponse.fromJson(json.decode(response.body) as Map<String, dynamic>);
      return Right(result.message ?? '');
    } catch (e) {
      return Left(e.toString());
    }
  }
}