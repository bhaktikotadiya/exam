import 'dart:io';

import 'package:exam/page2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main()
{
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,home: adding(),
    ));
}
class adding extends StatefulWidget {
  // const adding({super.key});
  static Database? database;

  Map? l;
  adding([this.l]);

  @override
  State<adding> createState() => _addingState();
}

class _addingState extends State<adding> {

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  final ImagePicker picker = ImagePicker();

  String type="";
  String new_image="";
  String city="surat";
  XFile? image;
  bool t=false;

  bool er_name=false;
  bool er_email=false;
  bool er_contact=false;
  bool er_password=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
    if(widget.l!=null)
      {
        t1.text=widget.l!['name'];
        t2.text=widget.l!['contact'];
        t3.text=widget.l!['email'];
        t4.text=widget.l!['password'];
        type=widget.l!['gender'];
        city=widget.l!['city'];
        new_image=widget.l!['image'];
        setState(() { });
      }
  }

  get()
  async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo16.db');

// Delete the database
//     await deleteDatabase(path);

// open the database
    adding.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT, email TEXT, password TEXT, gender TEXT, city TEXT ,image TEXT)');
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("INSERT DATA"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Column(children: [
          TextField(
            controller: t1,
            decoration: InputDecoration(
              hintText: "Enter name",
              errorText: (er_name)?"name":null,
            ),
          ),
          Text(""),
          TextField(
            controller: t2,
            decoration: InputDecoration(
              hintText: "Enter contact",
              errorText: (er_contact)?"contact":null,
            ),
          ),
          Text(""),
          TextField(
            controller: t3,
            decoration: InputDecoration(
              hintText: "Enter email",
              errorText: (er_email)?"email":null,
            ),
          ),
          Text(""),
          TextField(
            controller: t4,
            decoration: InputDecoration(
              hintText: "Enter password",
              errorText: (er_password)?"password":null,
            ),
          ),
          Text(""),
          Row(children: [
            Text("GENDER : "),
            Radio(value: "male", groupValue: type, onChanged: (value) {
              type=value!;
              setState(() { });
            },),
            Text("male"),
            Radio(value: "female", groupValue: type, onChanged: (value) {
              type=value!;
              setState(() { });
            },),
            Text("female"),
          ],),
          Row(children: [
            DropdownButton(value: city,items: [
              DropdownMenuItem(child: Text("surat"),value: "surat",),
              DropdownMenuItem(child: Text("vadodara"),value: "vadodara",),
              DropdownMenuItem(child: Text("rajkot"),value: "rajkot",),
              DropdownMenuItem(child: Text("amreli"),value: "amreli",),
              DropdownMenuItem(child: Text("bhavanagar"),value: "bhavanagar",),
              DropdownMenuItem(child: Text("junagadh"),value: "junagadh",),
            ], onChanged: (value) {
              city=value!;
              setState(() { });
            },)
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            Container(
              height: 300,
              width: 300,
              // color: Colors.black,
              child: (t)?(image!="")?Image.file(fit: BoxFit.fill,File(image!.path)):null:(new_image!="")?Image.file(File(new_image!)):null,
            ),
            ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text("CHOOSE ANY ONE"),
                  actions: [
                    TextButton(onPressed: () async {
                      image = await picker.pickImage(source: ImageSource.camera);
                      t=true;
                      Navigator.pop(context);
                      setState(() { });
                    }, child: Text("Camera")),
                    TextButton(onPressed: () async {
                      image = await picker.pickImage(source: ImageSource.gallery);
                      t=true;
                      Navigator.pop(context);
                      setState(() { });
                    }, child: Text("Gallery"))
                  ],
                );
              },);
            }, child: Text("Image choose")),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            ElevatedButton(onPressed: () {

              String name,contact,email,password;
              name=t1.text;
              contact=t2.text;
              email=t3.text;
              password=t4.text;

              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
              RegExp regExp1 = new RegExp(patttern);

              String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(p);

              if(name=="")
                {
                  er_name=true;
                }
              if(contact=="" || !regExp1.hasMatch(contact))
                {
                  er_contact=true;
                }
              else
                {
                  er_contact=false;
                }
              if(email.trim()=="" || !regExp.hasMatch(email.trim()))
                {
                  er_email=true;
                }
              else
                {
                  er_email=false;
                }
              if(password=="")
                {
                  er_password=true;
                }


              if(!er_name && !er_contact && !er_email && !er_password)
                {
                  if(widget.l!=null)
                  {
                    String qry = "update user set name='$name',contact='$contact',email='$email',password='$password',gender='$type',city='$city',image='${image!.path}' where id='${widget.l!['id']}'";
                    adding.database!.rawUpdate(qry);
                    // setState(() { });
                  }
                  else
                  {
                    String qry = "INSERT INTO user(id,name,contact,email,password,gender,city,image) VALUES (null,'$name','$contact','$email','$password','$type','$city','${image!.path}')";
                    adding.database!.rawInsert(qry);
                    print("insert=${qry}");
                    // setState(() { });
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return view_page();
                  },));
                    setState(() { });
                }
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return view_page();
              // },));

              setState(() { });
            }, child: Text("Add")),
            ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return view_page();
                },));
            }, child: Text("view")),
          ],)
        ]),
      ),
    );
  }
}
