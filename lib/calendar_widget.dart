import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
class Calendar extends StatefulWidget{
  CalendarState activeState;
  var _chosenDate;
  CalendarState createState()=> CalendarState(this);


}
class CalendarState extends State<Calendar>{
  var _chosenDate;
  var mainWidget;
  CalendarCarousel calendarCarouselWidget;
  @override
  CalendarState(this.mainWidget){
    mainWidget.activeState=this;
    _chosenDate=DateTime.now();
    calendarCarouselWidget=new CalendarCarousel(

      selectedDateTime: _chosenDate,
      onDayPressed: (DateTime date, List events) {

        setState(() {
          _chosenDate=date;

        });
      },
    );
  }

  Widget build(BuildContext context){
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 16.0),
        child:calendarCarouselWidget=new CalendarCarousel(

          selectedDateTime: _chosenDate,
          onDayPressed: (DateTime date, List events) {
            setState(() {
              _chosenDate=date;

            });
            print(" after setState has been called chosenDate="+_chosenDate);
          },
        ));
  }
}