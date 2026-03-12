import 'dart:core';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'data.dart';


const String hiveBox = 'dataStorage';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(DataAdapter());

  await Hive.openBox(hiveBox);
  var box = Hive.box(hiveBox);

  // Ensure the data object exists
  if (!box.containsKey("data")) {
    box.put("data", Data());
  }

  runApp(const MaterialApp(home: Main()));
}


class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}



class _MainState extends State<Main> {
  int currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFEBAD),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: <Widget>[
          Home(),
          const Plant(),
          const Chart()
        ][currentPageIndex], // show only the selected page
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.face)),
            label: 'Plant',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.data_array)),
            label: 'data',
          ),
        ],
      ),
    );
  }
}



class Plant extends StatefulWidget {
  const Plant({super.key});

  @override
  State<Plant> createState() => _PlantState();
}

class _PlantState extends State<Plant> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Stack(
    children: [
      // Garden
      Image.asset(
        'assets/images/GardenBack 1.PNG',
        height: 1000,
        width: 800,
      ),

      // List of positions for the top image
      for (var pos in [
        {"x": 200.0, "y": 450.0},
        {"x": 380.0, "y": 435.0},
        {"x": 270.0, "y": 520.0},
        {"x": 385.0, "y": 530.0},
        {"x": 200.0, "y": 600.0},
        {"x": 320.0, "y": 630.0},
      ])
        Positioned(
          left: pos["x"],
          top: pos["y"],
          child: Image.asset(
            'assets/images/Fern 3.PNG',
            width: 120,
            height: 120,
          ),
        ),
    ],
  ),
    );
  }
}


class Home extends StatefulWidget {
  Home({super.key});

  @override State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final box = Hive.box(hiveBox);

  List<String> emotions = ["happy", "sad", "angry"];




  Widget build(BuildContext context) {
    var d = box.get("data") ?? Data();

    return (Card(
      child: Container(
        height: 500,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            ElevatedButton(
              onPressed: () {
                var info = Info("happy", Date()) ;
                print("data bef.");
                print(box.get("data").dataStorage);
                d.addData(info) ;
                box.put("data", d) ;
                print("adding data"); // PRINT FUNCTION TO MAKE SURE BUTTON WORKS
                print(box.get("data").dataStorage);
                print("\n");
                setState(() {});
              },
                child: Image.asset('assets/images/happy_button.png', width: 150, height: 70),
            ),
            ElevatedButton(
              onPressed: () {
                var info = Info("sad", Date()) ;
                print("data bef.");
                print(box.get("data").dataStorage);
                d.addData(info) ;
                box.put("data", d) ;
                print("adding data"); // PRINT FUNCTION TO MAKE SURE BUTTON WORKS
                print(box.get("data").dataStorage);
                print("\n");
                setState(() {});
              },
              child: Image.asset('assets/images/sad_button.png', width: 150, height: 70),
            ),
            ElevatedButton(
              onPressed: () {
                var info = Info("angry", Date()) ;
                print("data bef.");
                print(box.get("data").dataStorage);
                d.addData(info) ;
                box.put("data", d) ;
                print("adding data"); // PRINT FUNCTION TO MAKE SURE BUTTON WORKS
                print(box.get("data").dataStorage);
                print("\n");
                setState(() {});
              },
              child: Image.asset('assets/images/angry_button.png', width: 150, height: 70),
            ),
            ElevatedButton(
              onPressed: () {
                var info = Info("anxious", Date()) ;
                print("data bef.");
                print(box.get("data").dataStorage);
                d.addData(info) ;
                box.put("data", d) ;
                print("adding data"); // PRINT FUNCTION TO MAKE SURE BUTTON WORKS
                print(box.get("data").dataStorage);
                print("\n");
                setState(() {});
              },
              child: Image.asset('assets/images/anxious_button.png', width: 150, height: 70),
            ),
            ElevatedButton(
              onPressed: () {
                var info = Info("excited", Date()) ;
                print("data bef.");
                print(box.get("data").dataStorage);
                d.addData(info) ;
                box.put("data", d) ;
                print("adding data"); // PRINT FUNCTION TO MAKE SURE BUTTON WORKS
                print(box.get("data").dataStorage);
                print("\n");
                setState(() {});
              },
              child: Image.asset('assets/images/excited_button.png', width: 150, height: 70),
            ),
            ElevatedButton(
              onPressed: () {
                var info = Info("melancholy", Date()) ;
                print("data bef.");
                print(box.get("data").dataStorage);
                d.addData(info) ;
                box.put("data", d) ;
                print("adding data"); // PRINT FUNCTION TO MAKE SURE BUTTON WORKS
                print(box.get("data").dataStorage);
                print("\n");
                setState(() {});
              },
              child: Image.asset('assets/images/melancholy_button.png', width: 150, height: 70),
            ),
          ],
        ),
      ),
    ));
  }
}


