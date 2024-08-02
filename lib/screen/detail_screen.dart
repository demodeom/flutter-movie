import 'package:flutter/material.dart';
import 'package:flutter_video/screen/video_full_screen.dart';
import 'package:video_player/video_player.dart';

import '../utils/crawler.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var res = [];

  bool isOk = false;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)?.settings.arguments;
    String url = arg.toString();
    print(url);

    if (res.isEmpty) {

      Map<String, List<String>> express = {
        "searchList": [".mod-inner .m-item"],
        "searchTitle": [".thumb", "title"],
        "searchHref": [".thumb", "href"],
        "searchImage": [".thumb img", "data-original"],
        "chapterList": [".stui-pannel_bd > div:first-child div ul li"],
        "chapterTitle": ["a", "title"],
        "chapterHref": ["a", "href"],
      };

      CrawlerMovie(express).getVideoChapter(url).then((data) {
        print(res);
        setState(() {
          res = data;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      backgroundColor: const Color(0xff191825),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            isOk
                ? InkWell(
                    child: Container(
                      // width: 200,
                      height: 200,
                      child: FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            );
                          } else {

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    onTap: () {
                      print("视频被点击了");
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return VideoFullScreen(_controller);
                      }));

                    },
                  )
                : Container(),
            const SizedBox(height: 20,),
            Center(
              child: Container(
                // width: 341,
                padding: const EdgeInsets.all(10),
                // height: 157,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xff706f78), width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: Column(
                  children: [
                    Container(
                      child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(res.length, (i) {
                            return InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color(0xff2B2A37),
                                ),
                                child: Text(
                                  res[i].title,
                                  style: const TextStyle(
                                    color: Color(0xff95959B),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              onTap: () {





                                // CrawlerExample crawlerExample = CrawlerExample(express);

                                // print(res[i]["href"]);


                                Map<String, List<String>> express = {
                                  "searchList": [".mod-inner .m-item"],
                                  "searchTitle": [".thumb", "title"],
                                  "searchHref": [".thumb", "href"],
                                  "searchImage": [".thumb img", "data-original"],
                                  "chapterList": [".stui-pannel_bd > div:first-child div ul li"],
                                  "chapterTitle": ["a", "title"],
                                  "chapterHref": ["a", "href"],
                                };

                                CrawlerMovie(express).getVideoChapter(res[i].href)
                                    .then((data) {
                                  print("video Url");
                                  print(data);
                                  // data = "https://c1.rrcdnbf3.com/video/shenwutianzun/第223集/index.m3u8";
                                  setState(() {
                                    _controller =
                                        VideoPlayerController.networkUrl(
                                      Uri.parse(
                                        data,
                                      ),
                                    );

                                    // Initialize the controller and store the Future for later use.
                                    _initializeVideoPlayerFuture =
                                        _controller.initialize();

                                    // Use the controller to loop the video.
                                    _controller.setLooping(true);

                                    isOk = true;

                                    _controller.play();
                                  });
                                });
                              },
                            );
                          })),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
