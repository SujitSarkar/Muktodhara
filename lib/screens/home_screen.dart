import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/custom_widgets/custom_bottom_navigation_bar.dart';
import 'package:mukto_dhara/custom_widgets/poem_card.dart';
import 'package:mukto_dhara/model/poet.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/change_theme.dart';
import 'package:mukto_dhara/screens/favourite_screen.dart';
import 'package:mukto_dhara/screens/help_screen.dart';
import 'package:mukto_dhara/screens/refine_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _showSearchBar = false;

  /// bottom navigation poet list
  final List<Poet> _poetList = [
    Poet(name: 'নজরুল ইসলাম', image: 'assets/poet_demo_img.png'),
    Poet(name: 'রবি ঠাকুর', image: 'assets/poet_demo_img.png'),
    Poet(name: 'জসীমউদ্দীন', image: 'assets/poet_demo_img.png'),
    Poet(name: 'শামসুর রাহমান', image: 'assets/poet_demo_img.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery
        .of(context)
        .size;
    themeProvider.changeStatusBarTheme();

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.screenBackgroundColor(),
        appBar: _showSearchBar
            ? PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: _customSearchBar(themeProvider),
        )
            : AppBar(
          backgroundColor: themeProvider.appBarColor(),
          elevation: 0.0,
          actions: [
            _customAppBarItem(themeProvider, LineAwesomeIcons.search,
                _onAppBarIconPress(LineAwesomeIcons.search)),
            _customAppBarItem(themeProvider, LineAwesomeIcons.alternate_feather,
                _onAppBarIconPress(LineAwesomeIcons.alternate_feather)),
            _customAppBarItem(themeProvider, LineAwesomeIcons.bookmark,
                _onAppBarIconPress(LineAwesomeIcons.bookmark)),
            _appBarMenu(themeProvider),
          ],
        ),
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              color: Colors.green.shade100,
              height: size.width *.2,
              child: CustomBottomNavigatorBar(poetList: _poetList,),
            ),
            Positioned(
              top: -size.width*.05,
              left: size.width*.04,
              child: Container(
                width: size.width*.2,
                height: size.width *.22,
                color: Colors.green.shade700,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: size.width * .08,
                        height: size.width * .08,
                        child: Image.asset('assets/poet_demo_img.png')),
                    SizedBox(height: size.width*.01,),
                    Text(
                      'নজরুল ইসলাম',
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                          color: Colors.white,
                          fontSize: size.width*.035
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body: _bodyUI(size),
      ),
    );
  }

  /// body
  Widget _bodyUI(Size size) {
    return ListView.builder(
        itemCount: 15,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return PoemCard(poemName: 'শীতের আদর্শলিপি',
            poetName: 'স্বপ্নীল চক্রবর্তী',
            poemFirstLine: 'পাতাঝরা বিকেলের কোলাজ শুনে যে পাখিরা',
            iconData: LineAwesomeIcons.bookmark,
            );
        });
  }

  /// appbar pop up menu
  Widget _appBarMenu(ThemeProvider themeProvider) {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: themeProvider.appBarIconColor(),
        ),
        color: themeProvider.appBarMenuColor(),
        onSelected: (value) {
          if (value == 0) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HelpScreen()));
          }
          if (value == 1) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RefineScreen()));
          }
          if (value == 2) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChangeThemePage()));
          }
        },
        itemBuilder: (context) =>
        [
          _customAppBarMenuItem(themeProvider, 'সহায়িকা', 0),
          _customAppBarMenuItem(themeProvider, 'সমৃদ্ধ ও সংশোধনা', 1),
          _customAppBarMenuItem(themeProvider, 'থিম পরিবর্তন করুন', 2),
          _customAppBarMenuItem(themeProvider, 'গোপনীয়তা নীতি', 3),
        ]);
  }

  /// custom appbar pop up menu item
  PopupMenuItem _customAppBarMenuItem(ThemeProvider themeProvider, String title,
      int value) {
    return PopupMenuItem(
      value: value,
      child: Text(
        title,
        style: TextStyle(
          color: themeProvider.appBarMenuItemColor(),
        ),
      ),
    );
  }

  /// appbar icons
  Widget _customAppBarItem(ThemeProvider themeProvider, IconData iconData,
      Function() appBarIconPress) {
    return IconButton(
      icon: Icon(iconData),
      color: themeProvider.appBarIconColor(),
      onPressed: appBarIconPress,
    );
  }

  /// custom search bar
  Widget _customSearchBar(ThemeProvider themeProvider) {
    return TextFormField(
      autofocus: true,
      cursorColor: themeProvider.appBarTitleColor(),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: 'খোঁজ করুন',
        hintStyle: TextStyle(
            color: themeProvider.searchBarHintColor()
        ),
        prefixIcon: Icon(
          Icons.search,
          color: themeProvider.appBarIconColor(),
        ),
        suffixIcon: InkWell(
            onTap: () => setState(() => _showSearchBar = !_showSearchBar),
            child: Icon(Icons.close, color: themeProvider.appBarIconColor())),
      ),
    );
  }

  /// functions
  Function() _onAppBarIconPress(IconData iconData) =>
          () {
        if (iconData == LineAwesomeIcons.bookmark) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FavouriteScreen()));
        }
        if (iconData == LineAwesomeIcons.search) {
          setState(() => _showSearchBar = !_showSearchBar);
        }
      };
}
