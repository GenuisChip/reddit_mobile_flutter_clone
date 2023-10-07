import 'dart:convert';

import 'package:equatable/equatable.dart';

PostEntity postEntityFromJson(String str) =>
    PostEntity.fromJson(json.decode(str));

String postEntityToJson(PostEntity data) => json.encode(data.toJson());

class PostEntity extends Equatable {
  @override
  List<Object?> get props => [
        id,
        voteUpCount,
        voteDownCount,
        description,
        author,
        comments,
        identityHashCode(this)
      ];

  const PostEntity({
    required this.id,
    required this.voteUpCount,
    required this.voteDownCount,
    required this.description,
    required this.author,
    required this.comments,
    required this.videoUrl,
    required this.title,
    required this.yourVote,
  });

  final num id;
  final num voteUpCount;
  final num voteDownCount;
  final String description;
  final String videoUrl;
  final Author author;
  final Comments comments;
  final int yourVote;

  final String title;

  factory PostEntity.fromJson(Map<String, dynamic> json) => PostEntity(
        id: json["id"],
        voteUpCount: json["voteUpCount"],
        voteDownCount: json["voteDownCount"],
        description: json["description"],
        videoUrl: json["videoUrl"],
        title: json["title"],
        yourVote: json["yourVote"],
        author: Author.fromJson(json["author"]),
        comments: Comments.fromJson(json["comments"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voteUpCount": voteUpCount,
        "voteDownCount": voteDownCount,
        "description": description,
        "videoUrl": videoUrl,
        "title": title,
        "yourVote": yourVote,
        "author": author.toJson(),
        "comments": comments.toJson(),
      };

  PostEntity copyWith({
    num? id,
    num? voteUpCount,
    num? voteDownCount,
    String? description,
    String? videoUrl,
    Author? author,
    Comments? comments,
    int? yourVote,
    String? title,
  }) {
    return PostEntity(
      id: id ?? this.id,
      voteUpCount: voteUpCount ?? this.voteUpCount,
      voteDownCount: voteDownCount ?? this.voteDownCount,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      author: author ?? this.author,
      comments: comments ?? this.comments,
      yourVote: yourVote ?? this.yourVote,
      title: title ?? this.title,
    );
  }
}

class Author {
  Author({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  final num id;
  final String name;
  final String iconUrl;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        iconUrl: json["iconUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iconUrl": iconUrl,
      };
}

class Comments {
  Comments({
    required this.allCommentsCount,
    required this.data,
  });

  final num allCommentsCount;
  final List<CommentData> data;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        allCommentsCount: json["allCommentsCount"],
        data: List<CommentData>.from(
            json["data"].map((x) => CommentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "allCommentsCount": allCommentsCount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CommentData {
  CommentData({
    required this.comment,
    required this.voteUpCount,
    required this.voteDownCount,
    required this.user,
    required this.id,
  });

  final String comment;
  final num voteUpCount;
  final num voteDownCount;
  final Author user;
  final int id;

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        comment: json["comment"],
        voteUpCount: json["voteUpCount"],
        id: json["id"],
        voteDownCount: json["voteDownCount"],
        user: Author.fromJson(
          json["user"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "voteUpCount": voteUpCount,
        "voteDownCount": voteDownCount,
        "id": id,
        "user": user.toJson(),
      };
}
