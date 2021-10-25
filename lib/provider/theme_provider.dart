import 'package:flutter/material.dart';
import 'package:mukto_dhara/variables/color_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData;
  bool _isLight;
  ThemeProvider(this._themeData,this._isLight);

  get themeData => _themeData;
  get isLight => _isLight;


  Future<void> toggleThemeData()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    _isLight = !_isLight;
    if(_isLight){
      _themeData = ThemeData(
          backgroundColor:  Colors.white,
          primarySwatch: MaterialColor(0xffFF5C00, CColor.lightThemeMapColor),
          canvasColor: Colors.transparent,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              selectedItemColor: CColor.lightThemeColor
          )
      );
      notifyListeners();
      pref.setBool('isLight', true);
    }else{
      _themeData = ThemeData(
          backgroundColor: CColor.darkThemeColor,
          primarySwatch: MaterialColor(0xff1F221F, CColor.darkThemeMapColor),
          canvasColor: Colors.transparent,
          indicatorColor: Colors.grey,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.white
          )
      );
      //_isLight=false;
      notifyListeners();
      pref.setBool('isLight', false);
    }
  }

  Color appBarColor() => _isLight? Colors.white : CColor.darkThemeColor;
  Color screenBackgroundColor() => _isLight? Colors.white : CColor.darkThemeColor;
  Color appBarMenuColor() => _isLight? CColor.darkThemeColor : Colors.white;
  Color appBarMenuItemColor() => _isLight? Colors.white : CColor.darkThemeColor;

}

