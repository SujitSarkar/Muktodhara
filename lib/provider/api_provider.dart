import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mukto_dhara/custom_classes/toast.dart';
import 'package:mukto_dhara/model/book.dart';
import 'package:mukto_dhara/model/book_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:mukto_dhara/model/selected_book_model.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';

class ApiProvider extends ChangeNotifier{
  BookListModel? _bookListModel;
  Book? _book;
  SelectedBook? _selectedBook;

  get bookListModel => _bookListModel;
  get book => _book;
  get selectedBook => _selectedBook;

  void setSelectedBook(SelectedBook selectedBook) {
    _selectedBook = selectedBook;
    notifyListeners();
  }

  
  Future <void> getBookList(ThemeProvider themeProvider) async {
    try{
      var response = await http.get(Uri.parse('http://sohelmahroof.com.bd/api/poem.php'));
      if(response.statusCode == 200){
        _bookListModel = bookListModelFromJson(response.body);
        // ignore: avoid_print
        print('book list length: ${bookListModel!.result!.length}');
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
    String baseUrl = 'https://sohelmahroof.com.bd/api/poem_list.php?book=$bookId';
    try{
      var response = await http.get(Uri.parse(baseUrl));
      if(response.statusCode == 200){
        _book = bookFromJson(response.body);
        // ignore: avoid_print
        print('poem list length: ${book!.result!.length}');
        notifyListeners();
      }
    }on SocketException{
      showToast('No internet connection!', themeProvider);
    }catch(error){
      // ignore: avoid_print
      print('getting book poems error: $error');
    }
  }

  // Future <void> getSinglePoem(String poemId, ThemeProvider themeProvider) async {
  //   String baseUrl = 'https://sohelmahroof.com.bd/api/poem_details.php?poem=$poemId';
  //   try{
  //     var response = await http.get(Uri.parse(baseUrl));
  //     _poem = poemFromJson(response.body);
  //     // ignore: avoid_print
  //     print('poem list length: ${book!.result!.length}');
  //   } on SocketException{
  //     showToast('No internet connection!', themeProvider);
  //   }catch(error){
  //   // ignore: avoid_print
  //   print('getting single poem error: $error');
  //   }
  // }
}