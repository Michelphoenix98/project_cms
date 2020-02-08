import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_cms/custom_data_table.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'calendar_widget.dart';
import 'package:project_cms/custom_data_table.dart' ;
import 'dart:async';
class MarkAttendancePage extends StatefulWidget{
  DocumentSnapshot docs;
  MarkAttendancePage(this.docs);
  MarkAttendancePageState createState()=> MarkAttendancePageState(docs,this);
 var activeState;

}


class MarkAttendancePageState extends State<MarkAttendancePage>{
  Set<dynamic> absentees;
  var day;
  var month;
  var year;
  var currentDate1="${DateTime.now().day}"+"-"+"${DateTime.now().month}"+"-"+"${DateTime.now().year}";
  var mainWidget;
  var _value;
  var _choseHour=Text("Hour");
  DocumentSnapshot docs;
  MarkAttendancePageState(this.docs,this.mainWidget){
    mainWidget.activeState=this;
    absentees=Set<dynamic>();
  }
  void setDate(String date) {
    setState(() {
      currentDate1 = date;
    });
  }
  Widget populateList(){
    CustomDataRow row;
    List<CustomDataRow> _rowList = <CustomDataRow>[];
    var n=docs.data.length;
    var i=0;
    final List<CustomDataColumn> _columnList = [
      new CustomDataColumn(label: Text("Roll")),
      new CustomDataColumn(label: Text("Name")),

    ];

    Map<dynamic, dynamic> map = docs.data["enrolled"];
    List<dynamic> studentRolls= map.keys.toList();
    //absentees=studentRolls.toSet();
    for(String field in studentRolls) {
      Map<dynamic, dynamic> subMap = map[field];
      print(subMap.keys);
      print(map.keys);

      var attendance=100*((subMap["hoursAttended"])/(docs.data["totalHoursTaken"]));
      _rowList.add(
          row=CustomDataRow(
            idTag: field,
            selected: true,
onSelectChanged: (selected,[idTag]){
//print(selected);
//print(idTag);
if(selected) {
  absentees.remove(idTag+"\n"+subMap["name"]);
 // print(absentees);
}
else {
  if(idTag!=null)
  absentees.add(idTag+"\n"+subMap["name"]);
  //print(absentees);
}
},
        cells: [
          CustomDataCell(

            Row(

              children: <Widget>[
                Icon(Icons.account_circle),
                Text(subMap["roll"],style:TextStyle(
                  ))
              ],
            ),
onTap: null,

          ),
          CustomDataCell(Text(subMap["name"],style:TextStyle(
            )),

          ),

        ],
      ));
    }
    return

Flexible(
fit:FlexFit.loose,
        child :SingleChildScrollView(
            child:CustomDataTable(
          onSelectAll: (selected){

          },
          rows: _rowList,
          columns: _columnList,

        )));



  }
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
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
              children:<Widget>[new Container(

                margin: const EdgeInsets.only(left:30.0,top: 30,bottom: 30),
                padding: const EdgeInsets.only(left: 60,right:60,top: 10,bottom: 10),
                decoration: BoxDecoration(
                   // color: Colors.grey,
                    border: Border.all(color: Colors.grey)

                ),
                child: Text(currentDate1!=null?"$currentDate1":"${DateTime.now().day}"+"-"+"${DateTime.now().month}"+"-"+"${DateTime.now().year}",style: TextStyle(fontSize: 22),),
              ),
              IconButton(icon: Icon(Icons.calendar_today,color: Colors.green,), onPressed: ()async {

                final date= await chooseDate(context);
                print(date);
                this.setDate(date!=null?date:"${DateTime.now().day}"+"-"+"${DateTime.now().month}"+"-"+"${DateTime.now().year}");

              },

              ),

              ]
              ),

              Container(

                  margin: const EdgeInsets.only(left:30.0,top: 10,bottom: 30),
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),

                ),
              child:new DropdownButton<String>(
                items: <String>['0','1', '2', '3', '4','5','6','7','8'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),

                onChanged: (_) {
                  setState(() {
                    _value = _;
                  });
                },
                value: _value,
                hint: _choseHour,

              )),
 populateList(),
