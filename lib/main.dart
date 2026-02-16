import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'data.dart';


const String hiveBox = 'dataStorage';

Future main() async {
    // It is used so that void main function 
    // can be intiated after successfully
    // intialization of data
    WidgetsFlutterBinding.ensureInitialized();

    // To intialise the hive database
    await Hive.initFlutter();

    // register adapters
    Hive.registerAdapter(DataAdapter());
    
    await Hive.openBox(hiveBox);
    

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
    return (Center(child: Text('Plant goes here')));
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final box = Hive.box(hiveBox);

  List<String> emotions = ["happy", "sad", "angry"];

  int currEmotion = 0;



  Widget build(BuildContext context) {
    var d = box.get("data") ?? Data();

    return (Card(
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () {
            var info = Info(emotions[currEmotion], Date()) ;
            d.addData(info) ;
            box.put("data", d) ;
            print("adding data"); // PRINT FUNCTION TO MAKE SURE BUTTON WORKS
            setState(() {});
          },
          child: Text(emotions[currEmotion]),
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

  BarChartGroupData createBarData() {
    final List<int> values = box.get("list").cast<int>();
    print("running check 1");
    List<BarChartRodData> rods = [];
    for (int elem in values) {
      print("running check 2 (in loop)");
      rods.add(BarChartRodData(toY: elem.toDouble())) ;
    }
    print("running check 3");

    barChartGroupData =  BarChartGroupData(
      x: 0,
      barRods: rods,
      barsSpace: 10,
    ); ;
    return barChartGroupData ;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
        child: Column(
        children: [
          SizedBox(
            height: 150,
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
                        'My Chart Title',
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
          )
          ),
          ),
          ElevatedButton(
            onPressed: () {
              print("running sorting");
              box.put("list", box.get("data").returnGraphData("Sunday", 0)) ;
              createBarData() ; // error here <-----
              print("\n Sorting Data: ");
              print(barChartGroupData); // PRINT STATEMENT TO CHECK THIS BUTTON WORKS
              print("---------------------\n");
              print(box.get("list"));
              print("---------------------\n");
              print(box.get("data").dataStorage[0].date.getDayOfWeek());
              print("---------------------\n");
              setState(() {});
            },
            child: Text("Sunday"),
          ),
        ]
      )
    ),
    );

  }
}

