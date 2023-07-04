

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panda_store/Constant/AppColor.dart';
import 'package:panda_store/Services/reservations.dart';
import 'package:panda_store/Services/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Auth/LoginScreen.dart';

class employeeProfile extends StatefulWidget {
  final Map<String,dynamic> tech;
  const employeeProfile ({Key? key, required this.tech}) : super(key: key);

  @override
  State<employeeProfile> createState() => _employeeProfile();
}

class _employeeProfile extends State<employeeProfile> {

  final  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  bool isLoading = false;
  String phoneNumber = "";
  String email="";
  String name = "";
  String position = "";
  String joinedAt = "";
  String imageUrl = "";
  String job = "";
  bool isSameUser = false;

  DateTime? _date;

  int _time = 0;
  bool _isFavorite = false;
  void detectIsFavorite()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? decoded = sharedPreferences.getString('user');
    Map<String,dynamic> user = jsonDecode(decoded!);
    if((user['favorites'] as List).contains(widget.tech['_id'])){
      setState(() {
        _isFavorite = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detectIsFavorite();
  }

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime Date = DateTime.now();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Stack(


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
                              Align( alignment: Alignment.center, child: Text(widget.tech['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                              SizedBox(height: 10,),
                              Align( alignment: Alignment.center, child: Text('Joined Since ${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.tech['createdAt'])))}',style: TextStyle(fontSize: 17,color: Colors.indigo),)),
                              SizedBox(height: 20,),
                              Divider(thickness: 1,),
                              SizedBox(height: 40,),
                              Center(child: Text('تواصل مع الفني',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.blue,
                                    child: CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.white,
                                      child: IconButton(onPressed: (){
                                        SendMessageByWatsapp();
                                      }, icon:Icon (Icons.message)) ,
                                    ),
                                  ),

                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.green,
                                    child: CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.white,
                                      child: IconButton(onPressed: (){
                                        CallPhoneNumber();
                                      }, icon:Icon (Icons.phone,color: Colors.green,)) ,
                                    ),
                                  ),


                                ],
                              ),
                              SizedBox(height: 15,),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20,right: 20,left: 20,top: 0),
                                  child: MaterialButton(
                                    onPressed: () async{
                                      DateTime? date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2024)
                                      );

                                      if(date != null){
                                        TimeOfDay? time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now()
                                        );

                                        if(time != null){
                                          setState(() {
                                            _date = date;
                                            _time = time.hour;
                                          });
                                        }
                                        await bookReservation();
                                      }


                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('احجز زياره للمنزل',style: TextStyle(color: Colors.white,fontSize: 18),),
                                SizedBox(width: 10,),
                                Icon(Icons.bookmark_border,color: Colors.white,)
                                ],
                              ),
                                    color: AppColor.AppColors,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: ()async{
                                    SharedPreferences shared = await SharedPreferences.getInstance();
                                    var decoded = shared.getString('user');
                                    var user = jsonDecode(decoded!);
                                    if(_isFavorite){
                                      List newT = await UserService.deleteFavoriteTech(user['_id'], widget.tech['_id']);
                                      user['favorites'] = newT;
                                      await shared.setString('user', jsonEncode(user));
                                    }else{
                                      List newX = await UserService.createFavoriteTech(user['_id'], widget.tech['_id']);
                                      user['favorites'] = newX;
                                      await shared.setString('user', jsonEncode(user));
                                    }
                                    setState(() {
                                      _isFavorite = !_isFavorite;
                                    });
                                  },
                                  icon: Icon(Icons.favorite,color: _isFavorite ? AppColor.AppColors : Colors.black,),
                                ),
                              ),
                              Divider(thickness: 1,),
                              SizedBox(height: 10,),


                              SizedBox(height: 10,),






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
                                image: DecorationImage(image: MemoryImage(base64Decode(widget.tech['image'])),fit: BoxFit.fill)
                            ),
                          )
                        ],)
                    ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void SendMessageByWatsapp()async{


    await  launch('https://wa.me/${widget.tech['phone']}?text=hello');

  }
  void SendMail()async{
    String email = 'omarsabry8989@gmail.com';
    var url =  'mailto:${widget.tech['email']}';
    await launch(url);
  }
  void CallPhoneNumber () async{
    var phoneUrl = 'tel://${widget.tech['phone']}';

    await  launch(phoneUrl);
  }
  void logOut (context){
    FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(context: context, builder: (context){

      return  AlertDialog(

        title: Column(
          children: [
            Row(children: [
              Icon(Icons.logout),
              SizedBox(width: 10,),
              Text('Sign Out')
            ],),
            SizedBox(height: 10,),
            TextButton(onPressed: (){}, child: Text('Do you want logOut',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),))
          ],
        ),
        actions: [
          TextButton(onPressed: ()async{
            await  _auth.signOut();


            Navigator.push(context, MaterialPageRoute(builder: (context){
              return LoginScreen();
            }));

          }, child: Text('Ok')),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
        ],

      );
    });
  }

  Future<void> bookReservation() async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? decoded = sharedPreferences.getString('user');
      Map<String,dynamic> user = jsonDecode(decoded!);
      DateFormat format = DateFormat('MM-dd');
      String newDate = format.format(_date!);

      var data = await ReservationService.createReservation(user['_id'], widget.tech['_id'], newDate,_time);
      await showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              backgroundColor: AppColor.AppColors,
              content: Container(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Booking Was Created Successfully',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                    ),),

                    SizedBox(height: 20,),

                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check,size: 60,color: Colors.white,),
                    )
                  ],
                ),
              ),
              elevation: 0,
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('ok',style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  ),),
                )
              ],
            );
          }
      );
    }catch(error){
      await showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              backgroundColor: AppColor.AppColors,
              content: Container(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Booking Already Taken',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),),

                    SizedBox(height: 20,),

                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check,size: 60,color: Colors.white,),
                    )
                  ],
                ),
              ),
              elevation: 0,
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('ok',style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  ),),
                )
              ],
            );
          }
      );
    }
  }
}