import 'package:flutter/material.dart';
import 'package:tiktok_clone_f/controllers/auth_controller.dart';

import '../../../constants.dart';
import '../../widgets/text_input_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _userNameController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TikTok Clone',style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 35,
                color: buttonColor
            ),),
            const Text('Register',style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),),
            const SizedBox(height: 15,),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 64,
                  backgroundImage:NetworkImage('https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                  backgroundColor: Colors.black,
                ),
                Positioned(
                  bottom: -10,
                  left: 76,
                    child: IconButton(
                      onPressed:(){
                        authController.pickImage();
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(controller: _userNameController,
                labelText: 'Username',
                icon: Icons.person,),
            ),
            const SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,),
            ),
            const SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                isObscure: true,),
            ),
            const SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 50,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child:InkWell(
                onTap:()=>authController.registerUser(
                    _userNameController.text,
                    _emailController.text,
                    _passwordController.text,
                    authController.profilePhoto),
                child:const Center(
                  child: Text('Register',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                  ),),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?',style: TextStyle(fontSize: 20,),),
                InkWell(
                  onTap:(){},
                  child: Text('Login',style: TextStyle(
                      fontSize: 20,color: buttonColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
