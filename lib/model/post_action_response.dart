import 'dart:convert';

import 'package:flutter_pemula/model/post.dart';

class PostActionResponse {
  final bool? status;
  final String? message;
  final List<Post>? data;

  PostActionResponse({
    this.status,
    this.message,
    this.data,
  });

  factory PostActionResponse.fromRawJson(String str) => PostActionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostActionResponse.fromJson(Map<String, dynamic> json) => PostActionResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Post>.from(json["data"]!.map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
