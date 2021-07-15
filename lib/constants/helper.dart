import 'package:intl/intl.dart';

String formatCurrency({double amount, int fixedDigits = 2}) {
  final formatter = new NumberFormat.simpleCurrency(decimalDigits: fixedDigits);

  return formatter.format(amount);
}

String formatNumString({double amount, int digits = 1}) {
  List<List<dynamic>> si = [
    [1, ''],
    [1e3, 'k'],
    [1e6, 'M'],
    [1e9, 'G'],
    [1e12, 'T'],
    [1e15, 'P'],
    [1e18, 'E'],
  ];

  RegExp exp = RegExp(r"/\.0+$|(\.[0-9]*[1-9])0+$/");
  int i;
  for (i = si.length - 1; i > 0; i--) if (amount >= si[i][0]) break;

  return (amount / si[i][0]).toStringAsFixed(digits).replaceAllMapped(exp, (match) => "${match.group(0)}") + si[i][1];
}
