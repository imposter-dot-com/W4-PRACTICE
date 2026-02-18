import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Home()),
    ),
  );
}

class ColorService extends ChangeNotifier{
  final Map<CardType, int> _tapCounts = {
    for(var type in CardType.values) type:0,
  };

  int getTapCount(CardType type) => _tapCounts[type] ?? 0;

  void increment(CardType type){
    _tapCounts[type] = (_tapCounts[type] ?? 0) + 1;
    notifyListeners();
  }
}

enum CardType { red, blue, green, pink }

const Map<CardType, Color> cardColors = {
  CardType.red: Colors.red,
  CardType.blue: Colors.blue,
  CardType.green: Colors.green,
  CardType.pink: Colors.pink,
};

const Map<CardType, String> cardLabels = {
  CardType.red: 'Red',
  CardType.blue: 'Blue',
  CardType.green: 'Green',
  CardType.pink: 'Pink',
};

final ColorService colorService = ColorService();


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 
          ? const ColorTapsScreen() : const StatisticsScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.tap_and_play), 
              label: 'Taps',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), 
              label: 'Statistics'
            ),
          ]
        ),
    );
  }
}

class ColorTapsScreen extends StatelessWidget {
  const ColorTapsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Taps')),
      body: ListView(
          children: CardType.values.map((type) => ColorTap(type: type)).toList(),
        )
      );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;

  const ColorTap({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: colorService,
      builder: (context, _){
        final count = colorService.getTapCount(type);
        return GestureDetector(
        onTap: () => colorService.increment(type),
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardColors[type],
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 100,
          child: Center(
            child: Text(
              'Taps: $count',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      );
      },
    );
  }
}

class StatisticsScreen extends StatelessWidget {

  const StatisticsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Center(
        child: ListenableBuilder(
        listenable: colorService, 
        builder: (context, _){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: CardType.values.map((type) {
              return Text(
                '${cardLabels[type]} Taps: ${colorService.getTapCount(type)}', 
                style: TextStyle(fontSize:24),
              );
            }).toList(),
          );
        })
      ),
    );
  }
}

