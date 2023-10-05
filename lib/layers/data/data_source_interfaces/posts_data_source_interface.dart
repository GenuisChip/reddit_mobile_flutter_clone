
import '../../../commons/network/api_manager/api_manager_response.dart';
import '../../domain/entities/query_params.dart';
import '../models/post_model.dart';

abstract class IPostsNetworkDataSource {
  Future<ApiManagerResponse<List<Post>>> getAll({QueryParams? params});

  Future<ApiManagerResponse<List<Post>>> search(String text,
      {QueryParams? params});
  Future<ApiManagerResponse<Post>> update(String id, Post data);
  Future<ApiManagerResponse<Post>> create(Post data);
  Future<ApiManagerResponse<Post>> getOne(String id);
  Future<ApiManagerResponse> delete(String id);
}

abstract class IPostsLocalDataSource {
  Future<List<Post>> getAll();
  Future<Post?> getOne(String id);
  Future<List<Post>> cachePostsList(List<Post> list);
}
