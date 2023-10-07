import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit/layers/domain/entities/post_entity.dart';
import 'package:video_player/video_player.dart';
import '../../cubit/post_cubit/post_cubit.dart';
import 'widgets/video_controller_widget.dart';
import 'widgets/vote_button_widget.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late final PostCubit postCubit;

  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>()..getPostById(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: BlocBuilder<PostCubit, PostState>(
          builder: ((context, state) {
            if (state is PostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PostFetched ||
                state is PostVotedUp ||
                state is PostVotedDown ||
                state is PostRemoveVote) {
              late final PostEntity post;
              if (state is PostFetched) {
                post = state.post.data!;
              } else if (state is PostVotedUp) {
                post = state.post;
              } else if (state is PostVotedDown) {
                post = state.post;
              } else if (state is PostRemoveVote) {
                post = state.post;
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_back),
                        Text("r/${post.title}"),
                        const Icon(Icons.more_horiz_rounded),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FutureBuilder(
                    future: postCubit.controller.initialize(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        postCubit.controller.play();
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayer(postCubit.controller),
                        );
                      }
                      return AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    child: Icon(
                                      Icons.person,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(post.author.name)
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(post.description)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              VoteButtonWidget(
                                onTap: () => postCubit.voteUp(post),
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: post.yourVote == 1
                                      ? Colors.amber
                                      : Colors.white,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  (post.voteUpCount - post.voteDownCount)
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: post.yourVote == 1
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              VoteButtonWidget(
                                onTap: () => postCubit.voteDown(post),
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: post.yourVote == -1
                                      ? Colors.blue
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Icon(Icons.comment_outlined),
                              Text(post.comments.allCommentsCount.toString()),
                              const SizedBox(height: 30),
                              const Icon(Icons.share_sharp),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: VideoControllerWidget(
                      controller: postCubit.controller,
                    ),
                  )
                ],
              );
            } else {
              return const Text("Can't load data");
            }
          }),
        ),
      ),
    );
  }
}
