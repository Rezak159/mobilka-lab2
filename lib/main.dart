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
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 183, 58, 114),
        ),
      ),
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
    'VND',
    'THB',
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
          padding: EdgeInsets.all(15),
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Сумма'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
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
                ),
                IconButton(
                  onPressed: () {
                    state.swap();
                  },
                  icon: Icon(Icons.swap_horiz),
                ),
                Expanded(
                  child: DropdownButton<String>(
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
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                state.convert(controller.text);
              },
              child: Text('Конвертировать'),
            ),
            SizedBox(height: 20),

            // Text(state.status),
            if (state.status == 'loading')
              Center(child: CircularProgressIndicator()),

            if (state.status == 'error')
              Text(state.error, style: TextStyle(color: Colors.red)),

            if (state.status == 'ok')
              Text(
                state.result.toStringAsFixed(2) + ' ' + state.rate!.target,
                style: TextStyle(fontSize: 30),
              ),
            if (state.status == 'ok')
              Text(
                '1 ' +
                    state.rate!.base +
                    ' = ' +
                    state.rate!.value.toString() +
                    ' ' +
                    state.rate!.target,
              ),
            if (state.status == 'ok')
              Text('Курс обновлен: ' + state.rate!.updated),

            SizedBox(height: 30),
            if (state.history.isNotEmpty) Text('История:'),
            for (var h in state.history) Text(h),
          ],
        ),
      ),
    );
  }
}
