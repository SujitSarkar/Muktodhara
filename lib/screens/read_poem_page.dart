import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ReadPoem extends StatefulWidget {
  String poemId;
  ReadPoem({Key? key, required this.poemId}) : super(key: key);

  @override
  State<ReadPoem> createState() => _ReadPoemState();
}

class _ReadPoemState extends State<ReadPoem> {
  int _count = 0;
  bool _loading = false;

  Future _customInit(ApiProvider apiProvider) async {
    _count++;
    setState(() => _loading = true);
    await apiProvider.getSinglePoem(widget.poemId).then((value) => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context);
    final Size size = MediaQuery.of(context).size;
    if (_count == 0) _customInit(apiProvider);

    themeProvider.changeStatusBarTheme();
    return Scaffold(
      backgroundColor: themeProvider.screenBackgroundColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.appBarColor(),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              LineAwesomeIcons.times,
              color: themeProvider.appBarTitleColor(),
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share_outlined,
                color: themeProvider.appBarTitleColor(),
              )),
        ],
      ),
      body: _bodyUI(size, themeProvider, apiProvider),
    );
  }

  Widget _bodyUI(
      Size size, ThemeProvider themeProvider, ApiProvider apiProvider) {
    return _loading
        ? SpinKitDualRing(color: themeProvider.spinKitColor(), lineWidth: 4, size: 40,) : Container(
      width: size.width,
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .05, vertical: size.width * .03),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// poem name
            Text(
              apiProvider.poem.result.poemName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeProvider.poemNameColor(),
                  fontSize: size.width * .07,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.width*.04,),

            /// full poem
            Html(
              data: apiProvider.poem.result.poem,
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
