
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_store/Constant/AppColor.dart';
import 'package:panda_store/Screen/Ui/Employee_Profile.dart';
import 'package:panda_store/Screen/Ui/ProfileScreen.dart';
import 'package:panda_store/Services/category.dart';
import 'package:panda_store/Services/popularTechnician.dart';
import 'package:panda_store/Services/technicians.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DetailsScreen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  @override

      void NavigateToDetailsScreen (String id,String name){
        Navigator.push(context, MaterialPageRoute(builder: (context,){
          return DetailsScreen(id:id,name:name);
        }));
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  width: double.infinity,

                  color: AppColor.AppColors,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfileScreen())
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(8.0),
                      child: Row(

                        children: [
                          FutureBuilder(
                              future: SharedPreferences.getInstance(),
                              builder: (context,AsyncSnapshot snapshot){
                                if(snapshot.data != null){
                                  String? decoded = (snapshot.data as SharedPreferences).getString('user');
                                  Map<String,dynamic> user = jsonDecode(decoded!);
                                  return Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: Image.memory(base64Decode(user['image']),width: 40,height: 40,).image,
                                            fit: BoxFit.cover
                                          ),
                                          borderRadius: BorderRadius.circular(40)
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      Text("${user['name']}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                    ],
                                  );
                                }
                                return Text('');
                              }
                          ),
                          SizedBox(width: 8.0,),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 40,
                              child: TextField(


                                keyboardType: TextInputType.text,
                                readOnly: true,
                                onTap: () async{
                                  List technicians = await TechnicianService.getAllTechnicians();

                                  await showSearch(
                                    context: context,
                                    delegate: TechnicianSearchDelegate(technicians: technicians),
                                  );
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    prefixText: 'Search',

                                    suffixIcon: Icon(Icons.search,color: Colors.white,),
                                    hintStyle: TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),

                                    ),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
                                ),

                              ),
                            ),
                          ),
                          SizedBox(width: 8.0,),
                          Icon(Icons.notifications_outlined,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)
              ),

              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  CarouselSlider(


                    items: [

                      CachedNetworkImage(
                        imageUrl:  'https://skywestpropertysolutions.com/wp-content/uploads/2017/05/pexels-photo-175039-1.jpeg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context,_,__){
                          return Container(
                            alignment: Alignment.center,
                            child: Text('no image',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),),
                          );
                        },
                      ),

                      CachedNetworkImage(
                        imageUrl:  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpYUhxjdCnVeqa1JH5mpTkeoEWbspKeHdMb2OSUh4dD2HKV3s5z5A_kZ2EkpdNIBwo-ww&usqp=CAU',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context,_,__){
                          return Container(
                            alignment: Alignment.center,
                            child: Text('no image',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),),
                          );
                        },
                      ),

                      CachedNetworkImage(
                        imageUrl:  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqJ2ezf__b97rc4Hp7Hlog6k-NSuI-leU9aJZBJ8x3LbYT3DVk6Whw5IkN_cOP-yXtWJo&usqp=CAU',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context,_,__){
                          return Container(
                            alignment: Alignment.center,
                            child: Text('no image',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),),
                          );
                        },
                      ),

                    ],
                    options: CarouselOptions(
                        autoPlay: true,
                        reverse: true,
                        viewportFraction: 1,
                        initialPage: 0,
                        height: 200


                    ),

                  ),


                ],
              ),
            ),

            SizedBox(height: 12,),


            Container(
              margin: EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: CategoryService.getAllCategories(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.data != null){
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0
                      ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context , index){
                          return GestureDetector(
                            onTap: (){
                              NavigateToDetailsScreen(snapshot.data[index]['_id'],snapshot.data[index]['name']);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColor.AppColors,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex:1,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: MemoryImage(base64Decode(snapshot.data[index]['image'])))
                                      ),

                                    ),
                                  ),

                                  Container(
                                    width: double.infinity,
                                    height: 30,
                                    alignment: Alignment.center,

                                    padding: EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        )
                                      ),
                                      child: Text("${snapshot.data[index]['name']}" ,
                                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black87),))
                                ],
                              ),
                            ),
                          );
                        });
                  }

                  return Text('nothing yet');
                },
              ),
            ),

            SizedBox(height: 8,),

            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Text("Recommended",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            ),
                SizedBox(height: 5,),

            SizedBox(
              height: 400,
              child: FutureBuilder(
                future: PopularTechnicianService.getAllPopularTechnicians(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.data != null){
                    return ListView.builder(
                      shrinkWrap: true,
                        physics:NeverScrollableScrollPhysics() ,
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context , index){
                          return  GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => employeeProfile(tech: snapshot.data[index]))
                              );
                            },
                            child: Container(
                              height: 125,
                              padding: const EdgeInsets.only(left: 9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 60,
                                      height: 60,


                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                          image: DecorationImage(fit: BoxFit.cover,image: MemoryImage(base64Decode(snapshot.data[index]['image'])))
                                      ),

                                    ),
                                  ),
                                  SizedBox(width: 8,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [


                                      Text("${snapshot.data[index]['category']['name']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                                      Text("${snapshot.data[index]['name']}"),

                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }

                  return Text('');
                },
              ),
            ),








          ],

        ),
      ),
    );
  }
}

