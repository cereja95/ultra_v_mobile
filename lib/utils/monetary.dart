library Monetary;

import 'package:flutter_money_formatter/flutter_money_formatter.dart';

String formatterMoney(double value) {
  FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: value / 100)
    ..symbol = 'R\$'
    ..thousandSeparator = '.'
    ..decimalSeparator = ','
    ..spaceBetweenSymbolAndNumber = true;
  return fmf.formattedLeftSymbol;
}
