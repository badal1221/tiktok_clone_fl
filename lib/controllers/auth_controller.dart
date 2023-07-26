import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone_f/constants.dart';
import 'package:tiktok_clone_f/models/user.dart' as model;
import 'package:tiktok_clone_f/views/screens/auth/login_screen.dart';
import '../views/screens/home_screen.dart';

class AuthController extends GetxController{
  static AuthController instance=Get.find();
  late Rx<User?> _user;//firebase auth User
  late Rx<File?> _pickedImage;
  File? get profilePhoto=>_pickedImage.value;

  User get user=>_user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }
  _setInitialScreen(User? user){
    if(user==null){
      Get.offAll(()=>LoginScreen());
    }else{
      Get.offAll(()=>const HomeScreen());
    }
  }

  void pickImage()async{
    final pickedImage=await ImagePicker().pickImage(source:ImageSource.gallery);
    if(pickedImage!=null){
      Get.snackbar('Profile Picture','You have successfully selected your Profile picture');
    }
    _pickedImage=Rx<File>(File(pickedImage!.path));
  }

  Future<String> _uploadStorage(File image)async{
    Reference ref=firebaseStorage.ref().child('profilePics').child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask=ref.putFile(image);
    TaskSnapshot snap=await uploadTask;
    String downloadUrl=await snap.ref.getDownloadURL();
    return downloadUrl;
  }
   //registring user
  void registerUser(String userName,String email,String password,File? image)async{
    try{
      if(userName.isNotEmpty && email.isNotEmpty&&password.isNotEmpty && image!=null){
        //save user to firebase firestore
        UserCredential cred=await firebaseAuth.createUserWithEmailAndPassword(email: email,
            password: password);//got data from auth
        String downloadUrl=await _uploadStorage(image);
        model.User user=model.User(name: userName, email: email, uid: cred.user!.uid, profilePhoto:downloadUrl);
        await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      }else{
        Get.snackbar('Error Creating Account',
            'Please Enter all the fields');
      }
    }catch(e){
      Get.snackbar('Error Creating Account',e.toString());
    }
  }
  void loginUser(String email,String password)async{
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      }else{
        Get.snackbar('Error Logging into Account',
            'Please Enter all the fields');
      }
    }catch(e){
      Get.snackbar('Error Logging into Account',e.toString());
    }
  }
  signOut()async{
    await firebaseAuth.signOut();
  }
}