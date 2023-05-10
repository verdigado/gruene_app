String getBarcodeUrl(String? barcode) {
  if (barcode == null) return '';
  RegExp exp = RegExp(r'^https:\/\/saml\.gruene\.de\/realms\/([\w\-.\/]+)');
  RegExpMatch? match = exp.firstMatch(barcode);
  print(match?[0] ?? '');
  return match?[0] ?? '';
}

String getBarcodeKey(String? barcode) {
  if (barcode == null) return '';
  RegExp exp = RegExp(r'key=([\w\-.\/]+)');
  RegExpMatch? match = exp.firstMatch(barcode);
  print(match?[0] ?? '');
  return match?[0] ?? '';
}

String getBarcodeClientId(String? barcode) {
  if (barcode == null) return '';
  RegExp exp = RegExp(r'client_id=([\w\-.\/]+)');
  RegExpMatch? match = exp.firstMatch(barcode);
  print(match?[0] ?? '');
  return match?[0] ?? '';
}

String getBarcodeTabId(String? barcode) {
  if (barcode == null) return '';
  RegExp exp = RegExp(r'tab_id=([\w\-.\/]+)');
  RegExpMatch? match = exp.firstMatch(barcode);
  print(match?[0] ?? '');
  return match?[0] ?? '';
}
