part of 'post_cubit.dart';

enum VoteType { up, down, removed }

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {}

class PostInitial extends PostState {}

class PostVotedUp extends PostState {
  final PostEntity post;
  const PostVotedUp({
    required this.post,
  });
}
class PostVotedDown extends PostState {
  final PostEntity post;
  const PostVotedDown({
    required this.post,
  });
}

class PostRemoveVote extends PostState {
  final PostEntity post;
  const PostRemoveVote({
    required this.post,
  });
}




class PostFetched extends PostState {
  final ApiManagerResponse<PostEntity> post;

  final bool isPlaying;
  const PostFetched({
    required this.post,
    required this.isPlaying,
  });
}
