import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ReadPoem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;

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
    );
  }
}
