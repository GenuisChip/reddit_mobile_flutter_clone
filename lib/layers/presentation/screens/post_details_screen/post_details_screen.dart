import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: Column(
        children: [
          BlocBuilder<PostCubit, PostState>(
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
                    const Text("video"),
                    Row(
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
                              Text(post.description)
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Icon(Icons.arrow_upward),
                            Text(
                              (post.voteUpCount - post.voteDownCount)
                                  .toString(),
                            ),
                            const Icon(Icons.arrow_downward),
                            const SizedBox(height: 30),
                            const Icon(Icons.comment_outlined),
                            const SizedBox(height: 30),
                            const Icon(Icons.share_sharp),
                          ],
                        )
                      ],
                    ),
                  ],
                );
              } else {
                return const Text("Can't load data");
              }
            }),
          ),
        ],
      ),
    );
  }
}
