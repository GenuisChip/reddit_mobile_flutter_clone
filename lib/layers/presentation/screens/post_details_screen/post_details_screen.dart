import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../cubit/post_cubit/post_cubit.dart';

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
            } else if (state is PostFetched) {
              final post = state.post.data!;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back),
                      Text("r/${post.title}"),
                      const Icon(Icons.more_horiz_rounded),
                    ],
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
                              const Icon(Icons.arrow_upward),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  (post.voteUpCount - post.voteDownCount)
                                      .toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_downward),
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
                    child: VideoController(
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

class VideoController extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoController({super.key, required this.controller});

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  bool isPlaying = true;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (isPlaying == widget.controller.value.isPlaying) return;
      if (mounted) {
        setState(() {
          isPlaying = widget.controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (isPlaying) {
              widget.controller.pause();
            } else {
              widget.controller.play();
            }
          },
          child: isPlaying
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
        ),
        Container(
          height: 3,
          width: MediaQuery.of(context).size.width * .8,
          color: Colors.white,
        ),
        GestureDetector(
          child: const Icon(Icons.volume_off),
        )
      ],
    );
  }
}
