import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blog_app_new/controller/blog_controller.dart';
import 'package:blog_app_new/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BlogDetailView extends StatelessWidget {
  final BlogModel blogModel;

  BlogDetailView({this.blogModel});

  final BlogController blogController = Get.find<BlogController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Blog Detail"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: blogModel.id,
              child: Image.file(
                File(blogModel.image),
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            Divider(
              height: 2,
              thickness: 3,
              color: Colors.deepOrange[400],
            ),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      blogModel.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      blogModel.body,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "•Posted Date: ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.deepOrange[400],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat("E-d-MMM-y").format(blogModel.timeOfBlog),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
