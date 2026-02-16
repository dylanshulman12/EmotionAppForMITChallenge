import 'dart:collection';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'data.g.dart';


class Date {
  late int year ;
  late int month ;
  late int day ;
  late int hour ;

  late int days ;

  List<int> monthKey = [1,4,4,0,2,5,0,3,6,1,4,6];
  List<String> daysList = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"] ;
  List<int> daysInMonthKey = [31,28,31,30,31,30,31,31,30,31,30,31] ;

  Date() {
    DateTime now = DateTime.now() ;
    hour = now.hour;
    day = now.day;
    month = now.month;
    year = now.year;
  }

  int getYear() {
    return year ;
  }

  int getMonth() {
    return month ;
  }

  int getDay() {
    return day ;
  }

  int getHour() {
    return hour ;
  }

  void createDate() {
    DateTime now = DateTime.now() ;
    hour = now.hour;
    day = now.day;
    month = now.month;
    year = now.year;
  }

  // returns string day of week
  String getDayOfWeek() {
    int yrTwoDigit = int.parse(getYear().toString().substring(2, 3));
    // integer division in dart is ~/
    yrTwoDigit += yrTwoDigit ~/ 4 ;
    yrTwoDigit += getDay() ;
    yrTwoDigit += monthKey[getMonth()] ;

    return daysList[yrTwoDigit%7] ;
  }
}


class Info {
  late String emotion ;
  late String note = "" ;

  late Date date ;

  Info(String emot, Date d) {
    emotion = emot ;
    date = d ;
  }

  // two constructors, one has to have a special name
  Info.note(String emot, Date d, String n) {
    emotion = emot ;
    date = d ;
    note = n ;
  }

  String getEmotion() {
    return emotion ;
  }

  String getNote() {
    return note ;
  }

  Date getDate() {
    return date ;
  }
}

@HiveType(typeId: 0)
class Data {

  // hashmap storing all the data ever added, key: unique number assigned to data, value: Info (see Info class)
  Map<double, Info> dataStorage = <double, Info>{} ;

  // current double number assigned to data (increases every time data is added)
  double dataNum = 0.0 ;

  // days of the week (to check against)
  List<String> daysList = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"] ;

  // emotions list (to check against)
  List<String> emotionsList = ["Happy", "Sad", "Angry"] ;

  // sorted data currently displayed
  late List<String> displayedSortedData ;

  // method to add a data point
  void addData(Info i) {
    dataStorage[dataNum] = i ;
    dataNum += 1.0 ;
    // print("\n calling addData");
    // print(dataStorage);
    // print("----------------- \n");
  }

  // sort data helper function for returnGraphData
  Map<String, dynamic> sortData(String key, Map<String, int> filteredData, List<String> sortedData) {

    // if the key already exists in filtered data then add 1 to its value
    if (filteredData.containsKey(key)) {
      // ! is a null check
      filteredData[key] = (filteredData[key]! + 1);

      // index in sortedData minus 1
      int indxMinus = sortedData.indexOf(key) - 1;

      // properly re-sort sortedData
      while ((indxMinus >= 0) &&
          (filteredData[sortedData[indxMinus]]! < filteredData[key]!)) {
        // swap two values
        var store = sortedData[indxMinus];
        sortedData[indxMinus] = sortedData[indxMinus + 1];
        sortedData[indxMinus + 1] = store;
      }
    }
    // otherwise create a new key value pair
    else {
      filteredData[key] = 1;
      sortedData.add(key);
    }


    return {
      "filteredData": filteredData,
      "sortedData": sortedData,
    } ;
  }

  // returns the data points in graph info form
  List<int> createGraphData(int xInp, Map<String, int> filteredData, List<String> sortedData) {
    // x and y values
    List<int> combinedData = [];

    for (int indx = 0 ; indx < sortedData.length ; indx += 1) {
      combinedData.add(filteredData[sortedData[indx]]!) ;
    }

    // // create graph elements
    // List<BarChartRodData> rods = [] ;
    //
    // for (int i = 0; i < combinedData.length; i++) {
    //   rods.add(
    //     BarChartRodData(
    //       fromY: 0,
    //       toY: combinedData[i].toDouble(),
    //       color: Colors.purple,
    //       width: 10,
    //     ),
    //   );
    // }

    return combinedData ;
  }


  // return BarChartGroupData sorted based on input
  List<int> returnGraphData(String filter, int xInp) {
    // FILTERED DATA
    // the Integer is the number of times that emotion is recorded for this filter
    Map<String, int> filteredData = <String, int>{};

    // LIST IN DECREASING ORDER OF FILTERED DATA
    List<String> sortedData = [];

    // if filter is a day of the week
    if (daysList.contains(filter)) {
      // go through dataStorage and find data which matches the filter
      dataStorage.forEach((k, value) {
        // check if the value of the data point in the data storage matches the filter
        if (value.getDate().getDayOfWeek() == (filter)) {
          // find the new key value which is the emotion of the data point in data storage
          String key = value.getEmotion();
          filteredData =
          sortData(key, filteredData, sortedData)["filteredData"];
          sortedData = sortData(key, filteredData, sortedData)["sortedData"];
        }
      });
    }

    // if filter is emotion
    else if (emotionsList.contains(filter)) {
      // go through dataStorage and find data which matches the filter
      dataStorage.forEach((k, value) {
        // check if the value of the data point in the data storage matches the filter
        if (value.getEmotion() == (filter)) {
          // find the new key value which is the emotion of the data point in data storage
          String key = value.getDate().getDayOfWeek();
          filteredData = sortData(key, filteredData, sortedData)["filteredData"];
          sortedData = sortData(key, filteredData, sortedData)["sortedData"];
        }
      });
    }

    return createGraphData(xInp, filteredData, sortedData);
  }


}





