import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:mukto_dhara/model/poet.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigatorBar extends StatefulWidget {
  List<Poet> poetList;

  CustomBottomNavigatorBar({required this.poetList});

  @override
  _CustomBottomNavigatorBarState createState() =>
      _CustomBottomNavigatorBarState();
}

class _CustomBottomNavigatorBarState extends State<CustomBottomNavigatorBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return InfiniteCarousel.builder(
      itemCount: widget.poetList.length,
      itemExtent: 120,
      center: true,
      anchor: 0.0,
      velocityFactor: 0.2,
      axisDirection: Axis.horizontal,
      loop: true,
      itemBuilder: (context, itemIndex, realIndex) {
        return Padding(
          padding:  EdgeInsets.only(top: size.width*.03),
          child: Column(
            children: [
              SizedBox(
                  width: size.width * .08,
                  height: size.width * .08,
                  child: Image.asset(widget.poetList[itemIndex].image)),
              SizedBox(height: size.width*.01,),
              Text(
                widget.poetList[itemIndex].name,
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: size.width*.03
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
