
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:panda_store/Auth/ForgtPassword.dart';
import 'package:panda_store/Auth/RegisterScreen.dart';
import 'package:panda_store/Constant/AppColor.dart';
import 'package:panda_store/Screen/Ui/HomeScreen.dart';
import 'package:panda_store/Screen/Ui/MainScreen.dart';
import 'package:panda_store/Services/users.dart';
import 'package:translator/translator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  GlobalKey <FormState> _formKey = GlobalKey();

  FirebaseAuth  _firebaseAuth = FirebaseAuth.instance;

  void NavigateToRegiserScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return RegisterScreen();
    }));
  }

  Future<void> validateLogin() async{
    try{
      String email = _emailController.text;
      String password = _password.text;
     String phone=_phoneController.text;
    await UserService.login(email, password);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen())
      );
    }catch(error){
      await showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Container(
                child: Text('Wrong Email Or Password'),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('ok',style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),),
                )
              ],
            );
          }
      );
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Stack(
          children: [


            Padding(
              padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Center(child: Text('Zainlak',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: AppColor.AppColors),)),
                      Center(child: Text("خدمات بيتك في ايدك",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
                      SizedBox(height: 30,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return ' Enter your name';
                          }
                        } ,
                        controller: _emailController,
                        style: TextStyle(color: AppColor.AppColors),
                        decoration: InputDecoration(
                            hintText: 'Email'.tr(),
                            hintStyle: TextStyle(color: AppColor.AppColors),

                            labelStyle: TextStyle(color: AppColor.AppColors),
                            labelText: 'email'.tr(),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(color: AppColor.AppColors)
                            ),
                          border: OutlineInputBorder()
                        ),
                        keyboardType: TextInputType.emailAddress,



                      ),

                      SizedBox(height: 25,),
                      TextFormField(
                        controller: _password,
                        style: TextStyle(color: AppColor.AppColors),
                        validator: (val){
                          if(val!.isEmpty){
                            return 'password is empty';
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'password'.tr(),
                            hintStyle: TextStyle(color: AppColor.AppColors),
                            labelText: "Password".tr(),
                            labelStyle: TextStyle(color: AppColor.AppColors),


                            border: OutlineInputBorder(

                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.AppColors),
                                borderRadius: BorderRadius.circular(18)
                            )
                        ),
                        obscureText: true,



                      ),
                      SizedBox(height: 10,),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return ForgotPassword();
                        }));
                      }, child: Text('Forget Password',style: TextStyle(color: AppColor.AppColors),).tr()),
                      SizedBox(height: 15,),
                      Container(
                        width: double.infinity,

                        child: MaterialButton(
                          onPressed: ()async{
                            if(_formKey.currentState!.validate()){
                              await validateLogin();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Login',style:TextStyle(color: Colors.white,fontSize: 20) ,).tr()
                          ),
                          color: AppColor.AppColors,


                        ),
                      ),

                      Row(
                        children: [

                          Expanded(
                            child: TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_){
                                return RegisterScreen();
                              }));
                            }, child: Text('Sign Up',style: TextStyle(color: AppColor.AppColors,fontWeight: FontWeight.bold,fontSize: 15),).tr() ),
                          )
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

}

// void ScaffoldWidget (){
//   return Scaffold(
//     backgroundColor: Colors.white,
//     body: Center(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           width: double.infinity,
//           height: 400,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18)
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Welcome To Zainlak" , style: TextStyle(color: AppColor.AppColors,fontSize: 20 , fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
//
//                   SizedBox(height: 10,),
//
//                   TextFormField(
//                     controller: _emailController,
//                     validator: (value){
//                       if(value!.isEmpty){
//                         return "Please Enter your Email";
//                       }
//                     },
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                         hintText: "Email",
//                         suffixIcon: Icon(Icons.email_outlined)
//
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   TextFormField(
//                     controller: _password,
//                     validator: (value){
//                       if(value!.isEmpty){
//                         return "Please Enter your Password";
//                       }
//                     },
//                     decoration: InputDecoration(
//                       hintText: "password",
//                       suffixIcon: Icon(Icons.visibility_off),
//
//                     ),
//                     obscureText: true,
//                   ),
//                   SizedBox(height: 10,),
//
//                   Container(
//                       width: double.infinity,
//                       child: MaterialButton(onPressed: (){
//                         validateLogin();
//                       } , child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),color: AppColor.AppColors,)),
//                   Align(
//                       alignment: Alignment.bottomRight,
//                       child: TextButton(onPressed: (){
//                         Navigator.push(context, MaterialPageRoute(builder: (context ){
//                           return ForgotPassword();
//                         }));
//                       }, child: Text('Forget Password'))),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("IF you don\'t have an account"),
//                       TextButton(onPressed: (){
//                         NavigateToRegiserScreen();
//                       }, child: Text('Sign Up' , style: TextStyle(color: AppColor.AppColors,fontWeight: FontWeight.bold),))
//                     ],
//                   )
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   )
// }
