import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PickedFile> _imageFileList;
  List<PickedFile> _imageFileList2;
  ImagePicker _picker;

  @override
  void initState() {
    _imageFileList = [];
    _imageFileList2 = [];
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.black],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text(
            "Dynamic ScrollView",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(children: [
          Center(
            child: Container(
              child: Text(
                "Scroll Up to open Bottom Sheet",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.30,
            minChildSize: 0.15,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: bottomSheet(),
              );
            },
          ),
        ]),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(
          children: [
            Container(
              height: 200,
              child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return index <= _imageFileList.length - 1
                        ? InkWell(
                            onTap: () async {
                              // upload the pick
                              PickedFile file = await _picker.getImage(
                                  source: ImageSource.gallery);
                              if (file != null) {
                                _imageFileList.removeAt(index);
                                _imageFileList.insert(index, file);
                                setState(() {});
                              }
                            },
                            child: _imageFileList[index] != null
                                ? Container(
                                    width: 150,
                                    height: 200,
                                    padding: EdgeInsets.all(5),
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(
                                    //         width: isInView ? 5 : 0,
                                    //         color: isInView
                                    //             ? Colors.white
                                    //             : Colors.black),
                                    //     borderRadius: BorderRadius.all(
                                    //         Radius.circular(10))),
                                    margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.file(
                                        File(_imageFileList[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(),
                          )
                        : InkWell(
                            onTap: () async {
                              // upload the pick
                              PickedFile file = await _picker.getImage(
                                  source: ImageSource.gallery);

                              if (file != null)
                                setState(() {
                                  _imageFileList.add(file);
                                });
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: DottedBorder(
                                color: Colors.white,
                                radius: Radius.circular(15),
                                child: Container(
                                  width: 150,
                                  height: 200,
                                  child: Center(
                                      child: Text(
                                    "+ upload pic",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ));
                  }),
            ),
            Container(
              width: 250,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(bottom: 50),
              child: InViewNotifierList(
                  isInViewPortCondition:
                      (double deltaTop, double deltaBottom, double vpHeight) {
                    return deltaTop < (vpHeight / 2) &&
                        deltaBottom > (vpHeight / 2);
                  },
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  builder: (context, index) {
                    return index <= _imageFileList2.length - 1
                        ? InViewNotifierWidget(
                            id: '$index',
                            builder: (BuildContext context, bool isInView,
                                Widget child) {
                              return InkWell(
                                onTap: () async {
                                  // upload the pick
                                  PickedFile file = await _picker.getImage(
                                      source: ImageSource.gallery);
                                  if (file != null) {
                                    _imageFileList2.removeAt(index);
                                    _imageFileList2.insert(index, file);
                                    setState(() {});
                                  }
                                },
                                child: _imageFileList2[index] != null
                                    ? Container(
                                        width: 200,
                                        height: 200,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: isInView ? 5 : 0,
                                              color: isInView
                                                  ? Colors.white
                                                  : Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        margin:
                                            EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image.file(
                                            File(_imageFileList2[index].path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              );
                            })
                        : InkWell(
                            onTap: () async {
                              // upload the pick
                              PickedFile file = await _picker.getImage(
                                  source: ImageSource.gallery);

                              if (file != null)
                                setState(() {
                                  _imageFileList2.add(file);
                                });
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: DottedBorder(
                                color: Colors.white,
                                radius: Radius.circular(15),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                      child: Text(
                                    "+ upload pic",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ));
                  }),
            ),
          ],
        ));
  }
}
