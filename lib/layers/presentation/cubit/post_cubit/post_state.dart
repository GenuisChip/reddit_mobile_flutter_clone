part of 'post_cubit.dart';

enum VoteType { up, down, removed }

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {}

class PostInitial extends PostState {}

class PostVoted extends PostState {
  final PostEntity post;
  final VoteType voteType;
  const PostVoted({
    required this.post,
    required this.voteType,
  });
  @override
  List<Object> get props => [voteType];
}

class PostFetched extends PostState {
  final ApiManagerResponse<PostEntity> post;

  final bool isPlaying;
  const PostFetched({
    required this.post,
    required this.isPlaying,
  });
}
