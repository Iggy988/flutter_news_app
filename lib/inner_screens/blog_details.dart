import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_rest_api/consts/vars.dart';
import 'package:news_app_rest_api/models/bookmarks_model.dart';
import 'package:news_app_rest_api/providers/bookmarks_provider.dart';
import 'package:news_app_rest_api/providers/news_provider.dart';
import 'package:news_app_rest_api/services/utils.dart';
import 'package:news_app_rest_api/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/global_methods.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const routName = '/NewsDetailsScreen';

  const NewsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  // varijabla za provjeru da li je unos u database
  bool isInBookmark = false;

  String? publishedAt;

  dynamic currentBookmark;
  @override
  void didChangeDependencies() {
    /**
        ModalRoutes cover the entire Navigator. They are not necessarily opaque,
        however; for example, a pop-up menu uses a ModalRoute but only shows
        the menu in a small box overlapping the previous route.
        The T type argument is the return value of the route.
        If there is no return value, consider using void as the return value.
     */
    publishedAt = ModalRoute.of(context)!.settings.arguments as String;

    // ako lista contains publishAt znaci da imamo news u bookmarku
    final List<BookmarksModel> bookmarkList =
        Provider.of<BookmarksProvider>(context).getBookmarkList;
    if (bookmarkList.isEmpty) {
      return;
    }
    currentBookmark = bookmarkList
        .where((element) => element.publishedAt == publishedAt)
        .toList();
    if (currentBookmark.isEmpty) {
      isInBookmark = false;
    } else {
      isInBookmark = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);

    final currentNews = newsProvider.findByDate(publishedAt: publishedAt);
    final color = Utils(context).getColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'By ${currentNews.authorName}',
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        ),
        leading: IconButton(
          icon: Icon(IconlyLight.arrowLeft, color: color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentNews.title,
                  textAlign: TextAlign.justify,
                  style: titleTextStyle,
                ),
                const VerticalSpacing(25),
                Row(
                  children: [
                    Text(currentNews.dateToShow, style: smallTextStyle),
                    const Spacer(),
                    Text(
                      currentNews.readingTimeText,
                      style: smallTextStyle,
                    ),
                    const VerticalSpacing(25),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              // wrapujemo sa sizedBox da mozemo rasiriti sliku preko cijelog screena
              SizedBox(
                width: double.infinity,
                child: Padding(
                  // stavljamo padding na image da bi icons bile na pola donje crte od slike
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Hero(
                    tag: currentNews.publishedAt,
                    child: FancyShimmerImage(
                        boxFit: BoxFit.fill,
                        errorWidget:
                            Image.asset('assets/images/empty_image.png'),
                        imageUrl: currentNews.urlToImage),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (isInBookmark) {
                            await bookmarksProvider.deleteBookmark(
                                key: currentBookmark[0].bookmarkKey);
                          } else {
                            await bookmarksProvider.addToBookmark(
                                newsModel: currentNews);
                          }
                          await bookmarksProvider.fetchBookmarks();
                        },
                        child: Card(
                          elevation: 10,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              isInBookmark
                                  ? IconlyBold.bookmark
                                  : IconlyLight.bookmark,
                              size: 28,
                              color: isInBookmark ? Colors.green : color,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            await Share.share(currentNews.url,
                                subject: 'Look what I made!');
                          } catch (err) {
                            GlobalMethods.errorDialog(
                                errorMessage: err.toString(), context: context);
                          }
                        },
                        child: Card(
                          elevation: 10,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              IconlyLight.send,
                              size: 28,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const VerticalSpacing(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextContent(
                  label: 'Description',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const VerticalSpacing(10),
                TextContent(
                  label: currentNews.description,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                const VerticalSpacing(20),
                const TextContent(
                  label: 'Content',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const VerticalSpacing(10),
                TextContent(
                  label: currentNews.content,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextContent extends StatelessWidget {
  const TextContent(
      {Key? key,
      required this.label,
      required this.fontSize,
      required this.fontWeight})
      : super(key: key);
  final String label;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: TextAlign.justify,
      style: GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
