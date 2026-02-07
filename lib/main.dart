import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

//flutter run -d linux

void main() {
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
          const Home(),
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

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return (Card(
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: const Text('one'),
      ),
    ));
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
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [Test(), Test(), Test(), Test(), Test(), Test(), Test()],
    ));
  }
}

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
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
          barGroups: [
            BarChartGroupData(
              x: 0,
              barsSpace: 10,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 100,
                  color: Colors.purple,
                  width: 10,
                ),
                BarChartRodData(
                  fromY: 0,
                  toY: 60,
                  color: Colors.purple,
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
