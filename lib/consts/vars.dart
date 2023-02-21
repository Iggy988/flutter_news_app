import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum NewsType {
  topTrending,
  allNews,
}

enum SortByEnum {
  relevance, // articles more closely related to q come first
  popularity, // articles from popular source and publishers come first
  publishedAt, // newest articles come first
}

TextStyle smallTextStyle = GoogleFonts.montserrat(fontSize: 15);
TextStyle titleTextStyle =
    GoogleFonts.oswald(fontSize: 28, fontWeight: FontWeight.bold);

const List<String> searchKeywords = [
  'Football',
  'Flutter',
  'Python',
  'Weather',
  'Crypto',
  'Bitcoin',
  'Youtube',
  'Netflix',
  'Meta',
];
