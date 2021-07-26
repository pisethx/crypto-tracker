import 'dart:convert';
import 'package:crypto_tracker/models/crypto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

setSharedPreferences(String key, dynamic value) async {
  SharedPreferences prefs = await _prefs;
  await prefs.setString(key, json.encode(value));
}

getSharedPreferences(String key) async {
  SharedPreferences prefs = await _prefs;
  var result = prefs.get(key);

  return result != null ? json.decode(result) : null;
}

Future<List<dynamic>> fetchCryptoPerPage({int page = 1}) async {
  try {
    final response = await http.get(formatApiUrl(type: 'ticker', slug: '&per-page=100&page=$page'));
    return json.decode(response.body);
  } catch (err) {
    print('Caught error: $err');
    return [];
  }
}

Future<List<Crypto>> fetchCrypto([String keyword = '', bool force = false]) async {
  var result = await getSharedPreferences('CRYPTO');

  if (force || result == null) {
    final response1 = await fetchCryptoPerPage(page: 1);
    final response2 = await fetchCryptoPerPage(page: 2);
    // final response3 = await fetchCryptoPerPage(page: 3);
    // final response4 = await fetchCryptoPerPage(page: 4);
    // final response5 = await fetchCryptoPerPage(page: 5);

    result = (response1 + response2);

    await setSharedPreferences('CRYPTO', result);
  }

  List<dynamic> data = result;

  var cryptos = data.map((json) => Crypto.fromJson(json));

  if (keyword != '') {
    final _keyword = keyword.toLowerCase();
    cryptos = cryptos.where(
        (crypto) => crypto.name.toLowerCase().startsWith(_keyword) || crypto.id.toLowerCase().startsWith(_keyword));
  }

  return cryptos.toList();
}

Uri formatApiUrl({String type, String slug}) {
  Uri uri = Uri.parse('https://api.nomics.com/v1/currencies/$type?key=${dotenv.env['NOMICS_API_KEY']}$slug');
  print('fetching $uri');
  return uri;
}

String formatCryptoName(Crypto crypto) {
  return '${crypto.name} (${crypto.id})';
}

String formatCurrency({double amount, int fixedDigits = 2}) {
  if (amount == null) return '';
  final formatter = new NumberFormat.simpleCurrency(decimalDigits: fixedDigits);

  return formatter.format(amount);
}

String formatPercentage(String percentage) {
  return (percentage.startsWith('-') ? '' : '+') + percentage + '%';
}

String formatNumber({double amount, int fixedDigits = 2}) {
  final formatter = new NumberFormat.decimalPattern();

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