// //   class ServicesItem extends StatefulWidget {
// //
// //
// //       ServicesItem({Key? key,}) : super(key: key);
// //
// //   @override
// //   State<ServicesItem> createState() => _ServicesItemState();
// // }
//
// class _ServicesItemState extends State<ServicesItem> {
//     @override
//     final List <Map<String , dynamic>> Serv = [
//
//       { "name" :  'فني تبريد وتكيف',
//         "ImageUrl" : 'https://img.icons8.com/?size=512&id=hgCYIjaa8Iqo&format=png'},
//       { "name" : 'سباك',
//         "ImageUrl" : 'https://img.icons8.com/?size=512&id=fJtcL3pXcD0X&format=png'},
//       { "name" :  'كهربائي',
//         "ImageUrl": 'https://img.icons8.com/?size=512&id=rLXi4piOlLRV&format=png'},
//     ];
//
//     Widget build (BuildContext context, ) {
//       return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Container(
//               width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(image: NetworkImage("${Serv.elementAt(index)['ImageUrl']}"))
//                 ),
//
//             ),
//
//             Text("${Serv.elementAt(index)['name']}")
//           ],
//         ),
//       );
//     }
// }

class ForyouItem extends StatelessWidget {
  const ForyouItem({Key? key}) : super(key: key);

  @override
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
                  image: DecorationImage(fit: BoxFit.fill,image: NetworkImage("https://img.icons8.com/?size=512&id=hgCYIjaa8Iqo&format=png",))
              ),

            ),
            SizedBox(width: 10,),
            Column(

              children: [


                Text("House Clean",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                Text("omar sabry"),

              ],
            )
          ],
        ),
      ),
    );
  }
}




class TechnicianSearchDelegate extends SearchDelegate{
  final List technicians;

  TechnicianSearchDelegate({required this.technicians});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Perform filtering based on the query
    List filteredTechnicians = technicians
        .where((technician) =>
        technician['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();


    // Build the filtered results UI
    return filteredTechnicians.isEmpty ? Center(
      child: Text('No Technicians Were Found!',style: TextStyle(
        fontSize: 24
      ),),
    ):ListView.builder(
      itemCount: filteredTechnicians.length,
      itemBuilder: (context, index) {
        var technician = filteredTechnicians[index];
        return GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => employeeProfile(tech: technician))
            );
          },
          child: Container(
            color: AppColor.AppColors,
            margin: EdgeInsets.only(top: 8.0,left: 8.0,right:8.0),
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.memory(base64Decode(technician['image']),height: 60,width: 60,),
                SizedBox(width: 8.0,),
                Text(technician['name'],style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),)
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Perform suggestions based on the query (optional)

    // You can implement suggestions based on the query,
    // such as fetching suggestions from an API or using a predefined list.

    // In this example, we'll return an empty container for simplicity.
    return Container();
  }
}