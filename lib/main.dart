import 'package:flutter/material.dart';

import 'converter_state.dart';

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
  ConverterState state = ConverterState();
  TextEditingController controller = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    state.addListener(() {
      setState(() {});
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
              value: state.curFrom,
              isExpanded: true,
              items: currencies.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  state.curFrom = v!;
                });
              },
            ),

            Center(
              child: IconButton(
                onPressed: () {
                  state.swap();
                },
                icon: Icon(Icons.swap_vert, size: 32),
              ),
            ),

            Text('В', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: state.toCurrency,
              isExpanded: true,
              items: currencies.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  state.toCurrency = v!;
                });
              },
            ),
            SizedBox(height: 16),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  state.convert(controller.text);
                },
                child: Text('Конвертировать', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 16),

            // Text(state.status),
            if (state.status == 'loading')
              Center(child: CircularProgressIndicator()),

            if (state.status == 'error')
              Text(
                state.error,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),

            if (state.status == 'ok')
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text('Результат'),
                      Text(
                        state.result.toStringAsFixed(2) +
                            ' ' +
                            state.rate!.target,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '1 ' +
                            state.rate!.base +
                            ' = ' +
                            state.rate!.value.toString() +
                            ' ' +
                            state.rate!.target,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Курс обновлен: ' + state.rate!.updated,
                        style: TextStyle(color: Colors.grey),
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
