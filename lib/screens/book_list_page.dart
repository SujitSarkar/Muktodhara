import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mukto_dhara/custom_widgets/appbar_menu.dart';
import 'package:mukto_dhara/model/selected_book_model.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/sqlite_database_helper.dart';
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
  bool _loading = false;

  Future _customInit(ApiProvider apiProvider, DatabaseHelper databaseHelper,
      ThemeProvider themeProvider) async {
    _count++;
    setState(() => _loading = true);
    if (apiProvider.bookListModel == null) await apiProvider.getBookList(themeProvider);
    setState(() => _loading = false);
    databaseHelper.getFavouritePoems();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    final Size size = MediaQuery.of(context).size;
    themeProvider.changeStatusBarTheme();
    if (_count == 0) _customInit(apiProvider, databaseHelper, themeProvider);
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
      _loading
          ? SpinKitDualRing(
              color: themeProvider.spinKitColor(),
              lineWidth: 4,
              size: 40,
            )
          : Padding(
              padding: EdgeInsets.all(size.width * .05),
              child: apiProvider.bookListModel != null
                  ? apiProvider.bookListModel.result.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: size.width * .01,
                                  crossAxisSpacing: size.width * .02,
                                childAspectRatio: 0.42
                              ),
                          itemCount: apiProvider.bookListModel.result.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              apiProvider.setSelectedBook(SelectedBook(
                                  bookImage: apiProvider
                                      .bookListModel.result[index].catImage,
                                  bookName: apiProvider.bookListModel
                                      .result[index].categoryName));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                            categoryId: apiProvider
                                                .bookListModel
                                                .result[index]
                                                .categoryId,
                                          )));
                            },
                            child: Column(
                              children: [
                                /// book image
                                CachedNetworkImage(
                                  imageUrl: apiProvider
                                      .bookListModel.result[index].catImage,
                                  placeholder: (context, url) => Padding(
                                    padding: EdgeInsets.all(size.width * .04),
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey.shade400,
                                      size: size.width * .2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: size.width * .02),

                                /// book name
                                Text(
                                  apiProvider.bookListModel.result[index]
                                      .categoryName,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: themeProvider.bookNameColor(),
                                      fontSize: size.width * .04,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                          'কোন বই নেই!',
                          style: TextStyle(
                              color: themeProvider.appBarTitleColor()),
                        ))
                  : Center(
                      child: Text('কোন বই নেই!',
                          style: TextStyle(
                              color: themeProvider.appBarTitleColor()))));

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
