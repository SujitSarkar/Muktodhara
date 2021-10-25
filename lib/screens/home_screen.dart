import 'package:flutter/material.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/favourite_screen.dart';
import 'package:mukto_dhara/variables/color_variables.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: themeProvider.screenBackgroundColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.appBarColor(),
        elevation: 0.0,
        actions: [

          _customAppBarIcon(Icons.bookmark, _onAppBarIconPress(Icons.bookmark)),
          _appBarMenu(themeProvider),
        ],
      ),
      body: _bodyUI(size),
    );
  }

  /// body
  Widget _bodyUI(Size size) {
    return const Center(
      child: Text('Home'),
    );
  }

  /// appbar pop up menu
  Widget _appBarMenu(ThemeProvider themeProvider) {
    return PopupMenuButton(
        icon: const Icon(
          Icons.more_vert,
          color: CColor.darkThemeColor,
        ),
        color: themeProvider.appBarMenuColor(),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: _customAppBarMenuItem(themeProvider, 'সহায়িকা'),
                value: 0,
              ),
              PopupMenuItem(
                child: _customAppBarMenuItem(themeProvider, 'সমৃদ্ধ ও সংশোধন'),
                value: 0,
              ),
              PopupMenuItem(
                child: _customAppBarMenuItem(themeProvider, 'Change Theme'),
                value: 0,
              ),
              PopupMenuItem(
                child: _customAppBarMenuItem(themeProvider, 'Privacy Policy'),
                value: 0,
              ),
            ]);
  }

  /// custom appbar pop up menu item
  Widget _customAppBarMenuItem(ThemeProvider themeProvider, String title) {
    return Text(
      title,
      style: TextStyle(
        color: themeProvider.appBarMenuItemColor(),
      ),
    );
  }

  /// appbar icons
  Widget _customAppBarIcon(IconData iconData, Function() appBarIconPress) {
    return IconButton(
      icon: Icon(iconData),
      color: CColor.darkThemeColor,
      onPressed: appBarIconPress,
    );
  }

  /// functions
  Function() _onAppBarIconPress(IconData iconData) => () {
        if(iconData == Icons.bookmark){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FavouriteScreen()));
        }
      };
}
