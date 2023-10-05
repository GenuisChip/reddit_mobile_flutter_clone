// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data_source_interfaces/posts_data_source_interface.dart';
import '../../models/post_model.dart';

const CACHED_PRODUCTS_LIST = "CACHED_PRODUCTS_LIST";

class PostsLocalDataSource implements IPostsLocalDataSource {
  final SharedPreferences preferences;
  PostsLocalDataSource({
    required this.preferences,
  });

  @override
  Future<List<Post>> cachePostsList(List<Post> list) {
    final jsonList = list.map((c) => json.encode(c.toJson())).toList();
    preferences.setStringList(CACHED_PRODUCTS_LIST, jsonList);
    return Future.value(list);
  }

  @override
  Future<List<Post>> getAll() {
    final jsonList = preferences.getStringList(CACHED_PRODUCTS_LIST);
    if (jsonList != null) {
      return Future.value(
          jsonList.map((j) => Post.fromJson(json.decode(j))).toList());
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<Post?> getOne(String id) async {
    final list = await getAll();
    Post? post;

    for (var item in list) {
      if (int.parse(id) == item.id) {
        post = item;
        break;
      }
    }
    return post;
  }
}

