import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_f/constants.dart';
import 'package:tiktok_clone_f/models/video.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController{

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath, quality: VideoQuality.MediumQuality,);
    return compressedVideo!.file;
  }
  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath,quality:100);
    return thumbnail;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String songName,String caption,String videoPath)async{
    try{
      String uid=firebaseAuth.currentUser!.uid;//got uid of current user
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();//got all data of current user
      var allDocs=await firestore.collection('videos').get();//got all the videos
      //int len=allDocs.docs.length;
      String videoId=const Uuid().v1();//this we will use as our video id
      String videoUrl=await _uploadVideoToStorage('Video $videoId',videoPath);//got downloadurl from storage
      String thumbnail=await _uploadImageToStorage('Video $videoId',videoPath);//downloadurl of thumbnail
      Video video = Video(username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $videoId",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );//made video model's object//now put on firebase collection
      await firestore.collection('videos').doc('Video $videoId').set(video.toJson(),);
      Get.snackbar('Success', 'Video uploaded successfully',);
      Get.back();
    }catch (e) {
      Get.snackbar('Error Uploading Video', e.toString(),);
    }
  }
}