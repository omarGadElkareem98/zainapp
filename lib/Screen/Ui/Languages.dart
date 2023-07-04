
  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_store/Constant/AppColor.dart';

class Languages extends StatefulWidget {
    const Languages({Key? key}) : super(key: key);

    @override
    State<Languages> createState() => _LanguagesState();
  }

  class _LanguagesState extends State<Languages> {
    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: ()async{
                  await context.setLocale(Locale('en' , ''));
                }, style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50,),
                  backgroundColor: AppColor.AppColors
                ), child: Text("En")),
                ElevatedButton(onPressed: ()async{
                  await context.setLocale(Locale('ar', ''));
                }, style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50,),
                    backgroundColor: AppColor.AppColors
                ), child: Text("Ar")),
              ],
            ),
          ),
        ),
      );
    }
  }