class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final box = Hive.box(hiveBox);

  BarChartGroupData barChartGroupData = BarChartGroupData(x: 0) ;
  List<String> barLabels = [];

  BarChartGroupData createBarData() {
    final List<int> values = box.get("list").cast<int>();
    List<BarChartRodData> rods = [];
    for (int elem in values) {
      rods.add(BarChartRodData(toY: elem.toDouble())) ;
    }

    barChartGroupData =  BarChartGroupData(
      x: 0,
      barRods: rods,
      barsSpace: 10,
    );
    return barChartGroupData ;
  }

  // create the labels that pop up when you click on a graph bar
  List<String> createBarLabels(String filter) {
    final List<String> labels = box.get("labels").cast<String>();
    barLabels = labels;
    return barLabels;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000,
      child: Container(
        child: Column(
        children: [
          SizedBox(
            height: 400,
            child: BarChart(
            BarChartData(
              // Top title
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 50,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Data',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Background color
              backgroundColor: const Color.fromRGBO(245, 227, 185, 1),
              // Bar data
              barGroups: [barChartGroupData],
              // the labels that pop up when you click on a bar
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      barLabels[rodIndex],
                      TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
          )
          ),
          ),
          ElevatedButton(
            onPressed: () {
              var returnedData = box.get("data").returnGraphData("Sunday", 0);
              box.put("list", returnedData["graphData"]) ;
              box.put("labels", returnedData["sortedData"]) ;
              createBarData() ;
              createBarLabels("Sunday");
              setState(() {});
            },
            child: Text("Sunday"),
          ),
          ElevatedButton(
            onPressed: () {
              var returnedData = box.get("data").returnGraphData("Monday", 0);
              box.put("list", returnedData["graphData"]) ;
              box.put("labels", returnedData["sortedData"]) ;
              createBarData() ;
              createBarLabels("Monday");
              setState(() {});
            },
            child: Text("Monday"),
          ),
          ElevatedButton(
            onPressed: () {
              var returnedData = box.get("data").returnGraphData("Tuesday", 0);
              box.put("list", returnedData["graphData"]) ;
              box.put("labels", returnedData["sortedData"]) ;
              createBarData() ;
              createBarLabels("Tuesday");
              setState(() {});
            },
            child: Text("Tuesday"),
          ),
          ElevatedButton(
            onPressed: () {
              var returnedData = box.get("data").returnGraphData("Wednesday", 0);
              box.put("list", returnedData["graphData"]) ;
              box.put("labels", returnedData["sortedData"]) ;
              createBarData() ;
              createBarLabels("Wednesday");
              setState(() {});
            },
            child: Text("Wednesday"),
          ),
          ElevatedButton(
            onPressed: () {
              print("running sorting");
              var returnedData = box.get("data").returnGraphData("Thursday", 0);
              box.put("list", returnedData["graphData"]) ;
              box.put("labels", returnedData["sortedData"]) ;
              createBarData() ;
              createBarLabels("Thursday");
              print("\n Sorting Data: ");
              print(barChartGroupData); // PRINT STATEMENT TO CHECK THIS BUTTON WORKS
              print("---------------------\n");
              print(box.get("labels"));
              print("---------------------\n");
              print(box.get("list"));
              print("---------------------\n");
              print(box.get("data").dataStorage[0].date.getDayOfWeek());
              print("---------------------\n");
              setState(() {});
            },
            child: Text("Thursday"),
          ),
          ElevatedButton(
            onPressed: () {
              print("running sorting");
              var returnedData = box.get("data").returnGraphData("Friday", 0);
              box.put("list", returnedData["graphData"]) ;
              box.put("labels", returnedData["sortedData"]) ;
              createBarData() ;
              createBarLabels("Friday");
              print("\n Sorting Data: ");
              print(barChartGroupData); // PRINT STATEMENT TO CHECK THIS BUTTON WORKS
              print("---------------------\n");
              print(box.get("labels"));
              print("---------------------\n");
              print(box.get("list"));
              print("---------------------\n");
              print(box.get("data").dataStorage[0].date.getDayOfWeek());
              print("---------------------\n");
              setState(() {});
            },
            child: Text("Friday"),
          ),
          ElevatedButton(
            onPressed: () {
              var returnedData = box.get("data").returnGraphData("Saturday", 0);
              box.put("list", returnedData["graphData"]) ;
              box.put("labels", returnedData["sortedData"]) ;
              createBarData() ;
              createBarLabels("Saturday");
              setState(() {});
            },
            child: Text("Saturday"),
          ),
        ]
      )
    ),
    );

  }
}

