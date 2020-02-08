import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_cms/attendance_options.dart';
import 'package:project_cms/course_page.dart';
import 'package:project_cms/custom_data_table.dart';
class StaffLogin extends StatefulWidget{
  QuerySnapshot doc;
  StaffLogin(this.doc);
  @override
  StaffLoginState createState()=>StaffLoginState(doc);
}
class StaffLoginState extends State<StaffLogin>{
  QuerySnapshot doc;
  StaffLoginState(this.doc);
  Stream getCurrentlyAssignedCourses() {

    final String roll = (doc.documents[0].data["roll"]);
    final dbRef = Firestore.instance.collection("Courses");
    final snap =  dbRef
        .where("staffAssigned", isEqualTo: roll)
        .snapshots();
    return snap;
  }
  Widget build(BuildContext context){
    final String role = (doc.documents[0].data["role"]);
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
        body: StreamBuilder<QuerySnapshot> (
          stream: getCurrentlyAssignedCourses(),
          builder:(_,snapShot){
            if(snapShot.connectionState==ConnectionState.waiting){
              return Center(
                  child: CircularProgressIndicator()
              );
            }
            else{



              List<CustomDataRow> _rowList = <CustomDataRow>[];
              var i = 0;
              var n = snapShot.data.documents.length;
if(snapShot.data.documents.isNotEmpty){
  final List<CustomDataColumn> _columnList = [
    new CustomDataColumn(label: Text("Course Code")),
    new CustomDataColumn(label: Text("Course Name")),
    new CustomDataColumn(label: Text("Average Attendance")),
  ];
  while (i < n) {
    var averageAttendance=0.0;
    Map<dynamic, dynamic> map = snapShot.data.documents[i].data["enrolled"];
    List<dynamic> studentRolls= map.keys.toList();
    for(String field in studentRolls){
    Map<dynamic, dynamic> subMap = map[field];
    var attendance = 100 *
        ((subMap["hoursAttended"]) /
            (snapShot.data.documents[i].data["totalHoursTaken"]));
    averageAttendance=averageAttendance+attendance;
    }
    averageAttendance=averageAttendance/snapShot.data.documents[i].data["activeStudents"];
    _rowList.add(CustomDataRow(


      cells: [
        CustomDataCell(

       Container(
         padding: EdgeInsets.only(left:10,right:10,top:10,bottom: 10),
         decoration: BoxDecoration(
           color: Colors.lightBlue,

         ),

            child:Row(

            children:<Widget>[Icon(Icons.book,color: Colors.white,),Text(snapShot.data.documents[i].data["code"],style: TextStyle(color: Colors.white),)],
            )),
          idTag:i ,

          onTap: (code){
              print("code=$code");
              print("i=$i");
            _pushPage(context, CoursePage(snapShot.data.documents[code]));

          },


        ),
        CustomDataCell(Text(snapShot.data.documents[i].data["name"]),

        ),
        CustomDataCell(Text("$averageAttendance%",style: TextStyle(color:(averageAttendance<75)?Colors.red:Colors.lightGreen,))),
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
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,

      child:CustomDataTable(
        rows: _rowList,
        columns: _columnList,

      )
      ),
    ],

  );
}
else{
  return Center(
      child:Text("No course details available")
  );
}
            }
          }
        ),
      ),
    );
  }
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
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}