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
                return reels.isEmpty
                    ? Center(child: Text("No Reel Found"))
                    : ListView.builder(
                        itemCount: reels.length,
                        itemBuilder: (context, index) {
                          final reel = reels[index];
                          return ListTile(
                            title: Column(
                              children: [
                                ReelItem(
                                  videoUrl: reel.videoUrl,
                                  caption: reel.caption,
                                  createdOn: reel.createdOn,
                                  reelId: reel.id,
                                ),
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

class ReelItem extends ConsumerStatefulWidget {
  final String videoUrl;
  final String caption;
  final DateTime createdOn;
  final String reelId;

  const ReelItem({
    super.key,
    required this.videoUrl,
    required this.caption,
    required this.createdOn,
    required this.reelId,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReelItemState();
}

class _ReelItemState extends ConsumerState<ReelItem> {
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
    return Stack(
      children: [
        Card(
          child: Column(
            children: [
              _controller.value.isInitialized
                  ? Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        Center(
                          heightFactor: 15,
                          child: IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                          ),
                        ),
                        Positioned(
                          right: 16,
                          bottom: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.comment),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await ref
                                      .read(reelViewModelProvider.notifier)
                                      .deletedReel(
                                        reelId: widget.reelId,
                                      );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }
}
