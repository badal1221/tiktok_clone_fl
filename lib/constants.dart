import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone_f/controllers/auth_controller.dart';
import 'package:tiktok_clone_f/views/screens/add_video_screen.dart';
import 'package:tiktok_clone_f/views/screens/profile_screen.dart';
import 'package:tiktok_clone_f/views/screens/search_screen.dart';
import 'package:tiktok_clone_f/views/screens/video_screen.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  const Text('Messages Screen'),
  ProfileScreen(uid:authController.user.uid),
];

//Colors
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//Firebase
var firebaseAuth=FirebaseAuth.instance;
var firebaseStorage=FirebaseStorage.instance;
var firestore=FirebaseFirestore.instance;


//Controller
var authController=AuthController.instance;