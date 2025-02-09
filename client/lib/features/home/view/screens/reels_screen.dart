import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/reel/viewmodel/reel_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reels"),
        ),
        body: ref.watch(getReelsProvider).when(
              data: (reels) {
                return ListView.builder(
                    itemCount: reels.length,
                    itemBuilder: (context, index) {
                      final reel = reels[index];
                      return ListTile(
                        title: Column(
                          children: [
                            ReelItem(
                                videoUrl: reel.videoUrl,
                                caption: reel.caption,
                                createdOn: reel.createdOn),
                          ],
                        ),
                      );
                    });
              },
              error: (error, st) {
                return Center(
                  child: Text(
                    error.toString(),
                  ),
                );
              },
              loading: () => const Loader(),
            ));
  }
}

class ReelItem extends StatefulWidget {
  final String videoUrl;
  final String caption;
  final DateTime createdOn;

  const ReelItem(
      {super.key,
      required this.videoUrl,
      required this.caption,
      required this.createdOn});

  @override
  _ReelItemState createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update UI after initialization
      })
      ..setLooping(true)
      ..play(); // Auto-play the video
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _controller.value.isInitialized
              ? Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
          Text(widget.caption),
          Text(widget.createdOn.toString()),
        ],
      ),
    );
  }
}
