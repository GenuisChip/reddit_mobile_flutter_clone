import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit/layers/domain/entities/post_entity.dart';

part 'post_comments_state.dart';

class PostCommentsCubit extends Cubit<PostCommentsState> {
  PostCommentsCubit() : super(PostCommentsInitial());

  void showSheet(PostEntity post) {
    emit(PostShowCommentsSheet(post: post, isShown: true));
  }

  void hideSheet(PostEntity post) {
    emit(PostShowCommentsSheet(post: post, isShown: false));
  }
}
