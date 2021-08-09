import 'dart:io';

import 'package:blog_app_new/controller/blog_controller.dart';
import 'package:blog_app_new/models/blog_model.dart';
import 'package:blog_app_new/services/blog_helper.dart';
import 'package:blog_app_new/widgets/description_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddBlog extends StatefulWidget {
  final BlogModel blogModel;

  AddBlog({this.blogModel});

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  File selectedImage;
  final picker = ImagePicker();
  BlogController blogController = Get.find<BlogController>();

  bool isLoading = false;

  TextEditingController titleCon = TextEditingController();
  TextEditingController bodyCon = new TextEditingController();

  @override
  void initState() {
    if (widget.blogModel != null) {
      titleCon.text = widget.blogModel.title;
      bodyCon.text = widget.blogModel.body;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Create Blog"),
        actions: [
          GestureDetector(
            onTap: () {
              widget.blogModel != null ? updateBlog() : uploadBlog();
            },
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload)),
          )
        ],
      ),
      body: isLoading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: selectedImage != null || widget.blogModel != null
                            ? Container(
                                height: 150,
                                margin: EdgeInsets.symmetric(vertical: 24),
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    child: Image.file(
                                      selectedImage != null
                                          ? selectedImage
                                          : File(widget.blogModel.image),
                                      fit: BoxFit.fill,
                                    )),
                              )
                            : Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                margin: EdgeInsets.symmetric(vertical: 24),
                                width: MediaQuery.of(context).size.width,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      TextField(
                        controller: titleCon,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Enter title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.deepOrange[400])),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.deepOrange[400])),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.deepOrange[400],
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.deepOrange[400])),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.0),
                              borderSide: BorderSide(
                                  width: 1.0, color: Colors.transparent),
                            ),
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: Get.height * 0.4,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepOrange[400])),
                        child: Scrollbar(
                          child: DescriptionField(
                            controller: bodyCon,
                            hint: "write a blog description...",
                            maxLines: 100,
                          ),
                        ),
                      )
                    ],
                  )),
            ),
    );
  }

  Future getImage() async {
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    //
    // setState(() {
    //   if (pickedFile != null) {
    //     selectedImage = File(pickedFile.path);
    //   } else {
    //     print('No image selected.');
    //   }
    // });

    var picked;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Pick one source for image'),
            actions: [
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    setState(() {
                      if (picked != null) {
                        selectedImage = File(picked.path);
                      } else {
                        Fluttertoast.showToast(msg: 'No image selected.');
                      }
                    });
                  },
                  child: Text(
                    'Gallery',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    picked = await ImagePicker().getImage(
                      source: ImageSource.camera,
                    );
                    setState(() {
                      if (picked != null) {
                        selectedImage = File(picked.path);
                      } else {
                        Fluttertoast.showToast(msg: 'No image selected.');
                      }
                    });
                  },
                  child: Text(
                    'Camera',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))
            ],
          );
        });
  }

  Future<void> uploadBlog() async {
    if (selectedImage == null) {
      Fluttertoast.showToast(msg: "Please add blog image");
      return;
    }
    if (titleCon.text.isEmpty || bodyCon.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please write title or body");
      return;
    }
    setState(() {
      isLoading = true;
    });
    final imageBytes = await selectedImage.readAsBytes();
    BlogModel blog = BlogModel(
      image: imageBytes,
      id: DateTime.now().toIso8601String(),
      timeOfBlog: DateTime.now(),
      body: bodyCon.text,
      title: titleCon.text,
    );

    var response = await BlogHelper().addBlog(blog);
    setState(() {
      isLoading = false;
    });

    Get.back();
  }

  updateBlog() async {
    if (titleCon.text.isEmpty || bodyCon.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please write title or body");
      return;
    }
    setState(() {
      isLoading = true;
    });

    BlogModel blogModel = BlogModel();
    blogModel.body = bodyCon.text;
    blogModel.title = titleCon.text;
    blogModel.id = widget.blogModel.id;
    blogModel.timeOfBlog = widget.blogModel.timeOfBlog;

    if (selectedImage == null) {
      blogModel.image = widget.blogModel.image;
      await BlogHelper().updateBlog(blogModel, false);
    } else {
      final imageBytes = await selectedImage.readAsBytes();
      blogModel.image = imageBytes;
      await BlogHelper().updateBlog(blogModel, true);
    }

    setState(() {
      isLoading = true;
    });
    Get.back();
  }
}
