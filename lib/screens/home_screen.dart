import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/custom_classes/scroll_to_hide_widget.dart';
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
  bool _forwarded = false;
  late ScrollController _scrollController;

  /// bottom navigation poet list
  final List<Poet> _poetList = [
    Poet(name: 'নজরুল ইসলাম', image: 'assets/poet_demo_img.png'),
    Poet(name: 'রবি ঠাকুর', image: 'assets/poet_demo_img.png'),
    Poet(name: 'জসীমউদ্দীন', image: 'assets/poet_demo_img.png'),
    Poet(name: 'শামসুর রাহমান', image: 'assets/poet_demo_img.png'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: _showSearchBar? _customSearchBar(themeProvider, size) : _customAppBar(themeProvider),
        ),
        body: _bodyUI(size),
        bottomNavigationBar: ScrollToHide(
            scrollController: _scrollController,
            child: _customBottomNavigation(size)),
    ),);
  }

  /// body
  Widget _bodyUI(Size size) {
    return NotificationListener(
      onNotification: (scrollNotification) {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if(_forwarded==true) {
            setState(()=>_forwarded=false);
          }
        } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if(_forwarded==false) {
            setState(()=>_forwarded=true);
          }
        }return true;
      },
      child: ListView.builder(
           controller: _scrollController,
          itemCount: 15,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return PoemCard(
              poemName: 'শীতের আদর্শলিপি',
              poetName: 'স্বপ্নীল চক্রবর্তী',
              poemFirstLine: 'পাতাঝরা বিকেলের কোলাজ শুনে যে পাখিরা',
              iconData: LineAwesomeIcons.bookmark,
            );
          }),
    );
  }

  /// appbar pop up menu
  Widget _appBarMenu(ThemeProvider themeProvider) {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: _forwarded? themeProvider.appBarIconColor() : Colors.transparent ,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangeThemePage()));
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


  /// custom app bar
  Widget _customAppBar(ThemeProvider themeProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: _forwarded?  AppBar().preferredSize.height : 0,
      color: themeProvider.appBarColor(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _customAppBarItem(themeProvider, LineAwesomeIcons.search, _onAppBarIconPress(LineAwesomeIcons.search)),
          _customAppBarItem(themeProvider, LineAwesomeIcons.alternate_feather, _onAppBarIconPress(LineAwesomeIcons.alternate_feather)),
          _customAppBarItem(themeProvider, LineAwesomeIcons.bookmark, _onAppBarIconPress(LineAwesomeIcons.bookmark)),
          _appBarMenu(themeProvider),
        ],
      ),
    );
  }

  /// custom appbar icons
  Widget _customAppBarItem(ThemeProvider themeProvider, IconData iconData,
      Function() appBarIconPress) {
    return IconButton(
      icon: Icon(iconData),
      color: _forwarded? themeProvider.appBarIconColor() : Colors.transparent ,
      onPressed: appBarIconPress,
    );
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

  /// custom bottom navigation
  Widget _customBottomNavigation(Size size){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          color: Colors.amberAccent,
          height: size.width * .2,
          child: CustomBottomNavigatorBar(
            poetList: _poetList,
          ),
        ),
        Positioned(
          top: -size.width * .05,
          left: size.width * .04,
          child: Container(
            width: size.width * .2,
            height: size.width * .22,
            color: Colors.blue.shade700,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: size.width * .08,
                    height: size.width * .08,
                    child: Image.asset('assets/poet_demo_img.png')),
                SizedBox(
                  height: size.width * .01,
                ),
                Text(
                  'নজরুল ইসলাম',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontSize: size.width * .035),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  /// custom search bar
  Widget _customSearchBar(ThemeProvider themeProvider, Size size) {
    return AnimatedContainer(
      color: themeProvider.appBarColor(),
      duration: const Duration(milliseconds: 150),
      height: _forwarded?  AppBar().preferredSize.height : 0 ,
      child: TextFormField(
        autofocus: true,
        cursorColor: themeProvider.appBarTitleColor(),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'খোঁজ করুন',
          hintStyle: TextStyle(color: themeProvider.searchBarHintColor(), fontSize: size.width*.04),
          prefixIcon: Icon(Icons.search, color: _forwarded? themeProvider.appBarIconColor() : Colors.transparent),
          suffixIcon: InkWell(
              onTap: () => setState(() => _showSearchBar = !_showSearchBar),
              child: Icon(Icons.close, color:  _forwarded? themeProvider.appBarIconColor() : Colors.transparent)),
        ),
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
        if (iconData == LineAwesomeIcons.alternate_feather) {
        }
      };
}
