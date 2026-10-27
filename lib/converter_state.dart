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

  List<String> history = [];

  void swap() {
    String t = curFrom;
    curFrom = toCurrency;
    toCurrency = t;
    status = '';
    notifyListeners();
  }

  Future<void> convert(String text) async {
    text = text.replaceAll(',', '.').trim();

    if (text == '') {
      status = 'error';
      error = 'Введите сумму';
      notifyListeners();
      return;
    }

    double? amount = double.tryParse(text);

    if (amount == null) {
      status = 'error';
      error = 'Некорректная сумма';
      notifyListeners();
      return;
    }
    if (amount < 0) {
      status = 'error';
      error = 'Сумма не может быть отрицательной';
      notifyListeners();
      return;
    }

    status = 'loading';
    notifyListeners();

    try {
      rate = await repo.getRate(curFrom, toCurrency);
      result = amount * rate!.value;
      status = 'ok';
      history.insert(
        0,
        amount.toString() +
            ' ' +
            curFrom +
            ' = ' +
            result.toStringAsFixed(2) +
            ' ' +
            toCurrency,
      );
    } catch (e) {
      status = 'error';
      error = e.toString();
    }

    notifyListeners();
  }
}
