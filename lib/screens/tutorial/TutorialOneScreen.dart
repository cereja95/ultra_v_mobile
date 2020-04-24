import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultravmobile/extra/Prefs.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VideoPlayerScreen();
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.asset("assets/video.mp4");
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });

    // _controller = VideoPlayerController.network(
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    // );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    _controller.play();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  Widget createCicleFilter2(onTap, size, iconData, color) {
    return new InkResponse(
      onTap: onTap,
      child: new Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          child: iconData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/background_black.png"),
                      fit: BoxFit.cover)),
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the VideoPlayerController has finished initialization, use
                    // the data it provides to limit the aspect ratio of the video.
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      // Use the VideoPlayer widget to display the video.
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
          Row(children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 25, left: 16.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                        onTap: () {
                          Prefs().setPrefString("tutorial", "1");
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Text(
                              "Pular Introdução",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ))))),
            Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, right: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    margin: EdgeInsets.only(bottom: 25, left: 10),
                    child: createCicleFilter2(
                        () => {
                              setState(() {
                                // If the video is playing, pause it.
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  // If the video is paused, play it.
                                  _controller.play();
                                }
                              })
                            },
                        52.0,
                        Icon(
                          !_controller.value.isPlaying
                              ? Icons.play_arrow
                              : Icons.pause,
                          color: Colors.white,
                          size: 26,
                        ),
                        Colors.white)),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
