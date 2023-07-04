import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panda_store/Constant/AppColor.dart';
import 'package:panda_store/Screen/Ui/SplachScreen.dart';
import 'package:panda_store/Services/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();



  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString('token');

  if(token != null){
    var decoded = sharedPreferences.getString('user');
    var user = jsonDecode(decoded!);
    var userData = await UserService.getUser(user['_id']);

    await sharedPreferences.setString('user', jsonEncode(userData));
  }
  runApp( EasyLocalization(child: MyApp(token: token,), supportedLocales: [Locale('en', ''), Locale('ar', '')],
    path: "assets/Lang",
    fallbackLocale: Locale('en', ''),));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key,required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: ( BuildContext, Widget ){
      return  MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Zainlak',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: AppColor.AppColors,
              elevation: 0
            )

          ),
          home: SplachScreen(token:token)
      );
    });
  }
}


