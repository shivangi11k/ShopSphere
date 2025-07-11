import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> createPaymentIntent(int amount, String currency) async {
  final resp = await http.post(
    Uri.parse('http://localhost:3000/create-payment-intent'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'amount': amount, 'currency': currency}),
  );
  final data = jsonDecode(resp.body);
  if (data['clientSecret'] == null) throw Exception('Missing clientSecret');
  return data['clientSecret'];
}
