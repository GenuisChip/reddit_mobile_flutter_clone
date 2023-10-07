part of 'post_comments_cubit.dart';

abstract class PostCommentsState extends Equatable {
  const PostCommentsState();

  @override
  List<Object> get props => [];
}

class PostCommentsInitial extends PostCommentsState {}

class PostShowCommentsSheet extends PostCommentsState {
  final bool isShown;
  final PostEntity post;
  const PostShowCommentsSheet({
    required this.isShown,
    required this.post,
  });
  @override
  List<Object> get props => [isShown, post];
}
