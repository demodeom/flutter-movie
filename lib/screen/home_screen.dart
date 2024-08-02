import 'package:flutter/material.dart';

import '../utils/crawler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("首页")),
      backgroundColor: const Color(0xff191825),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _searchWidget(),
            // _movieListWidget()
            Padding(
              padding: EdgeInsets.all(10),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: searchData.isNotEmpty ? List.generate(searchData.length, (i){
                  return _movieWidget(searchData[i]);
                }):[Center(child: Text("未查询到数据", style: TextStyle(color: Colors.white),),)],
              ),
            )
          ],
        ),
      ),
    );
  }

  _searchWidget() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xff474651),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        onSubmitted: (keyWord) async {
          print(keyWord);

          Map<String, List<String>> express = {
            "searchList": [".mod-inner .m-item"],
            "searchTitle": [".thumb", "title"],
            "searchHref": [".thumb", "href"],
            "searchImage": [".thumb img", "data-original"],
            "chapterList": [".stui-pannel_bd > div:first-child div ul li"],
            "chapterTitle": ["a", "title"],
            "chapterHref": ["a", "href"],
          };

          String siteUrl = "https://v.ijujitv.cc/";
          String searchPath = "/search/-------------.html";
          String searchKey = "wd";

          String searchWorld = "唐朝诡事录之西行";
          // String searchWorld = keyWord;

          // CrawlerExample crawlerExample = CrawlerExample(express);
          // List<Movie> movieSearchList = await crawlerExample.search(siteUrl, searchPath, searchKey, searchWorld);
          // print(movieList.toString());
          // String detailUrl = movieSearchList[0].href;
          // List chapterList = await crawlerExample.getVideoChapter(detailUrl);
          // print(chapterList[0]);


          var searchDataTmp = await CrawlerMovie(express).search(siteUrl, searchPath, searchKey, searchWorld);

          setState(() {
            searchData = searchDataTmp;
          });
        },
      ),
    );
  }

  _movieWidget(movie){
    return  InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(

          children: [
            Container(
              width: 150,
              child: Image.network(
                movie.image,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 5,),
            Container(
              width: 150,
              child: Text(

                movie.title,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xffffffff),

                ),
              ),
            ),
            SizedBox(height: 5,),
          ],

        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: Color(0xff6e6c75),
                width: 3
            ),
            borderRadius: BorderRadius.circular(5)
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, "/detail", arguments: movie.href);
      },
    );
  }



}
