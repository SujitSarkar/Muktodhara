import 'package:flutter/material.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/read_poem_page.dart';
import 'package:provider/provider.dart';

class PoemCard extends StatelessWidget {
  String poemId;
  String poemName;
  String poemFirstLine;
  IconData iconData;

  PoemCard(
      {Key? key,
        required this.poemId,
        required this.poemName,
      required this.poemFirstLine,
      required this.iconData,
     }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReadPoem(poemId: poemId,)));
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: size.width*.03),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width*.02),
          ),
          elevation: 1,
          color: themeProvider.poemCardColor(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.width * .05, horizontal: size.width * .03),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _customPoemNameText(size, themeProvider),
                      poemFirstLine != ''? _customPoemFirstLineText(size, themeProvider) : const SizedBox(),
                    ],
                  ),
                ),
                Icon(iconData, color: themeProvider.bodyIconColor(),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// poem name text
  Widget _customPoemNameText(Size size, ThemeProvider themeProvider){
    return Text(
      poemName,
      style: TextStyle(
        color:  themeProvider.poemNameColorOnCard(),
        fontSize: size.width*.05,
        fontWeight: FontWeight.bold
      ),
    );
  }


  /// poem first line
  Widget _customPoemFirstLineText(Size size, ThemeProvider themeProvider){
    return Text(
      poemFirstLine,
      style: TextStyle(
          color:  themeProvider.poemNameColorOnCard(),
          fontSize: size.width*.04,
      ),
    );
  }
}
