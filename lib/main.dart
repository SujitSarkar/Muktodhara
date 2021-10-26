import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/home_screen.dart';
import 'package:mukto_dhara/variables/color_variables.dart';
import 'package:mukto_dhara/variables/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref= await SharedPreferences.getInstance();
  final bool isLight = pref.getBool('isLight') ?? true;
  runApp(MyApp(isLight));

}

class MyApp extends StatefulWidget {
  bool isLight;
  MyApp(this.isLight);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(widget.isLight?SThemeData.lightThemeData:SThemeData.darkThemeData,widget.isLight)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'মুক্তধারা',
            theme: themeProvider.themeData,
            home: const Home(),
          );
        }
      ),
    );
  }
}

