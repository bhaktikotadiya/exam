import 'dart:io';

import 'package:exam/page1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main()
{
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,home: view_page(),
    ));
}
class view_page extends StatefulWidget {
  const view_page({super.key});

  @override
  State<view_page> createState() => _view_pageState();
}

class _view_pageState extends State<view_page> {

  List<Map> l = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get1();
  }

  get1()
  {
    String qry = "SELECT * FROM user";
    adding.database!.rawQuery(qry).then((value) {
      l=value;
      print(l);
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("view"),
          backgroundColor: Colors.lightBlue.shade200,
        ),
        body: ListView.builder(
          itemCount: l.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text("${l[index]['name']}"),
                subtitle: Text("${l[index]['contact']}"),
                leading: CircleAvatar(backgroundImage: FileImage(File(l[index]['image']))),
                trailing: Wrap(alignment: WrapAlignment.spaceEvenly,children: [
                  IconButton(onPressed: () {
                    String qry = "DELETE FROM user WHERE id= '${l[index]['id']}'";
                    adding.database!.rawDelete(qry);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return view_page();
                    },));
                    setState(() { });
                  }, icon: Icon(Icons.delete)),
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return adding(l[index]);
                    },));
                  }, icon: Icon(Icons.edit)),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
