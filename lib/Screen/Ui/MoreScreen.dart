
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_store/Constant/AppColor.dart';
import 'package:panda_store/Screen/Ui/About.dart';
import 'package:panda_store/Screen/Ui/Languages.dart';
import 'package:panda_store/Screen/Ui/Terms.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SplachScreen.dart';

class MoreSscreen extends StatefulWidget {
  const MoreSscreen({Key? key}) : super(key: key);

  @override
  State<MoreSscreen> createState() => _MoreSscreenState();
}

class _MoreSscreenState extends State<MoreSscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            children: [
             ItemWidget(icondata: Icons.privacy_tip, text: 'Conditions & Terms', onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context){
                 return Terms();
               }));
             }),
              SizedBox(height: 12,),
              ItemWidget(icondata: Icons.language, text: 'Change language', onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Languages();
                }));
              }),
              SizedBox(height: 12,),
              ItemWidget(icondata: Icons.question_mark, text: 'About Zainlak', onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return About();
                }));
              }),
              SizedBox(height: 12,),
              ItemWidget(icondata: Icons.logout, text: 'LogOut', onTap: ()async{
                SharedPreferences shared = await SharedPreferences.getInstance();
                await shared.remove('token');
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SplachScreen(token: null))
                );

              }),
            ],
        ),
      ),
    );
  }
}

  class ItemWidget extends StatelessWidget {
  final IconData icondata;
  final String text;
  final VoidCallback onTap;
    const ItemWidget({Key? key, required this.icondata, required this.text, required this.onTap}) : super(key: key);

    @override



    Widget build(BuildContext context) {
      return  Container(
        decoration: BoxDecoration(
            color: AppColor.AppColors,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
            boxShadow: [
              BoxShadow(
                  offset: Offset(-2, 2),
                  color: Colors.black26
              )
            ]

        ),
        child: ListTile(
          title: Text('${text}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          trailing: Icon(icondata,color: Colors.white,size: 30,),
         onTap: onTap,

        ),
      );
    }
  }

