
import '../../../commons/network/api_manager/api_manager.dart';
import '../entities/query_params.dart';
import '../entities/post_entity.dart';

abstract class IPostsRepo {
  Future<ApiManagerResponse<List<PostEntity>>> getAll(
      {QueryParams? params});
  Future<ApiManagerResponse<List<PostEntity>>> search(
    String text, {
    QueryParams? params,
  });

  Future<ApiManagerResponse<PostEntity>> getOne(String id);

      Future<ApiManagerResponse<PostEntity>> create(PostEntity data);
      Future<ApiManagerResponse> delete(String id);
      Future<ApiManagerResponse<PostEntity>> update(String id, PostEntity data);
}
