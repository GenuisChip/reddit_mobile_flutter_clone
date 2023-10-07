import 'package:flutter/material.dart';

class VoteButtonWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const VoteButtonWidget({super.key, required this.child, required this.onTap});

  @override
  State<VoteButtonWidget> createState() => _VoteButtonWidgetState();
}

class _VoteButtonWidgetState extends State<VoteButtonWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    animation = Tween<double>(begin: 1, end: 2).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: animation.value,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: () {
          controller.forward().then((value) => controller.reverse());
          widget.onTap();
        },
        child: widget.child,
      ),
    );
  }
}
