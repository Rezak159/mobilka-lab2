import 'package:flutter/material.dart';

import 'currency_repository.dart';
import 'rate.dart';

class ConverterState extends ChangeNotifier {
  CurrencyRepository repo = CurrencyRepository();

  String curFrom = 'EUR';
  String toCurrency = 'RUB';

  String status = '';
  String error = '';
  double result = 0;
  Rate? rate;

  void swap() {
    curFrom = toCurrency;
    toCurrency = curFrom;
    notifyListeners();
  }

  Future<void> convert(String text) async {
    double amount = double.parse(text);

    status = 'loading';
    notifyListeners();

    try {
      rate = await repo.getRate(curFrom, toCurrency);
      result = amount * rate!.value;
      status = 'ok';
    } catch (e) {
      status = 'error';
      error = e.toString();
    }

    notifyListeners();
  }
}
