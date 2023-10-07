import 'package:reddit/layers/domain/entities/post_entity.dart';

import '../../../../commons/network/api_manager/api_manager_response.dart';
import '../../../domain/entities/query_params.dart';
import '../../api_service/api_service.dart';
import '../../data_source_interfaces/posts_data_source_interface.dart';
import '../../models/post_model.dart';

class PostsNetworkDataSource extends APIService<Post, Post, Post, Post, dynamic>
    implements IPostsNetworkDataSource {
  PostsNetworkDataSource() : super(endpoint: "posts");

  @override
  Future<ApiManagerResponse<List<Post>>> search(String text,
      {QueryParams? params}) {
    return getAll(endpoint: "posts/search?q=$text");
  }

  @override
  Future<ApiManagerResponse<Post>> getOne(String id) {
    return Future.value(ApiManagerResponse(
      serverErrorMsg: null,
      statusCode: 200,
      isSuccess: true,
      rawData: null,
      error: null,
      data: Post(
        id: 1,
        title: "MechanicalKeyboards",
        description:
            '''The Flutter replicated view should simulate the reddit view with great attention to the visual details.
 The application should be well-structured and follow best practices in Flutter development''',
        videoUrl:
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        voteDownCount: 3,
        voteUpCount: 10,
        yourVote:0,
        author: Author(
          id: 1,
          name: "Ali",
          iconUrl: "url",
        ),
        comments: Comments(
          allCommentsCount: 10,
          data: [
            CommentData(
              id: 1,
              comment: "comment comment",
              user: Author(
                id: 1,
                name: "Ali",
                iconUrl: "url",
              ),
              voteDownCount: 2,
              voteUpCount: 5,
            ),
          ],
        ),
      ),
    ));
  }

  @override
  List<Post> fromJsonList(json) {
    return Post.fromJsonList(json["posts"]);
  }

  @override
  T fromCreate<T>(json) {
    throw UnimplementedError();
  }

  @override
  T fromDelete<T>(json) {
    throw UnimplementedError();
  }

  @override
  Post fromJson(json) {
    throw UnimplementedError();
  }

  @override
  T fromUpdate<T>(json) {
    throw UnimplementedError();
  }
}
