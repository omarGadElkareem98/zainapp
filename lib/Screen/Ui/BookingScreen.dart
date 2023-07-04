
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_store/Services/reservations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant/AppColor.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("My BookMark ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                ),

                SizedBox(height: 10,),

                SizedBox(
                  height: 700,
                  child: FutureBuilder(
                    future: SharedPreferences.getInstance(),
                    builder: (context, AsyncSnapshot snapshot){
                      if(snapshot.data != null){
                        String? decoded = (snapshot.data as SharedPreferences).getString('user');
                        Map<String,dynamic> user = jsonDecode(decoded!);

                        return FutureBuilder(
                            future: ReservationService.getUserReservations(user['_id']),
                            builder: (context,AsyncSnapshot rss){
                              if(rss.connectionState == ConnectionState.waiting){
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }else if(rss.connectionState == ConnectionState.done){
                                if(rss.data != null){
                                  return rss.data.isEmpty ? Center(
                                    child: Text('There Is No Bookings Yet',style: TextStyle(
                                      fontSize: 24
                                    ),),
                                  ):ListView.builder(
                                      itemCount: rss.data.length,
                                      itemBuilder: (context , index){
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: BorderRadius.circular(12.0)
                                            ),
                                            height: 125,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,

                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(600),
                                                        image: DecorationImage(fit: BoxFit.cover,image: MemoryImage(base64Decode(rss.data[index]['technicianId']['image']))),
                                                    ),

                                                  ),
                                                  SizedBox(width: 10,),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 30),
                                                    child: Column(

                                                      children: [


                                                        Text("${rss.data[index]['technicianId']['category']['name']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                                                        Text("${rss.data[index]['technicianId']['name']}"),

                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                    onPressed: (){
                                                      _deleteBooking(rss.data[index]['_id']);
                                                    },
                                                    icon: Icon(Icons.delete,color: AppColor.AppColors,size: 30,),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }

                              return Text('');
                            }
                        );
                      }

                      return Text('');
                    },
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteBooking(String id) async{
    try{
      await ReservationService.deleteReservation(id);
      setState(() {});
    }catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete booking'))
      );
    }
  }
}

class ForyouItem extends StatelessWidget {
  const ForyouItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: SizedBox(
        height: 125,
        child: Row(
          children: [
            Container(
              width: 50,


              decoration: BoxDecoration(
                  image: DecorationImage(fit: BoxFit.fill,image: NetworkImage("https://img.icons8.com/?size=512&id=hgCYIjaa8Iqo&format=png",))
              ),

            ),
            SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(

                children: [


                  Text("House Clean",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                  Text("omar sabry"),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



