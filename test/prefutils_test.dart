import 'package:flutter_test/flutter_test.dart';
import 'package:kwantapo/utils/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';




void main() {
  test('setIpAddress() saves the IP address successfully', () async {
    // Arrange
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
    String address = '192.168.1.1';

    // Act
    await PrefUtils().setIpAddress(address);

    // Assert
    String? storedAddress = await PrefUtils().getIpAddress();
    expect(storedAddress, equals(address));
  });

  test('setIpAddress() overwrites the existing IP address', () async {
    // Arrange
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
    String address1 = '192.168.1.1';
    String address2 = '192.168.1.2';

    // Act
    await PrefUtils().setIpAddress(address1);
    await PrefUtils().setIpAddress(address2);

    // Assert
    String? storedAddress = await PrefUtils().getIpAddress();
    expect(storedAddress, equals(address2));
  });
}
