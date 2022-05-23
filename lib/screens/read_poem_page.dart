import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/provider/ad_controller.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock/wakelock.dart';

class ReadPoem extends StatefulWidget {
  final String poem;
  final String poemName;
  final String poetName;
  const ReadPoem({Key? key, required this.poem, required this.poemName,required this.poetName}) : super(key: key);

  @override
  State<ReadPoem> createState() => _ReadPoemState();
}

class _ReadPoemState extends State<ReadPoem> {
  final AdController adController = AdController();

  @override
  void initState() {
    super.initState();
    ///Initialize Ad
    final ApiProvider ap = Provider.of<ApiProvider>(context,listen: false);
    if(ap.connected){
      adController.loadInterstitialAd();
      adController.loadBannerAdd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    final ApiProvider ap = Provider.of<ApiProvider>(context,listen: false);
    if(ap.connected) adController.showInterstitialAd();
  }


  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context);
    final Size size = MediaQuery.of(context).size;

    themeProvider.changeStatusBarTheme();
    return Scaffold(
      backgroundColor: themeProvider.screenBackgroundColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.appBarColor(),
        elevation: 0.0,
        leading: IconButton(
            onPressed: (){
              Wakelock.disable();
              Navigator.pop(context);
            },
            icon: Icon(
              LineAwesomeIcons.times,
              color: themeProvider.appBarTitleColor(),
            )),
        actions: [
          IconButton(
              onPressed: () {
                 Share.share('https://play.google.com/store/apps/details?id=com.glamworlditltd.muktodhara');
              },
              icon: Icon(
                Icons.share_outlined,
                color: themeProvider.appBarTitleColor(),
              )),
        ],
      ),
      body: _bodyUI(size, themeProvider, apiProvider),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: AdWidget(ad: adController.bannerAd!),
        width: MediaQuery.of(context).size.width,
        height: adController.bannerAd!.size.height.toDouble(),
      ),
    );
  }

  Widget _bodyUI(
      Size size, ThemeProvider themeProvider, ApiProvider apiProvider) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .05, vertical: size.width * .03),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// poem name
            Text(
              widget.poemName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeProvider.poemNameColor(),
                  fontSize: size.width * .07,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.width*.02),

            /// poet name
            Text(
              widget.poetName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeProvider.poemNameColor(),
                  fontSize: size.width * .05),
            ),
            SizedBox(height: size.width*.04),

            /// full poem
            Html(
              data: """<p>${widget.poem}</p>""",
              style: {
                "p": Style(
                  color: themeProvider.poemNameColor(),
                  margin: EdgeInsets.zero,
                )
              },
            )
          ],
        ),
      ),
    );
  }
}
