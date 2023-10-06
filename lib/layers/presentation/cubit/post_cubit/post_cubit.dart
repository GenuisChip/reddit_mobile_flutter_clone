import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit/commons/handlers/debounce.dart';
import 'package:reddit/commons/network/api_manager/api_manager.dart';
import 'package:reddit/layers/domain/usecases/posts_use_case.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/entities/post_entity.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostsUseCase postsUseCase;
  final searchDebouncer = Debouncer(delay: const Duration(milliseconds: 700));

  late final VideoPlayerController controller;
  PostCubit({required this.postsUseCase}) : super(PostInitial());

  Future<void> getPostById(int id) async {
    emit(PostLoading());
    final res = await postsUseCase.getOne('$id');

    controller =
        VideoPlayerController.networkUrl(Uri.parse(res.data!.videoUrl));

    emit(PostFetched(post: res, isPlaying: true));
  }
}
