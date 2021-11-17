import 'package:flutter/material.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/screens/book_list_page.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getBookList();
    Future.delayed(const Duration(seconds: 4)).then((value){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BookListPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
            height: size.height,
            child: Image.asset('assets/splash_screen_image.jpeg', fit: BoxFit.cover,)),
      ),
    );
  }
}
