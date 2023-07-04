


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_store/Auth/otp_screen.dart';
import 'package:panda_store/Services/otp.dart';

import '../Constant/AppColor.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text('Forgot Password',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                SizedBox(height: 20,),
                Text('Please, enter your email address. You will receive a link to create a new password via email.'),
                SizedBox(height: 30,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'your Email',

                      border: OutlineInputBorder(

                      ),

                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.AppColors),
                          borderRadius: BorderRadius.circular(14)
                      )
                  ),


                ),
                SizedBox(height: 15,),



                SizedBox(height: 15,),
                Container(
                  width: double.infinity,

                  child: MaterialButton(
                    onPressed: ()async{
                      try{
                        await OTPService.sendResetCode(_emailController.text);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => OTPScreen(email: _emailController.text,))
                        );
                      }catch(err){

                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Send',style:TextStyle(color: Colors.white,fontSize: 20) ,),
                    ),
                    color: AppColor.AppColors,


                  ),
                ),





              ],
            ),
          ),
        ),
      ),
    );
  }
}
