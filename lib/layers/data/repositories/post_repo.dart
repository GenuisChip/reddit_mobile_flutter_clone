import '../../../commons/network/api_manager/api_manager_response.dart';
import '../../../commons/network/network_info/network_info.dart';
import '../../domain/entities/query_params.dart';
import '../models/post_model.dart';
import '../data_source/in_memory_cache.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repo_interface.dart';
import '../data_source_interfaces/posts_data_source_interface.dart';

class PostsRepo implements IPostsRepo {
  final IPostsLocalDataSource localDataSource;
  final InMemoryCache inMemoryCache;
  final INetworkInfo networkInfo;
  final IPostsNetworkDataSource networkDataSource;
  PostsRepo({
    required this.networkDataSource,
    required this.localDataSource,
    required this.inMemoryCache,
    required this.networkInfo,
  });

  @override
  Future<ApiManagerResponse<List<Post>>> search(String text,
      {QueryParams? params}) {
    return networkDataSource.search(text, params: params);
  }

  @override
  Future<ApiManagerResponse<List<Post>>> getAll(
      {QueryParams? params}) async {
    if (inMemoryCache.isNotEmpty && inMemoryCache.hasNotExpired) {
      var data = inMemoryCache.getCachedValue();
      return ApiManagerResponse(
        data: data,
        error: null,
        isSuccess: true,
        rawData: null,
        serverErrorMsg: null,
        statusCode: 200,
      );
    }
    if (await networkInfo.isConnected) {
      var res = await networkDataSource.getAll(params: params);
      if (res.isSuccess && res.data?.isNotEmpty == true) {
        inMemoryCache.save(res.data);
        localDataSource.cachePostsList(res.data!);
      }
      return res;
    } else {
      return ApiManagerResponse(
        data: await localDataSource.getAll(),
        error: null,
        isSuccess: true,
        rawData: null,
        serverErrorMsg: null,
        statusCode: 200,
      );
    }
  }

  @override
  Future<ApiManagerResponse<Post>> getOne(String id) async {
    if (await networkInfo.isConnected) {
      var res = await networkDataSource.getOne(id);
      return res;
    } else {
      return ApiManagerResponse(
        data: await localDataSource.getOne(id),
        error: null,
        isSuccess: true,
        rawData: null,
        serverErrorMsg: null,
        statusCode: 200,
      );
    }
  }

  @override
  Future<ApiManagerResponse<Post>> create(PostEntity data) {
    return networkDataSource.create(Post.fromEntity(data));
  }

  @override
  Future<ApiManagerResponse> delete(String id) {
    return networkDataSource.delete(id);
  }

  @override
  Future<ApiManagerResponse<Post>> update(String id, PostEntity data) {
    return networkDataSource.update(id, Post.fromEntity(data));
  }
}
