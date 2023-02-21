import 'package:flutter/material.dart';

class BookmarksModel with ChangeNotifier {
  // kreiramo bookmarkKey koji koristimo kao id za brisanje unosa iz database
  String bookmarkKey,
      newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      dateToShow,
      content,
      readingTimeText;

  BookmarksModel(
      {required this.bookmarkKey,
      required this.newsId,
      required this.sourceName,
      required this.authorName,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.dateToShow,
      required this.content,
      required this.readingTimeText});

  factory BookmarksModel.fromJson(
      {required dynamic json, required bookmarkKey}) {
    return BookmarksModel(
        bookmarkKey: bookmarkKey,
        // keys moraju odgovarati keys u firebase database
        newsId: json['newsId'] ?? '',
        sourceName: json['sourceName'] ?? '',
        authorName: json['authorName'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        url: json['url'] ?? '',
        urlToImage: json['urlToImage'] ??
            'https://cdn-icons-png.flaticon.com/512/833/833268.png',
        publishedAt: json['publishedAt'] ?? '',
        dateToShow: json['dateToShow'] ?? '',
        content: json['content'] ?? '',
        readingTimeText: json['readingTimeText'] ?? '');
  }

  // za bookmark
  // za pristup json preko key
  // imao list all keys i da bi pristupili contentu liste moramo
  // zvati fromJson da konvertujemo u BookmarkModel
  static List<BookmarksModel> bookmarksFromSnapshot(
      {required dynamic json, required List allKeys}) {
    return allKeys.map((key) =>
        // json ce biti map i mozemo mu pristupiti preko key
        BookmarksModel.fromJson(json: json[key], bookmarkKey: key)).toList();
  }

  @override
  String toString() {
    return 'news {newsId: $newsId, sourceName: $sourceName, authorName: $authorName, title: $title, description: $description, url: $url, urlToImage: $urlToImage, publishedAt: $publishedAt, content: $content,}';
  }
}
