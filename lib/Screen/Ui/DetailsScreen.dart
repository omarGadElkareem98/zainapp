
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_store/Screen/Ui/Employee_Profile.dart';
import 'package:panda_store/Services/technicians.dart';

import 'ProfileScreen.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String name;
 const   DetailsScreen({Key? key, required this.id,required this.name}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: TechnicianService.getAllTechnicians(categoryId: widget.id),
            builder: (context,AsyncSnapshot snapshot){
              if(snapshot.data != null){
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context , index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SizedBox(
                          height: 125,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return employeeProfile(tech:snapshot.data[index]);
                                }));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,


                                    decoration: BoxDecoration(
                                        image: DecorationImage(fit: BoxFit.fill,image: MemoryImage(base64Decode(snapshot.data[index]['image']),))
                                    ),

                                  ),
                                  SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Column(

                                      children: [


                                        Text("${widget.name}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                        SizedBox(height: 7,),
                                        Text("${snapshot.data[index]['name']}" , style: TextStyle(fontStyle: FontStyle.italic),),
                                        Text("${snapshot.data[index]['reviews']} Review" , style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey),),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }

              return Text('');
            },
          ),
        )
    );
  }
}

class WorkerItem extends StatelessWidget {
  const WorkerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network("https://img.icons8.com/?size=512&id=7819&format=png",width: 40,),
          SizedBox(width: 12,),
          Text("your name"),

          MaterialButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ProfileScreen();
            }));
          } , child: Text('Visit',style: TextStyle(color: Colors.white),),color: Colors.black,)

        ],
      ),
    );
  }
}
