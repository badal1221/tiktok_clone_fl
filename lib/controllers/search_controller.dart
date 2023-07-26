import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_f/constants.dart';
import 'package:tiktok_clone_f/models/user.dart';

class SearchControllerr extends GetxController{
  final Rx<List<User>> _searchedUsers=Rx<List<User>>([]);//an observable private variable

  List<User> get searchedUsers=>_searchedUsers.value;//getter for observable var

  searchUser(String typedUser){
    _searchedUsers.bindStream(
        firestore.collection('users').where('name',isGreaterThanOrEqualTo:typedUser).snapshots()
        .map((QuerySnapshot query){
          List<User> retVal=[];
          for(var element in query.docs){
            retVal.add(User.fromSnap(element));
          }
          return retVal;
        })
    );
  }
}