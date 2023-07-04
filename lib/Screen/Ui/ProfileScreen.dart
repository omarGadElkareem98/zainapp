
  import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panda_store/Constant/AppColor.dart';
import 'package:panda_store/Screen/Ui/SplachScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
    const ProfileScreen({Key? key}) : super(key: key);

    @override
    State<ProfileScreen> createState() => _ProfileScreenState();
  }

  class _ProfileScreenState extends State<ProfileScreen> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        appBar: AppBar(
          elevation: 0,
          title: TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text('Back',style: TextStyle(color: Colors.indigo,fontSize: 22,fontStyle: FontStyle.italic),),),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.data != null){
                    String? decoded = (snapshot.data as SharedPreferences).getString('user');
                    Map<String,dynamic> user = jsonDecode(decoded!);

                    return Stack(

                        children: [
                          Card(

                            margin: EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30,),
                                  Align( alignment: Alignment.center, child: Text(user['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                                  SizedBox(height: 10,),
                                  Align( alignment: Alignment.center, child: Text('Joined Since ${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(user['createdAt'])))} ',style: TextStyle(fontSize: 17,color: Colors.indigo),)),
                                  SizedBox(height: 20,),
                                  Divider(thickness: 1,),
                                  SizedBox(height: 40,),
                                  Text('Contact Info',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                  SizedBox(height: 20,),
                                  Text("ُُEmail: ${user['email']}",style: TextStyle(color: Colors.black,fontSize: 18),),
                                  SizedBox(height: 15,),
                                   Text('location: ${user['location']}',style: TextStyle(color: Colors.black,fontSize: 18),),

                                  SizedBox(height: 10,),
                                  Text('phoneNumber: ${user['phone']}',style: TextStyle(color: Colors.black,fontSize: 18),),

                                  Divider(thickness: 1,),
                                  SizedBox(height: 10,),



                                  SizedBox(height: 20,),
                                  Divider(thickness: 1,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20,right: 20,left: 20,top: 0),
                                      child: MaterialButton(
                                        onPressed: () async{
                                          SharedPreferences shared = await SharedPreferences.getInstance();
                                          await shared.remove('token');
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => SplachScreen(token: null))
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Logout',style: TextStyle(color: Colors.white,fontSize: 18),),
                                            SizedBox(width: 10,),
                                            Icon(Icons.logout_rounded,color: Colors.white,)
                                          ],
                                        ),
                                        color: AppColor.AppColors,
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Container(
                                width:70 ,
                                height:70 ,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(width: 5,color: Theme.of(context).scaffoldBackgroundColor),
                                    image: DecorationImage(image:MemoryImage(
                                      base64Decode(user['image'])
                                    ),fit: BoxFit.fill)
                                ),
                              )
                            ],)
                        ]
                    );
                  }

                  return Text('');
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  void SendMessageByWatsapp()async{

    String PhoneNumber = '+201156467293';

    await  launch('https://wa.me/$PhoneNumber?text=hello');

  }
  void SendMail()async{
    String email = 'omarsabry8989@gmail.com';
    var url =  'mailto:$email';
    await launch(url);
  }
  void CallPhoneNumber () async{
    String PhoneNumber = '+01156467293';
    var phoneUrl = 'tel://$PhoneNumber';

    await  launch(phoneUrl);
  }


