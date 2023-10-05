
import '../../../commons/network/api_manager/api_manager.dart';
import '../entities/query_params.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repo_interface.dart';

class PostsUseCase {
  final IPostsRepo repo;
  PostsUseCase({
    required this.repo,
  });

  Future<ApiManagerResponse<List<PostEntity>>> getAll({QueryParams? params}) {
    return repo.getAll(params: params);
  }

  Future<ApiManagerResponse<List<PostEntity>>> search(String text,
    {QueryParams? params}) {
  return repo.search(text, params: params);
}

  Future<ApiManagerResponse<PostEntity>> getOne(String id) {
    return repo.getOne(id);
  }

  Future<ApiManagerResponse<PostEntity>> create(PostEntity data) {
    return repo.create(data);
  }

  Future<ApiManagerResponse> delete(String id) {
    return repo.delete(id);
  }

  Future<ApiManagerResponse<PostEntity>> update(String id, PostEntity data) {
    return repo.update(id, data);
  }
}    
  