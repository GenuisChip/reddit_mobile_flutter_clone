import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit/layers/domain/entities/post_entity.dart';
import 'package:reddit/layers/presentation/cubit/post_cubit/post_comments_cubit.dart';
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
  late final PostCommentsCubit postCommentsCubit;

  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>()..getPostById(1);
    postCommentsCubit = context.read<PostCommentsCubit>();
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
            } else if (state is PostFetched || state is PostVoted) {
              late final PostEntity post;
              if (state is PostFetched) {
                post = state.post.data!;
              } else if (state is PostVoted) {
                post = state.post;
              }

              return GestureDetector(
                onVerticalDragEnd: (details) {
                  showSheet(post);
                },
                child: Column(
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
                    BlocBuilder<PostCommentsCubit, PostCommentsState>(
                      builder: (context, state) {
                        if (state is PostShowCommentsSheet) {
                          if (state.isShown) {
                            return TweenAnimationBuilder(
                              duration: const Duration(milliseconds: 150),
                              tween: Tween(
                                end: 40.0,
                                begin: MediaQuery.of(context).size.height * .5,
                              ),
                              builder: (context, val, child) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  height: val,
                                );
                              },
                            );
                          } else {}
                          return const Spacer();
                        }
                        return const Spacer();
                      },
                    ),
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
                    BlocBuilder<PostCommentsCubit, PostCommentsState>(
                      builder: (context, state) {
                        if (state is PostShowCommentsSheet) {
                          if (state.isShown) {
                            return Column(
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onVerticalDragEnd: (d) {
                                      postCommentsCubit.hideSheet(post);
                                    },
                                    child: const Icon(
                                      Icons.minimize,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 150),
                                    tween: Tween(
                                      begin: 40.0,
                                      end: MediaQuery.of(context).size.height *
                                          .5,
                                    ),
                                    builder: (context, val, child) {
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        height: val,
                                        child: ListView.separated(
                                          itemCount: post.comments.data.length,
                                          separatorBuilder: (context, index) =>
                                              const Divider(
                                            color: Colors.white38,
                                          ),
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  leading: const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    child: Icon(Icons.person),
                                                  ),
                                                  title: Text(
                                                    "${post.comments.data[index].user.name} . now",
                                                    style: const TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15.0,
                                                    vertical: 5,
                                                  ),
                                                  child: Text(
                                                    post.comments.data[index]
                                                        .comment,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    }),
                              ],
                            );
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
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
                                                ? Colors.orange
                                                : Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            (post.voteUpCount -
                                                    post.voteDownCount)
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: post.yourVote == 1
                                                  ? Colors.orange
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
                                        GestureDetector(
                                          onTap: () => showSheet(post),
                                          child: const Icon(
                                              Icons.comment_outlined),
                                        ),
                                        Text(post.comments.allCommentsCount
                                            .toString()),
                                        const SizedBox(height: 30),
                                        const Icon(Icons.share_sharp),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: VideoControllerWidget(
                                  controller: postCubit.controller,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Text("Can't load data");
            }
          }),
        ),
      ),
    );
  }

  void showSheet(PostEntity post) async {
    postCommentsCubit.showSheet(post);

    // postCommentsCubit.hideSheet(post);
  }
}
