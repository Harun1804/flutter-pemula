import 'dart:convert';

class Post {
  final int? id;
  final String? title;
  final String? author;
  final int? year;
  final String? publisher;
  final String? coverUrl;

  Post({
    this.id,
    this.title,
    this.author,
    this.year,
    this.publisher,
    this.coverUrl,
  });

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    title: json["title"],
    author: json["author"],
    year: json["year"],
    publisher: json["publisher"],
    coverUrl: json["coverUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "year": year,
    "publisher": publisher,
    "coverUrl": coverUrl,
  };
}