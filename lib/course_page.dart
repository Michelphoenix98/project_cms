import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_cms/attendance_options.dart';
import 'calendar_widget.dart';
class CoursePage extends StatefulWidget{
  int i;

   DocumentSnapshot snapshot;
   CoursePage(this.snapshot);
  CoursePageState createState()=>CoursePageState(snapshot);
}
class CoursePageState extends State<CoursePage>{
  var _chosenDate=DateTime.now();
  DocumentSnapshot snapshot;
  int i;
  CoursePageState(this.snapshot);
  Widget build(BuildContext context){
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
          body:Center(child:choiceMenu()),
        ),
    );
  }
  Future<String> chooseDate(BuildContext context) async{
var calendar=Calendar();


    String date='';


    return await showDialog<String>(
      context:context,
      builder:(BuildContext context){
        return  AlertDialog(

          content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:300,
                maxWidth: 300,
              ),
              child:calendar),
          actions: <Widget>[
            RaisedButton(
              splashColor: Colors.blueAccent,
              child:Text("Proceed",style: TextStyle(color: Colors.white),),
              onPressed: (){

                date="${calendar.activeState.calendarCarouselWidget.selectedDateTime.day}"+"-"+
                    "${calendar.activeState.calendarCarouselWidget.selectedDateTime.month}"+"-"+"${calendar.activeState.calendarCarouselWidget.selectedDateTime.year}";
                Navigator.of(context).pop(date);
                //  dispose();
              },
            )
          ],);},
    );


  }
  Widget choiceMenu(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

  Text("${snapshot.data["code"]}",style:TextStyle(fontSize: 32,fontFamily: "JH")),
        Text("${snapshot.data["name"]}",style:TextStyle(fontSize: 32,fontFamily: "JH")),
        Spacer(),

        Center(
          child:
        Table(
         // border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          defaultColumnWidth: FractionColumnWidth(0.7),
          children:[
      TableRow(

          children: [Text("Currently Enrolled:",style:TextStyle(fontSize: 22,)),
            Text("${snapshot.data["activeStudents"]}",style:TextStyle(fontSize: 22,))]),
        TableRow(

            children:[
          Text("Average Attendance:",style:TextStyle(fontSize: 22,color:snapshot.data["averageAttendance"]>=75?Colors.green:Colors.red)),
          Text("${snapshot.data["averageAttendance"]}%",style:TextStyle(fontSize: 22,color:snapshot.data["averageAttendance"]>=75?Colors.green:Colors.red))]),
        TableRow(children:[Text("Total hours taken:",style:TextStyle(fontSize: 22,)),
          Text("${snapshot.data["totalHoursTaken"]}",style:TextStyle(fontSize: 22,)),
        ]),
        TableRow(
            children:[Text("Department:",style:TextStyle(fontSize: 22,)),
          Text("${snapshot.data["department"]}",style:TextStyle(fontSize: 22,))
        ]),
    ],
        )),
        Spacer(),
        FlatButton(

         child:Row(
           mainAxisAlignment: MainAxisAlignment.center,
           mainAxisSize: MainAxisSize.min,
           children: <Widget>[
             Icon(Icons.event_available,color: Colors.green,size: 55,),Text("Mark Attendance",style: TextStyle(fontSize: 32,),),
           ],
         ),
         onPressed: ()async {
           final temp=MarkAttendancePage(snapshot);
       _pushPage(context, temp);
       final date= await chooseDate(context);
       print(date);
       temp.activeState.setDate(date);

         },
       ),
        SizedBox(
          height: 60,
        ),
        FlatButton(

          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.remove_red_eye,color: Colors.blue,size:55),Text("View Attendance",style: TextStyle(fontSize: 32,),),
            ],
          ),
          onPressed: (){
            _pushPage(context, AttendancePage(snapshot));
          },
        ),
        Spacer()
      ],
    );
  }
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}