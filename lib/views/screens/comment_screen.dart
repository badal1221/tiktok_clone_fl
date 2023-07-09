import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_f/constants.dart';
import 'package:tiktok_clone_f/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({Key? key,required this.id}) : super(key: key);

  final TextEditingController _commentController=TextEditingController();
  CommentController commentController=Get.put(CommentController());


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    commentController.updatePostId(id);
    return Scaffold(
      appBar: AppBar(
        title:Text('Comments'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width:size.width,
          height: size.height-90,
          child: Column(
            children: [
              const SizedBox(height:5,),
              Expanded(
                child: Obx(() {
                    return ListView.builder(
                    itemCount:commentController.comments.length,
                    itemBuilder:(context,index){
                      final comment=commentController.comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(comment.profilePhoto),////
                      ),
                      title: Row(
                        children: [
                          Text('${comment.username}  ',style:const TextStyle(
                            fontSize: 20,
                              color: Colors.red,
                            fontWeight: FontWeight.w700
                          ),),
                          Text(comment.comment,style:const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                          ),),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(tago.format(comment.datePublished.toDate()),style:const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                          ),),
                          const SizedBox(width: 10,),
                          Text('${comment.likes.length} likes',style:const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),),
                        ],
                      ),
                      trailing: InkWell(
                        onTap: ()=>commentController.likeComment(comment.id),
                        child:Icon(Icons.favorite,
                          size: 20,
                          color:comment.likes.contains(authController.user.uid)?Colors.red:Colors.white,),
                      ),
                    );
              },
              );
                  }
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10).copyWith(top: 0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    title: TextFormField(
                      controller: _commentController,
                      style:const TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),
                      decoration:const InputDecoration(
                        border: InputBorder.none,
                        hintText:'Comment',
                        hintStyle:TextStyle(fontSize: 15,
                            color: Colors.white,
                        ),
                      ),
                    ),
                    trailing:TextButton(
                      onPressed:(){
                        commentController.postComment(_commentController.text);
                        _commentController.clear();
                        },
                      child: const Text('Send',style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
