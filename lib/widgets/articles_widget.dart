import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app_rest_api/consts/vars.dart';
import 'package:news_app_rest_api/inner_screens/blog_details.dart';
import 'package:news_app_rest_api/inner_screens/news_details_webview.dart';
import 'package:news_app_rest_api/models/bookmarks_model.dart';
import 'package:news_app_rest_api/models/news_model.dart';
import 'package:news_app_rest_api/services/utils.dart';
import 'package:news_app_rest_api/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';

class ArticlesWidget extends StatelessWidget {
  const ArticlesWidget({Key? key, this.isBookmark = false
      // required this.imageUrl,
      // required this.title,
      // required this.url,
      // required this.dateToShow,
      // required this.readingTime
      })
      : super(key: key);

  /// koristimo provider
  // final String imageUrl, title, url, dateToShow, readingTime;

  // posto imamo 2 provider koja koristimo u jednom widgetu moramo odrediti
  // koji se trenutno koristi
  final bool isBookmark;

  @override
  Widget build(BuildContext context) {
    dynamic newsModelProvider = isBookmark
        ? Provider.of<BookmarksModel>(context)
        : Provider.of<NewsModel>(context);
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            // Navigate to the in app details screen
            Navigator.pushNamed(context, NewsDetailsScreen.routName,
                arguments: newsModelProvider.publishedAt);
          },
          child: Stack(
            children: [
              Container(
                height: 60,
                width: 60,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 60,
                  width: 60,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                color: Theme.of(context).cardColor,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        // tag mora biti unique
                        tag: newsModelProvider.publishedAt,
                        child: FancyShimmerImage(
                            height: size.height * 0.12,
                            width: size.height * 0.12,
                            boxFit: BoxFit.fill,
                            errorWidget:
                                Image.asset('assets/images/empty_image.png'),

                            /// koristimo provider
                            imageUrl: newsModelProvider.urlToImage),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            newsModelProvider.title,
                            textAlign: TextAlign.justify,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: smallTextStyle,
                          ),
                          const VerticalSpacing(5),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '⌚ ${newsModelProvider.readingTimeText}',
                              style: smallTextStyle,
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: NewsDetailsWebView(
                                            url: newsModelProvider.url,
                                          ),
                                          inheritTheme: true,
                                          ctx: context),
                                    );
                                  },
                                  icon: const Icon(Icons.link,
                                      color: Colors.blue),
                                ),
                                Text(
                                  newsModelProvider.dateToShow,
                                  maxLines: 1,
                                  style: smallTextStyle,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
