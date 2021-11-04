import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ReadPoem extends StatelessWidget {
  static const String poem = 'তুমি মোরে পার না বুঝিতে?\nপ্রশান্ত বিষাদতরে\nদুটি আঁখি প্রশ্ন ক\'রে\nঅর্থ মোর চাহিছে খুঁজিতে,\n'
      'চন্দ্রমা যেমন ভাবে স্থিরনত্মুখে\nচেয়ে দেখে সমুদ্রের বুকে।\n\nতুমি মোরে পার না বুঝিতে?\nপ্রশান্ত বিষাদতরে\nদুটি আঁখি প্রশ্ন ক\'রে\nঅর্থ মোর চাহিছে খুঁজিতে,\n'
      'চন্দ্রমা যেমন ভাবে স্থিরনত্মুখে\nচেয়ে দেখে সমুদ্রের বুকে।\n\nতুমি মোরে পার না বুঝিতে?\nপ্রশান্ত বিষাদতরে\nদুটি আঁখি প্রশ্ন ক\'রে\nঅর্থ মোর চাহিছে খুঁজিতে,\n'
      'চন্দ্রমা যেমন ভাবে স্থিরনত্মুখে\nচেয়ে দেখে সমুদ্রের বুকে।\n\nতুমি মোরে পার না বুঝিতে?\nপ্রশান্ত বিষাদতরে\nদুটি আঁখি প্রশ্ন ক\'রে\nঅর্থ মোর চাহিছে খুঁজিতে,\n'
      'চন্দ্রমা যেমন ভাবে স্থিরনত্মুখে\nচেয়ে দেখে সমুদ্রের বুকে।\n\nতুমি মোরে পার না বুঝিতে?\nপ্রশান্ত বিষাদতরে\nদুটি আঁখি প্রশ্ন ক\'রে\nঅর্থ মোর চাহিছে খুঁজিতে,\n'
      'চন্দ্রমা যেমন ভাবে স্থিরনত্মুখে\nচেয়ে দেখে সমুদ্রের বুকে।\n\nতুমি মোরে পার না বুঝিতে?\nপ্রশান্ত বিষাদতরে\nদুটি আঁখি প্রশ্ন ক\'রে\nঅর্থ মোর চাহিছে খুঁজিতে,\n'
      'চন্দ্রমা যেমন ভাবে স্থিরনত্মুখে\nচেয়ে দেখে সমুদ্রের বুকে।';

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
      body: _bodyUI(size, themeProvider),
    );
  }


  Widget _bodyUI(Size size, ThemeProvider themeProvider) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width*.05, vertical: size.width*.03),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// poem name
            Text(
              'দুর্বোধ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeProvider.poemNameColor(),
                fontSize: size.width*.07,
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: size.width*.015,),

            /// poet name
            Text(
              'রবীন্দ্রণাথ ঠাকুর',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeProvider.poemNameColor(),
                  fontSize: size.width*.05,
                  fontWeight: FontWeight.w500
              ),
            ),

            SizedBox(height: size.width*.04,),

            /// full poem
            Text(
              poem,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: themeProvider.poemNameColor(),
                  fontSize: size.width*.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
