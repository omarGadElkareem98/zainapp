
  import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_store/Screen/Ui/Employee_Profile.dart';
import 'package:panda_store/Services/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteScreen extends StatefulWidget {
    const FavouriteScreen({Key? key}) : super(key: key);

    @override
    State<FavouriteScreen> createState() => _FavouriteScreenState();
  }

  class _FavouriteScreenState extends State<FavouriteScreen> {

  List techs = [];
    @override



    void initState() {
    super.initState();
    getAllTechs();

    }

  void getAllTechs() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? decoded = sharedPreferences.getString('user');
    Map<String,dynamic> user = jsonDecode(decoded!);
    setState(() {
      techs = user['favorites'];
    });
  }

    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Favourite",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                  ),

                  SizedBox(height: 10,),

                  SizedBox(
                    height: 700,
                    child: FutureBuilder(
                      future: UserService.getAllFavoriteTechnicians(techs),
                      builder: (context,AsyncSnapshot snapshot){
                        if(snapshot.data != null){
                          return snapshot.data.isEmpty? Center(
                            child: Text('No Favourites Yet',style: TextStyle(
                              fontSize: 24
                            ),),
                          ):ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context , index){
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => employeeProfile(tech: snapshot.data[index]))
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: SizedBox(
                                      height: 125,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,


                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                  image: DecorationImage(fit: BoxFit.cover,image: MemoryImage(base64Decode(snapshot.data[index]['image'])))
                                              ),

                                            ),
                                            SizedBox(width: 10,),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 30),
                                              child: Column(

                                                children: [


                                                  Text("${snapshot.data[index]['category']['name']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                  SizedBox(height: 7,),
                                                  Text("${snapshot.data[index]['name']}" , style: TextStyle(fontStyle: FontStyle.italic),),
                                                  Text("50 Review" , style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey),),

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

                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  class ForyouItem extends StatelessWidget {
     ForyouItem({Key? key}) : super(key: key);

    @override

    final List <Map<String , dynamic>> Persons = [
      {"name" : "Omar Ahmed" , "ImageUrl" : "https://www.jobiano.com/uploads/jobs/28419/marketing_image/female-mechanical-technical-office-engineer-jobs-60d9ed6775a61.png" },

    ];

    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SizedBox(
          height: 125,
          child: Row(
            children: [
              Container(
                width: 50,


                decoration: BoxDecoration(
                    image: DecorationImage(fit: BoxFit.fill,image: NetworkImage("",))
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