Row(
  mainAxisAlignment: MainAxisAlignment.end,
children:[
  FlatButton(
  color: Colors.blue,
  splashColor: Colors.blueAccent,
  child: new Text("Submit",style: TextStyle(color: Colors.white),),
  onPressed: () async{

 if(_value==null) {
   setState(() {
_choseHour=new Text("Hour",style: TextStyle(color: Colors.red),);
   });
 }else{
    //show a confirmation dialog box
    //check if the write operation is in compliance with the system
    //by checking if this date and hour had been already entered ie updation is not possible.
    //
   bool isConfirmed=false;
if(absentees.isNotEmpty){
    List absenteeList=absentees.toList();
    absenteeList.sort();

    isConfirmed=
    await showDialog(
    context: context,
    builder:(BuildContext context){
    return AlertDialog(
    actions: <Widget>[
    new RaisedButton(
    color: Colors.blue,
    splashColor: Colors.blueAccent,
    child:new Text("Confirm",style: TextStyle(
    color:Colors.white
    ),),
    onPressed: (){

    Navigator.of(context).pop(true);
    }),
    ],
    title: new Text("Absentees"),
    content:


Container(

    child:new ListView.separated(
     shrinkWrap : true,
    itemCount: absentees.length,
    separatorBuilder: (para1,para2)=>Divider(),
    itemBuilder: (_,i){

    return ListTile(
    title:

    new Text((absenteeList)[i]),


    );
    },
    /*  children: absentees.map((field){
               return ListTile(
                 title:
                     new Text(field),




               );
             }).toList(),*/

    )),



    );
    },
    );
    }
else{
  isConfirmed=
  await showDialog(
    context: context,
    builder:(BuildContext context){
  return AlertDialog(

        actions: <Widget>[
          new RaisedButton(
              color: Colors.blue,
              splashColor: Colors.blueAccent,
              child:new Text("Confirm",style: TextStyle(
                  color:Colors.white
              ),),
              onPressed: (){

                Navigator.of(context).pop(true);
              }),
        ],
        content:Container(child:Column(
          mainAxisSize: MainAxisSize.min,
        children:[
          Center(
            child: Text("Absentees"),
          ),
       SizedBox(height:20),
       Center(
      child: Text("No absentees today"),
       )

      ])));
    },
  );
}
   if(isConfirmed!=null||isConfirmed==true)
     Navigator.of(context).pop((){
       dispose();
     });
   print(absentees);
   print(_value);
   print(currentDate1);
 }



  },
)]
)
            ],
          )
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
}
class AttendancePage extends StatefulWidget{
  DocumentSnapshot docs;
  AttendancePage(this.docs);
  AttendancePageState createState()=> AttendancePageState(docs);
}
class AttendancePageState extends State<AttendancePage>{
  DocumentSnapshot docs;
  AttendancePageState(this.docs);
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
          body:SingleChildScrollView(child:populateList())
      ),
    );
  }
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
  Widget populateList(){
    List<CustomDataRow> _rowList = <CustomDataRow>[];
    var n=docs.data.length;
    var i=0; //how does this work??
    final List<CustomDataColumn> _columnList = [
      new CustomDataColumn(label: Text("Roll")),
      new CustomDataColumn(label: Text("Name")),
      new CustomDataColumn(label: Text("Attendance")),
    ];

      Map<dynamic, dynamic> map = docs.data["enrolled"];
      List<dynamic> studentRolls= map.keys.toList();
      for(String field in studentRolls) {
        Map<dynamic, dynamic> subMap = map[field];
//print(subMap.keys);
       // print(map.keys);

var attendance=100*((subMap["hoursAttended"])/(docs.data["totalHoursTaken"]));
        _rowList.add(CustomDataRow(


          cells: [
            CustomDataCell(

              Row(

                children: <Widget>[
                  Icon(Icons.account_circle),
                  Text(subMap["roll"],style:TextStyle(
                    color: (attendance < 75) ? Colors.red : Colors
                        .lightGreen,))
                ],
              ),
              idTag: i,
              onTap: (code2) {
                print("Here I am!!!");
                print("code2=$code2");
                print((docs.data["department"]).toLowerCase()+"_"+(docs.data["code"].toLowerCase()));
                print(subMap["roll"]);
                _pushPage(context, IndividualAttendance(subMap["roll"],(docs.data["department"]).toLowerCase()+"_"+(docs.data["code"].toLowerCase())));
              },

            ),
            CustomDataCell(Text(subMap["name"],style:TextStyle(
              color: (attendance < 75) ? Colors.red : Colors
                  .lightGreen,)),

            ),
            CustomDataCell(Text("${attendance}%", style: TextStyle(
              color: (attendance < 75) ? Colors.red : Colors
                  .lightGreen,))),
          ],
        ));
        i++;
      }
    return  Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

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
}
class IndividualAttendance extends StatefulWidget{
  String roll;
  String course;
  IndividualAttendance(this.roll,this.course);
  IndividualAttendanceState createState()=> IndividualAttendanceState(roll,course);
}
class IndividualAttendanceState extends State<IndividualAttendance>{
  String roll;
  String course;
  IndividualAttendanceState(this.roll,this.course);
  bool containsAbsence=false;
  Future<DocumentSnapshot> getRecord() async{
    final doc=Firestore.instance.document("Courses/$course/Registered/$roll/");
return await doc.get().then((DocumentSnapshot snapshot){
  //print( snapshot.data["roll"]);
  if((snapshot.data.keys).contains("dates"))
    containsAbsence=true;
  return snapshot;
});
  //  print(course);
}
  Widget build(BuildContext context){
    List<CustomDataRow> _rowList = <CustomDataRow>[];
    print(course);
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
        body:FutureBuilder(
          future: getRecord(),
          builder: (_,snapShot){
            if(snapShot.connectionState==ConnectionState.waiting){
              return Center(
                  child: CircularProgressIndicator()
              );
            }
            else {

              if (containsAbsence) {
                final List<CustomDataColumn> _columnList = [
                  new CustomDataColumn(label: Text("Date")),
                  new CustomDataColumn(label: Text("Hour")),
                  // new CustomDataColumn(label: Text("Attendance")),
                ];
                //return Text("${snapShot.data["roll"]}");
                List<dynamic> array = snapShot.data["dates"];

                for (Map<dynamic, dynamic> field in array) {
                  Map<dynamic, dynamic> date = field;
                  _rowList.add(CustomDataRow(


                    cells: [
                      CustomDataCell(

                        Row(

                          children: <Widget>[

                            Text(date["date"])
                          ],
                        ),


                      ),
                      CustomDataCell(Text(date["hour"])

                      ),

                    ],
                  ));
                }


                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    //  _dataTabl
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,

                        child:

                        SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CustomDataTable(
                          rows: _rowList,
                          columns: _columnList,

                        ))
                    ),
                  ],

                );
              }
              else{
                return Center(child: Text("No absence so far"));
              }
            }

          },
        ),
      ),
    );
  }

}