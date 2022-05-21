import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mukto_dhara/custom_classes/toast.dart';
import 'package:mukto_dhara/model/book.dart';
import 'package:mukto_dhara/model/book_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:mukto_dhara/model/selected_book_model.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';

class ApiProvider extends ChangeNotifier{

  static const String baseURL='https://sohelmahroof.com.bd/api/';

  BookListModel? _bookListModel;
  Book? _book;
  SelectedBook? _selectedBook;
  bool connected=true;

  get bookListModel => _bookListModel;
  get book => _book;
  get selectedBook => _selectedBook;

  void setSelectedBook(SelectedBook selectedBook) {
    _selectedBook = selectedBook;
    notifyListeners();
  }

  
  Future <void> getBookList(ThemeProvider themeProvider) async {
    try{
      var response = await http.get(Uri.parse(baseURL+'poem.php'));
      if(response.statusCode == 200){
        _bookListModel = bookListModelFromJson(response.body);
        notifyListeners();
      }
    }on SocketException{
      showToast('No internet connection!', themeProvider);
    }
    catch(error){
      // ignore: avoid_print
      print('getting book list error: $error');
    }
  }

  Future <void> getBookPoems(String bookId, ThemeProvider themeProvider) async {
    String baseUrl = baseURL+'poem_list.php?book=$bookId';
    print(baseUrl);
    try{
      var response = await http.get(Uri.parse(baseUrl));
      if(response.statusCode == 200){
        print(response.body);
        _book = bookFromJson(response.body);
        notifyListeners();
      }
    }on SocketException{
      showToast('No internet connection!', themeProvider);
    }catch(error){
      // ignore: avoid_print
      print('getting book poems error: $error');
    }
  }

  Future<void> checkConnectivity()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      connected=true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      connected=true;
    }else{
      connected=false;
    }
    notifyListeners();
  }

  Future<String?> getPageSettingResponse(dynamic pageValue)async{
    String url;
    if(pageValue==3){
      url= baseURL+'privacy.php';
    }else if(pageValue==4){
      url= baseURL+'terms.php';
    }else{
      url= baseURL+'copyright.php';
    }
    try{
      var response = await http.get(Uri.parse(url));
      if(response.statusCode==200){
        var jsonData = jsonDecode(response.body);
        return jsonData['result'][0]['page_description'];
      }
    }catch(error){
      if(kDebugMode){
        print(error.toString());
      }
    }
  }


}