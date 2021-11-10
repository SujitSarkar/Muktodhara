import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mukto_dhara/custom_widgets/appbar_menu.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/home_screen.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  int _count = 0;

  Future _customInit(ApiProvider apiProvider) async {
    _count++;
    if (apiProvider.bookListModel == null) await apiProvider.getBookList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context);
    final Size size = MediaQuery.of(context).size;
    themeProvider.changeStatusBarTheme();
    if (_count == 0) _customInit(apiProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.screenBackgroundColor(),
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: _customAppBar(size, themeProvider),
        ),
        body: _bodyUI(size, apiProvider, themeProvider),
      ),
    );
  }

  /// body
  Widget _bodyUI(
          Size size, ApiProvider apiProvider, ThemeProvider themeProvider) =>
      Padding(
          padding: EdgeInsets.all(size.width * .05),
          child: apiProvider.bookListModel != null
              ? apiProvider.bookListModel.result.isNotEmpty
                  ? StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount: apiProvider.bookListModel.result.length,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(categoryId: apiProvider
                                      .bookListModel.result[index].categoryId,)));
                        },
                        child: Column(
                          children: [
                            /// book image
                            CachedNetworkImage(
                              imageUrl: apiProvider
                                  .bookListModel.result[index].catImage,
                              placeholder: (context, url) => Padding(
                                padding:  EdgeInsets.all(size.width*.04),
                                child: Icon(Icons.image, color: Colors.grey.shade400,size: size.width*.2,),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: size.width * .02),

                            /// book name
                            Text(
                              apiProvider
                                  .bookListModel.result[index].categoryName,
                              style: TextStyle(
                                  color: themeProvider.bookNameColor(),
                                  fontSize: size.width * .04,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      staggeredTileBuilder: (int index) =>
                          const StaggeredTile.fit(1),
                      mainAxisSpacing: size.width * .03,
                      crossAxisSpacing: size.width * .05,
                    )
                  : const Center(child: Text('কোন বই নেই!'))
              : const Center(child: Text('কোন বই নেই!')));

  /// custom app bar
  Container _customAppBar(Size size, ThemeProvider themeProvider) => Container(
        height: AppBar().preferredSize.height,
        color: themeProvider.appBarColor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text('সোহেল মাহরুফের কবিতা সমগ্র',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeProvider.appBarTitleColor(),
                      fontSize: size.width * .05,
                      fontWeight: FontWeight.w500)),
            ),
            AppBarMenu(iconColor: themeProvider.appBarIconColor())
          ],
        ),
      );
}
