import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreen extends StatefulWidget {

  final VideoPlayerController controller;

  VideoFullScreen(this.controller);


  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {

  bool isLand = false;

  @override
  void initState() {
    super.initState();

    DeviceOrientation.landscapeLeft;
    DeviceOrientation.landscapeRight;
  }


  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Center(
                child: Hero(
                  tag: "player",
                  child: AspectRatio(
                    aspectRatio: widget.controller.value.aspectRatio,
                    child: VideoPlayer(widget.controller),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25, right: 20),
                child: IconButton(
                  icon: const BackButtonIcon(),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
}
