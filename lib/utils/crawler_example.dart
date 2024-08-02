import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart';

import '../models/chapter.dart';
import '../models/movie.dart';

class CrawlerExample {

  Map<String, List<String>> express;

  CrawlerExample(this.express);
  
  _parseSearchRes(String resHtml, Uri searchUri){
    Document document = html.parse(resHtml);
    // 查询列表
    List<Element> movieList = document.querySelectorAll(express['searchList']![0]);
    // print(movieList.length);

    List<Movie> listMovie = [];
    for(int i=0; i<movieList.length; i++){
      String? title = movieList[i].querySelector(express['searchTitle']![0])?.attributes[express['searchTitle']![1]];
      String? href = movieList[i].querySelector(express['searchHref']![0])?.attributes[express['searchHref']![1]];
      String? image = movieList[i].querySelector(express['searchImage']![0])?.attributes[express['searchImage']![1]];

      href = searchUri.resolve(href!).toString();
      image = searchUri.resolve(image!).toString();

      print("$title $href $image");
      Movie movie = Movie(title!, image, href);
      listMovie.add(movie);
    }
    return listMovie;
  }

  
  _getHtml(Uri searchUri) async {

    Response response = await http.get(searchUri, headers: {
      "User-Agent":
      "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"
    });
    int resCode = response.statusCode;
    if(resCode != 200){
      // Error
      return "";
    }
    String resHtml = response.body;
    // print(resCode);
    // print(resHtml);
    return resHtml;

  }


  search(String siteUrl, String searchPath, String searchKey, String searchWorld) async {
    Uri searchUri = Uri.https(Uri.parse(siteUrl).host, searchPath, {searchKey: searchWorld});
    String resHtml = await _getHtml(searchUri);
    List<Movie> movieList = _parseSearchRes(resHtml, searchUri);
    return movieList;
  }

  _parseVideoChapter(String resHtml, Uri detailUrl){
    Document document = html.parse(resHtml);
    // 查询列表
    List<Element> chapterList = document.querySelectorAll(express["chapterList"]![0]);
    // print(chapterList.length);

    List<Chapter> chapterVideoList = [];
    for(int i=0; i<chapterList.length; i++){
      String? title = chapterList[i].querySelector(express['chapterTitle']![0])?.text;
      String? href = chapterList[i].querySelector(express['chapterHref']![0])?.attributes[express['chapterHref']![1]];

      if(title == "APP秒播"){
        continue;
      }
      href = detailUrl.resolve(href!).toString();
      // print("$title $href");
      chapterVideoList.add(Chapter(title!, href));
    }
    return chapterVideoList;
  }

  getVideoChapter(String detailUrl) async {
    Uri detailUri = Uri.parse(detailUrl);
    String resHtml = await _getHtml(detailUri);
    List<Chapter>  chapterList = _parseVideoChapter(resHtml, detailUri);
    return chapterList;
  }
}

Future<void> main() async {
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
  
  CrawlerExample crawlerExample = CrawlerExample(express);
  List<Movie> movieSearchList = await crawlerExample.search(siteUrl, searchPath, searchKey, searchWorld);
  // print(movieList.toString());
  String detailUrl = movieSearchList[0].href;
  List chapterList = await crawlerExample.getVideoChapter(detailUrl);
  print(chapterList[0]);
}
