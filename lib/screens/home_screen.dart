import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/custom_classes/scroll_to_hide_widget.dart';
import 'package:mukto_dhara/custom_widgets/appbar_menu.dart';
import 'package:mukto_dhara/custom_widgets/custom_bottom_navigation_bar.dart';
import 'package:mukto_dhara/custom_widgets/poem_card.dart';
import 'package:mukto_dhara/model/poet.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/favourite_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  String categoryId;
  Home({Key? key, required this.categoryId}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _showSearchBar = false;
  bool _forwarded = false;
  late ScrollController _scrollController;
  double _appBarHeight = 0;
  int _count = 0;
  bool _loading = false;

  /// bottom navigation poet list
  final List<Poet> _poetList = [
    Poet(name: 'নজরুল ইসলাম', image: 'assets/poet_demo_img.png'),
    Poet(name: 'রবি ঠাকুর', image: 'assets/poet_demo_img.png'),
    Poet(name: 'জসীমউদ্দীন', image: 'assets/poet_demo_img.png'),
    Poet(name: 'শামসুর রাহমান', image: 'assets/poet_demo_img.png'),
  ];

  Future _customInit(ApiProvider apiProvider) async {
    _count++;
    setState(() => _loading = true);
    await apiProvider.getBookPoems(widget.categoryId).then((value) => setState(() => _loading = false));
  }

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
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context);
    final Size size = MediaQuery.of(context).size;
    themeProvider.changeStatusBarTheme();
    if(_count == 0) _customInit(apiProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.screenBackgroundColor(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.width * .6),
          child: _showSearchBar
              ? _customSearchBar(themeProvider, size)
              : _customAppBar(size, themeProvider),
        ),
        body: _bodyUI(size, themeProvider, apiProvider),
        bottomNavigationBar: ScrollToHide(
            scrollController: _scrollController,
            child: _customBottomNavigation(size)),
      ),
    );
  }

  /// body
  Widget _bodyUI(Size size, ThemeProvider themeProvider, ApiProvider apiProvider) {
    return NotificationListener(
      onNotification: (scrollNotification) {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_forwarded == true) {
            setState(() => _forwarded = false);
          }
        } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_forwarded == false) {
            setState(() {
              _forwarded = true;
            });
          }
        }
        return true;
      },
      child: _loading
          ? SpinKitDualRing(color: themeProvider.spinKitColor(), lineWidth: 4, size: 40,)
       : apiProvider.book != null? ListView.builder(
          controller: _scrollController,
          itemCount: apiProvider.book.result.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: PoemCard(
                poemId: apiProvider.book.result[index].postId,
                poemName: apiProvider.book.result[index].poemName,
                poemFirstLine: apiProvider.book.result[index].firstLine ?? '',
                iconData: LineAwesomeIcons.bookmark,
              ),
            );
          }) :  const Center(child: Text('কোন কবিতা নেই')),
    );
  }

  /// custom app bar
  Widget _customAppBar(Size size, ThemeProvider themeProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: _forwarded ? AppBar().preferredSize.height : 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _customAppBarItem(themeProvider, LineAwesomeIcons.search,
              _onAppBarIconPress(LineAwesomeIcons.search, size)),
          _customAppBarItem(themeProvider, LineAwesomeIcons.bookmark,
              _onAppBarIconPress(LineAwesomeIcons.bookmark, size)),
          // _appBarMenu(themeProvider),
          AppBarMenu(iconColor: _forwarded ? themeProvider.appBarIconColor() : Colors.transparent)
        ],
      ),
    );
  }

  /// custom appbar icons
  Widget _customAppBarItem(ThemeProvider themeProvider, IconData iconData,
      Function() appBarIconPress) {
    return IconButton(
      icon: Icon(iconData),
      color: _forwarded ? themeProvider.appBarIconColor() : Colors.transparent,
      onPressed: appBarIconPress,
    );
  }

  /// custom bottom navigation
  Widget _customBottomNavigation(Size size) {
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
      duration:  const Duration(milliseconds: 150),
      height: _forwarded ? AppBar().preferredSize.height : 0,
      child: TextFormField(
        autofocus: true,
        cursorColor: themeProvider.appBarTitleColor(),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'খোঁজ করুন',
          hintStyle: TextStyle(
              color: themeProvider.searchBarHintColor(),
              fontSize: size.width * .04),
          prefixIcon: Icon(Icons.search,
              color: _forwarded
                  ? themeProvider.appBarIconColor()
                  : Colors.transparent),
          suffixIcon: InkWell(
              onTap: () => setState(() => _showSearchBar = !_showSearchBar),
              child: Icon(Icons.close,
                  color: _forwarded
                      ? themeProvider.appBarIconColor()
                      : Colors.transparent)),
        ),
      ),
    );
  }


  /// functions
  Function() _onAppBarIconPress(IconData iconData, Size size) => () {
        if (iconData == LineAwesomeIcons.bookmark) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FavouriteScreen()));
        }
        if (iconData == LineAwesomeIcons.search) {
          setState(() => _showSearchBar = !_showSearchBar);
        }
      };
}
