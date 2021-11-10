import 'package:flutter/material.dart';
import 'package:mukto_dhara/model/favourite_poem_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper extends ChangeNotifier{

  List<FavouritePoemModel> _favouritePoemList = [];
  // List<String> _productIdListInCart=[];


  get favouritePoemList => _favouritePoemList;
  // get productIdListInCart=> _productIdListInCart;

  static DatabaseHelper? _databaseHelper; // singleton DatabaseHelper
  static Database? _database; // singleton Database

  String favouritePoemsTable = 'cart_table';
  String colId = 'id';
  String colPostId = 'postId';
  String colPoemName = 'poemName';
  String colFirstLine = 'firstLine';

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $favouritePoemsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colId TEXT, $colPostId TEXT, $colPoemName TEXT, $colFirstLine TEXT)');
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for both android and iOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'favouriteBook.db';
    var noteDatabase =
    await openDatabase(path, version: 1, onCreate: _createDB);
    return noteDatabase;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  //Fetch Map list from DB
  Future<List<Map<String, dynamic>>> getFavouritePoemsMapList() async {
    Database db = await database;
    var result = await db.query(favouritePoemsTable, orderBy: '$colId ASC');
    return result;
  }

  ///Get the 'Map List' and convert it to 'Cart List
  Future<void> getFavouritePoems() async {
    _favouritePoemList.clear();
    var favouritePoemMapList = await getFavouritePoemsMapList();
    int count = favouritePoemMapList.length;
    for (int i = 0; i < count; i++) {
      _favouritePoemList.add(FavouritePoemModel.fromMapObject(favouritePoemMapList[i]));
    }
    notifyListeners();
  }

  //update operation
  // Future<int> updateCart(CartModel cartModel) async {
  //   Database db = await this.database;
  //   var result = await db.update(cartTable, cartModel.toMap(),
  //       where: '$colPId = ?', whereArgs: [cartModel.pId]);
  //   await getCartList();
  //   return result;
  // }

  //Insert operation
  Future<int> insertCart(FavouritePoemModel favouritePoemModel) async {
    Database db = await database;
    var result = await db.insert(favouritePoemsTable, favouritePoemModel.toMap());
    await getFavouritePoems();
    return result;
  }

  //Delete operation
  // Future<int> deleteCart(String pId) async {
  //   Database db = await this.database;
  //   var result =
  //   await db.rawDelete('DELETE FROM $cartTable WHERE $colPId = $pId');
  //   await getCartList();
  //   return result;
  // }

  //Delete operation
  // Future<int> deleteAllCartList() async {
  //   Database db = await this.database;
  //   var result =
  //   await db.rawDelete('DELETE FROM $cartTable');
  //   await getCartList();
  //   return result;
  // }
}