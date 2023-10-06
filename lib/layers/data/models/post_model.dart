import '../../domain/entities/post_entity.dart';

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post extends PostEntity {
  @override
  List<Object?> get props => [
        id,
        voteUpCount,
        voteDownCount,
        description,
        author,
        comments,
      ];

  const Post({
    required super.id,
    required super.voteUpCount,
    required super.voteDownCount,
    required super.description,
    required super.author,
    required super.comments,
    required super.videoUrl,
    required super.title,
    required super.youVoted,
  });

  static List<Post> fromJsonList(json) {
    return List.from(json.map((e) => Post.fromJson(e)));
  }

  static Post fromEntity(PostEntity data) {
    return Post(
      id: data.id,
      voteUpCount: data.voteUpCount,
      voteDownCount: data.voteDownCount,
      description: data.description,
      author: data.author,
      youVoted: data.youVoted,
      comments: data.comments,
      videoUrl: data.videoUrl,
      title: data.title,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        voteUpCount: json["voteUpCount"],
        voteDownCount: json["voteDownCount"],
        description: json["description"],
        videoUrl: json["videoUrl"],
        youVoted: json["youVoted"],
        title: json["title"],
        author: Author.fromJson(json["author"]),
        comments: Comments.fromJson(json["comments"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "voteUpCount": voteUpCount,
        "voteDownCount": voteDownCount,
        "description": description,
        "videoUrl": videoUrl,
        "title": title,
        "youVoted": youVoted,
        "author": author.toJson(),
        "comments": comments.toJson(),
      };
}
