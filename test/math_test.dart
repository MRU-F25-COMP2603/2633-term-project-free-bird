import 'package:flutter_test/flutter_test.dart';

int calculateTotal(int flights, int hotels, int activities) {
  return flights + hotels + activities;
}

void main() {
  test('calculates total trip cost correctly', () {
    final total = calculateTotal(300, 500, 200);
    expect(total, 1000);
  });
}
