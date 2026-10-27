import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const MyHomePage(title: 'Конвертер валют'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();

  String curFrom = 'EUR';
  String toCurrency = 'RUB';
  double result = 0;
  double rate = 0;
  bool loading = false;

  List<String> currencies = [
    'RUB',
    'USD',
    'EUR',
    'CNY',
    'GBP',
    'JPY',
    'KZT',
    'BYN',
    'TRY',
  ];

  void convert() async {
    setState(() {
      loading = true;
    });

    var response = await http.get(
      Uri.parse('https://open.er-api.com/v6/latest/' + curFrom),
    );
    var data = jsonDecode(response.body);
    print(data);

    double amount = double.parse(controller.text);

    setState(() {
      rate = data['rates'][toCurrency];
      result = amount * rate;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('Сумма', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите сумму',
              ),
            ),
            SizedBox(height: 16),

            Text('Из', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: curFrom,
              isExpanded: true,
              items: currencies.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  curFrom = v!;
                });
              },
            ),

            Text('В', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: toCurrency,
              isExpanded: true,
              items: currencies.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  toCurrency = v!;
                });
              },
            ),
            SizedBox(height: 16),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  convert();
                },
                child: Text('Конвертировать', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 16),

            if (loading) Center(child: CircularProgressIndicator()),

            if (result != 0)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text('Результат'),
                      Text(
                        result.toStringAsFixed(2) + ' ' + toCurrency,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '1 ' +
                            curFrom +
                            ' = ' +
                            rate.toString() +
                            ' ' +
                            toCurrency,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
