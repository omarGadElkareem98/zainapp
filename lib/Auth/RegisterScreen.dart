
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:panda_store/Auth/LoginScreen.dart';
import 'package:panda_store/Services/users.dart';

import '../Constant/AppColor.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _location = TextEditingController();
  String locationData = '';

  bool _imageUploaded = false;
  File? _image;

  TextEditingController _phoneController = TextEditingController();

  @override
  void NavigateToLoginScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return LoginScreen();
    }));
  }

  final TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _password = TextEditingController();

  GlobalKey <FormState> _formKey = GlobalKey();


   Future<void> validateSignup() async{
     try{
      Map<String,dynamic> data = await UserService.register(
          name: _nameController.text,
          email: _emailController.text,
          password: _password.text,
          location: locationData,
        phone:_phoneController.text
      );


      await UserService.uploadUserImage(userId: data['user']['_id'],imagePath: _image!.path);

      Navigator.pop(context);
     }catch(error){
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Failed To Signup',style: TextStyle(
           fontSize: 20,
           color: Colors.white
         ),),backgroundColor: Colors.red,)
       );
     }
   }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(

          children: [
            Image.network("https://thumbs.dreamstime.com/b/outils-de-g%C3%A9n%C3%A9ration-au-fond-plancher-ciment-grayblack-avec-le-concept-d-entretien-r%C3%A9paration-du-copier-spacehome-r%C3%A9novation-208702230.jpg",fit: BoxFit.cover,height: double.infinity,),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      GestureDetector(
                          onTap: (){
                            _uploadImage();
                          },
                          child: !_imageUploaded ? Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.cyan,
                              child: Icon(Icons.add,size: 50,color: Colors.white,),
                            ),
                          ): Container(
                            alignment: Alignment.center,
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.circular(150.0)
                            ),
                          )
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                    style: TextStyle(color: Colors.white),

                        validator: (val){
                          if(val!.isEmpty){
                            return 'Enter your email';
                          }
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: 'email',

                            hintStyle: TextStyle(color: Colors.white),
                            labelText: 'email',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: Colors.white)
                            )
                        ),
                        keyboardType: TextInputType.emailAddress,


                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return ' Enter your name';
                          }
                        } ,
                        controller: _nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'name',
                            hintStyle: TextStyle(color: Colors.white),

                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'name',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(color: Colors.white)
                            )
                        ),
                        keyboardType: TextInputType.text,



                      ),
                      SizedBox(height: 15,),
                      IntlPhoneField(
                        style: TextStyle(color: Colors.white),
                        initialCountryCode: 'SA',

                        controller: _phoneController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(color: Colors.white)
                            ),
                            label: Text('رقم الهاتف',style: TextStyle(color: Colors.white),),
                            hintText: 'رقم الهاتف',
                          hintStyle: TextStyle(color: Colors.white)
                        ),
                      ),
                      TextButton(
                        onPressed: () async{
                          Position position = await _determinePosition();
                          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

                          setState(() {
                            locationData = "${placemarks[0].street} - ${placemarks[0].locality} - ${placemarks[0].administrativeArea} - ${placemarks[0].country}";
                          });
                        },
                        child: Text('Access Current Location',style: TextStyle(color: Colors.white,fontSize: 20),),
                      ),
                      SizedBox(height: 15,),
                      Text(locationData,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                      SizedBox(height: 15,),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        validator: (val){
                          if(val!.isEmpty){
                            return ' enter your pass';
                          }
                        },
                        controller: _password,

                        decoration: InputDecoration(
                            hintText: 'password',
                            hintStyle: TextStyle(color: Colors.white),
                            labelText: 'password',
                          labelStyle: TextStyle(color: Colors.white)


                        ),
                        obscureText: true,



                      ),
                      SizedBox(height: 10,),

                      SizedBox(height: 15,),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18)
                        ),

                        child: MaterialButton(
                          onPressed: () async{
                            if(_formKey.currentState!.validate() && _image != null){
                              await validateSignup();

                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Fill Form First',style: TextStyle(
                                      fontSize: 20
                                  ),))
                              );
                            }

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('sign up',style:TextStyle(color: AppColor.AppColors,fontSize: 20) ,),
                          ),
                          color: Colors.white,


                        ),
                      ),

                      Row(
                        children: [
                          TextButton(onPressed: (){}, child: Text('Already have an account ',style: TextStyle(color: Colors.white),)),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_){
                              return LoginScreen();
                            }));
                          }, child: Text('login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),) )
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _imageUploaded = true;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
