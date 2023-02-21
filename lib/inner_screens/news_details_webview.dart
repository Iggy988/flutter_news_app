import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:news_app_rest_api/services/global_methods.dart';
import 'package:news_app_rest_api/services/utils.dart';
import 'package:news_app_rest_api/widgets/vertical_spacing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailsWebView extends StatefulWidget {
  const NewsDetailsWebView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<NewsDetailsWebView> createState() => _NewsDetailsWebViewState();
}

class _NewsDetailsWebViewState extends State<NewsDetailsWebView> {
  late WebViewController _webViewController;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    return WillPopScope(
      // onWillPop koristimo da kad kliknemo back vrati na
      // prethodnu stranicu unutar browsera, a ne na prethodni screen
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          // vracamo false => ostajemo unutar browsera
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(IconlyLight.arrowLeft2),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: color),
          title: Text(
            widget.url,
            style: TextStyle(color: color),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _showModalSheet();
              },
              icon: Icon(Icons.more_horiz),
            ),
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: _progress,
              color: _progress == 1 ? Colors.transparent : Colors.blue,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            Expanded(
              child: WebView(
                initialUrl: widget.url,
                zoomEnabled: true,
                onProgress: (progress) {
                  setState(() {
                    // pozivamo url preko widget zato sto je izvan state class
                    _progress = progress / 100;
                  });
                },
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                //onProgress: ,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // metoda za prikazivanje Bottom Sheeta
  Future<void> _showModalSheet() async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalSpacing(20),
              Center(
                child: Container(
                  height: 5,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const VerticalSpacing(20),
              const Text(
                'More options',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const VerticalSpacing(20),
              const Divider(
                thickness: 2,
              ),
              const VerticalSpacing(20),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () async {
                  try {
                    await Share.share(widget.url, subject: 'Look what I made!');
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        errorMessage: err.toString(), context: context);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text('Open in browser'),
                onTap: () async {
                  // moramo konvertovati url u Uri, preko metode Uri.parse()
                  if (!await launchUrl(Uri.parse(widget.url))) {
                    throw 'Could not launch ${widget.url}';
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh'),
                onTap: () async {
                  try {
                    await _webViewController.reload();
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        errorMessage: err.toString(), context: context);
                    ;
                  } finally {
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
