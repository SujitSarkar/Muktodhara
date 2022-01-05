import 'package:flutter/material.dart';
import 'package:mukto_dhara/model/favourite_poem_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper extends ChangeNotifier{

  final List<FavouritePoemModel> _favouritePoemList = [];
  final List<String> _favouritePoemIdList = [];

  get favouritePoemList => _favouritePoemList;
  get favouritePoemIdList => _favouritePoemIdList;


  static DatabaseHelper? _databaseHelper; // singleton DatabaseHelper
  static Database? _database; // singleton Database

  String favouritePoemsTable = 'favouritePoemTable';
  String colId = 'id';
  String colPostId = 'postId';
  String colPoemName = 'poemName';
  String colFirstLine = 'firstLine';
  String colPoem = 'poem';

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $favouritePoemsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colPostId TEXT, $colPoemName TEXT, $colFirstLine TEXT, $colPoem TEXT)');
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
    _favouritePoemIdList.clear();
    var favouritePoemMapList = await getFavouritePoemsMapList();
    int count = favouritePoemMapList.length;
    for (int i = 0; i < count; i++) {
      _favouritePoemList.add(FavouritePoemModel.fromMapObject(favouritePoemMapList[i]));
      _favouritePoemIdList.add(FavouritePoemModel.fromMapObject(favouritePoemMapList[i]).postId);
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

  ///Insert operation
  Future<int> insertFavouritePoem(FavouritePoemModel favouritePoemModel) async {
    Database db = await database;
    var result = await db.insert(favouritePoemsTable, favouritePoemModel.toMap());
    await getFavouritePoems();
    return result;
  }

  ///Delete operation
  Future<int> deleteFavouritePoem(String postId, int index) async {
    Database db = await database;
    var result =
    await db.rawDelete('DELETE FROM $favouritePoemsTable WHERE $colPostId = $postId');
    _favouritePoemIdList.removeAt(index);
    await getFavouritePoems();
    notifyListeners();
    return result;
  }

  //Delete operation
  // Future<int> deleteAllCartList() async {
  //   Database db = await this.database;
  //   var result =
  //   await db.rawDelete('DELETE FROM $cartTable');
  //   await getCartList();
  //   return result;
  // }
}