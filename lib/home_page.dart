import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  QuerySnapshot doc;
  HomePage(this.doc);
  @override
  HomePageState createState() => HomePageState(doc);
}

class HomePageState extends State<HomePage> {
  QuerySnapshot doc;
  HomePageState(this.doc);
  @override
  Stream getCurrentlyEnrolledCourses() {

    final String roll = (doc.documents[0].data["roll"]);
    final dbRef = Firestore.instance.collection("Courses");
    final snap =  dbRef
        .where("enrolled.$roll.roll", isEqualTo: roll)
        .snapshots();
 return snap;
  }
  Widget build(BuildContext){
    final String role = (doc.documents[0].data["role"]);
    return MaterialApp(
     home:
     Scaffold(
         appBar: AppBar(
           actions: <Widget>[
             IconButton(icon: Icon(Icons.list)),
           ],
           title: Center(child: Text('Attendance Companion')),
           flexibleSpace: Container(
             decoration: new BoxDecoration(
               gradient: new LinearGradient(
                   colors: [
                     const Color(0xFFFF6919),
                     const Color(0xFFFF9700),
                   ],
                   begin: const FractionalOffset(0.0, 0.0),
                   end: const FractionalOffset(1.0, 0.0),
                   stops: [0.0, 1.0],
                   tileMode: TileMode.clamp),
             ),
           ),
         ),
         body: StreamBuilder<QuerySnapshot>(
      stream: getCurrentlyEnrolledCourses(),
      builder: (_,snapShot){
        if(snapShot.connectionState==ConnectionState.waiting){
         return Center(
          child: CircularProgressIndicator()
         );
        }
        else {
          if (snapShot.data.documents.isNotEmpty) {
            List<DataRow> _rowList = <DataRow>[];
            var i = 0;
            var n = snapShot.data.documents.length;
            final String roll = (doc.documents[0].data["roll"]);
            final List<DataColumn> _columnList = [
              new DataColumn(label: Text("Courses")),
              new DataColumn(label: Text("Attendance"))
            ];

            while (i < n) {
              Map<dynamic, dynamic> map = snapShot.data.documents[i].data["enrolled"];
              Map<dynamic, dynamic> subMap = map["$roll"];
              var attendance = 100 *
                  ((subMap["hoursAttended"]) /
                      (snapShot.data.documents[i].data["totalHoursTaken"]));
              _rowList.add(DataRow(
                cells: [
                  DataCell(Text(snapShot.data.documents[i].data["code"])),
                  DataCell(Text("$attendance%")),
                ],
              ));
              i++;
            }

          return  Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    rankIcon(role),
                    Text(
                      role,
                      style: TextStyle(fontSize: 30, fontFamily: 'JH'),
                    ),
                  ],
                ),
                //  _dataTabl
                DataTable(
                  rows: _rowList,
                  columns: _columnList,
                )
              ],

        );

          }
          else{
            return Center(
              child:Text("No course details available")
            );
          }
        }
      },
    )
    ),
    );
  }
  /*Widget build(BuildContext context) {

    final String role = (doc.documents[0].data["role"]);

    final List<DataColumn> _columnList = [
      new DataColumn(label: Text("Courses")),
      new DataColumn(label: Text("Attendance"))
    ];
    List<DataRow> _rowList = <DataRow>[];

    snap.then((QuerySnapshot snapShot)  {
      if (snapShot.documents.isNotEmpty) {
        var i = 0;


        snapShot.documents[i].data.keys.forEach(print);
        while (i < snapShot.documents.length) {
          Map<dynamic, dynamic> map = snapShot.documents[i].data["enrolled"];
          Map<dynamic, dynamic> subMap = map["$roll"];
          var attendance = 100 *
              ((subMap["hoursAttended"]) /
                  (snapShot.documents[i].data["totalHoursTaken"]));
          _rowList.add(DataRow(
            cells: [
              DataCell(Text(snapShot.documents[i].data["code"])),
              DataCell(Text("$attendance")),
            ],
          ));

          i++;
        }
      } else {
        ;
      }

    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list)),
          ],
          title: Center(child: Text('Attendance Companion')),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFFFF6919),
                    const Color(0xFFFF9700),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                rankIcon(role),
                Text(
                  role,
                  style: TextStyle(fontSize: 30, fontFamily: 'JH'),
                ),
              ],
            ),
            //  _dataTabl
            DataTable(
              rows: _rowList,
              columns: _columnList,
            )
          ],
        ),
      ),
    );
  }*/

  Widget rankIcon(String role) {
    if (role == 'Staff')
      return Column(
        children: <Widget>[
          Icon(Icons.star, color: Colors.orange),
          Transform.rotate(
              // transform: Transform.rotate(angle: 360.),

              angle: 3 * 3.141592654 / 2,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.orange,
              ))
        ],
      );
    else
      return Transform.rotate(
          // transform: Transform.rotate(angle: 360.),

          angle: 3 * 3.141592654 / 2,
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.orange,
          ));
  }
}
