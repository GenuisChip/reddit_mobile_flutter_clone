part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {}

class PostInitial extends PostState {}

class PostFetched extends PostState {
  final ApiManagerResponse<PostEntity> post;

  final bool isPlaying;
  const PostFetched({
    required this.post,
    required this.isPlaying,
  });
}

