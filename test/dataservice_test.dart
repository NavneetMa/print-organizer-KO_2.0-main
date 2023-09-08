import 'package:flutter_test/flutter_test.dart';
import 'package:kwantapo/data/dto/KotJsonData.dart';
import 'package:kwantapo/data/entities/EKot.dart';
import 'package:kwantapo/db/DatabaseHelper.dart';
import 'package:kwantapo/db/DatabaseManager.dart';
import 'package:kwantapo/services/DataService.dart';




void main() {
  // Test case 1: Test a valid JSON data and valid kotId
  test('Test saveKASSAFKot with valid JSON data and kotId', () async {
    dynamic jsonData = {
      "itemList": [
        {
          "childItemList": [],
          "groupName": "",
          "isCategory": true,
          "item": " --Drinks--",
          "itemAddition": [],
          "quantity": "",
          "unit": "",
        },
        {
          "childItemList": [],
          "groupName": "Sweet",
          "isCategory": false,
          "item": " Jalebi",
          "itemAddition": [],
          "quantity": "1x",
          "unit": "1/4",
        },
        {
          "childItemList": [],
          "groupName": "",
          "isCategory": true,
          "item": " --Food--",
          "itemAddition": [],
          "quantity": "",
          "unit": "",
        },
        {
          "childItemList": [],
          "groupName": "Panjabi",
          "isCategory": false,
          "item": " Paneer Masala",
          "itemAddition": [],
          "quantity": "1x",
          "unit": "1/4",
        },
      ],
      "tableName": "t2",
      "userName": "User1",
    };
    int kotId = 123;

    KotJsonData result = await DataService.getInstance.saveKASSAFKot(jsonData, kotId);

    // Assert that the result is not null
    expect(result, isNotNull);
  });


  test('Test with valid data', () {
    final dataService = DataService();
    final List<int> testFinalData = [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100];
    final String expectedJsonData = 'Hello World';

    final result = dataService.getJsonDataFromDecimalCommands(testFinalData);
    expect(result, equals(expectedJsonData));
  });

  test('Test with data larger than offset', () {
    final dataService = DataService();
    final List<int> testFinalData = [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33, 33, 33];
    final String expectedJsonData = 'Hello World!!!';
    final result = dataService.getJsonDataFromDecimalCommands(testFinalData);
    expect(result, equals(expectedJsonData));
  });

  test('Test with empty data', () {
    final dataService = DataService();
    final List<int> testFinalData = [];
    final String expectedJsonData = '';
    final result = dataService.getJsonDataFromDecimalCommands(testFinalData);
    expect(result, equals(expectedJsonData));
  });

  test('addKotInKitchenSumMode() saves the kot successfully', () async {
    // Arrange
    DatabaseManager dbManager = await DatabaseHelper.getInstance;
    Map<String, dynamic> data = {"itemList":[{"childItemList":[],"groupName":"","isCategory":true,"item":" --Drinks--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Sweet","isCategory":false,"item":" Jalebi","itemAddition":[],"quantity":"1x","unit":"1/4"},{"childItemList":[],"groupName":"","isCategory":true,"item":" --Food--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Panjabi","isCategory":false,"item":" Paneer Masala","itemAddition":[],"quantity":"1x","unit":"1/4"}],"tableName":"t2","userName":"User1"};
    EKot ekot = EKot(
      kot: '[123, 34, 100, 97, 116, 97, 34, 58, 123, 34, 105, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 116, 114, 117, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 45, 45, 68, 114, 105, 110, 107, 115, 45, 45, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 83, 119, 101, 101, 116, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 102, 97, 108, 115, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 74, 97, 108, 101, 98, 105, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 49, 120, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 49, 47, 52, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 116, 114, 117, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 45, 45, 67, 111, 108, 100, 45, 45, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 83, 119, 101, 101, 116, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 102, 97, 108, 115, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 68, 111, 117, 98, 108, 101, 32, 67, 104, 101, 101, 115, 101, 32, 77, 97, 114, 103, 104, 101, 114, 105, 116, 97, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 49, 120, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 93, 44, 34, 116, 97, 98, 108, 101, 78, 97, 109, 101, 34, 58, 34, 116, 49, 34, 44, 34, 117, 115, 101, 114, 78, 97, 109, 101, 34, 58, 34, 85, 115, 101, 114, 49, 34, 125, 44, 34, 100, 97, 116, 97, 84, 121, 112, 101, 34, 58, 34, 80, 111, 75, 111, 116, 34, 125]',
      kotDismissed: 0,
      receivedTime: "2023-08-03 11:34:00.248373",
      fKotWithSeparator: '{"itemList":[{"childItemList":[],"groupName":"","isCategory":true,"item":" --Drinks--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Sweet","isCategory":false,"item":" Jalebi","itemAddition":[],"quantity":"1x","unit":"1/4"},{"childItemList":[],"groupName":"","isCategory":true,"item":" --Food--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Panjabi","isCategory":false,"item":" Paneer Masala","itemAddition":[],"quantity":"1x","unit":"1/4"}],"tableName":"t2","userName":"User1"}',
      hashMD5: "6-1691266524204",
      isUndoKot: false,
      snoozeDateTime: "",
      hideKot: false,
      singleCategory: 0,
      tableNameMatch: false,
      inSum: false,
    );
    int kotId = await DataService.getInstance.addKotInKitchenSumMode(ekot, data);
    expect(kotId, isPositive);
    expect(await dbManager.kotDao.getSingle(kotId), isNotNull);
  });

  test('addKotInKitchenSumMode() throws an error if the kot is invalid', () async {
    Map<String, dynamic> data = {'name': '', 'quantity': 0};
    try {
      await DataService.getInstance.addKotInKitchenSumMode(EKot(), data);
    } catch (error) {
      expect(error, isA<ArgumentError>());
    }
  });

  test('saveKitchenSumModeKot() saves the kot and items successfully', () async {
    // Arrange
    DatabaseManager dbManager = await DatabaseHelper.getInstance;
    Map<String, dynamic> data = {"itemList":[{"childItemList":[],"groupName":"","isCategory":true,"item":" --Drinks--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Sweet","isCategory":false,"item":" Jalebi","itemAddition":[],"quantity":"1x","unit":"1/4"},{"childItemList":[],"groupName":"","isCategory":true,"item":" --Food--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Panjabi","isCategory":false,"item":" Paneer Masala","itemAddition":[],"quantity":"1x","unit":"1/4"}],"tableName":"t2","userName":"User1"};

    await DataService.getInstance.saveKitchenSumModeKot(data, 1);

    // Assert
    expect(await dbManager.kotDao.getSingle(1), isNotNull);
  });


  test('addKot() saves the kot and sends it to Kitchen Sum Mode successfully', () async {
    // Arrange
    DatabaseManager dbManager = await DatabaseHelper.getInstance;
    Map<String, dynamic> data = {"itemList":[{"childItemList":[],"groupName":"","isCategory":true,"item":" --Drinks--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Sweet","isCategory":false,"item":" Jalebi","itemAddition":[],"quantity":"1x","unit":"1/4"},{"childItemList":[],"groupName":"","isCategory":true,"item":" --Food--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Panjabi","isCategory":false,"item":" Paneer Masala","itemAddition":[],"quantity":"1x","unit":"1/4"}],"tableName":"t2","userName":"User1"};
    EKot ekot = EKot(
      kot: '[123, 34, 100, 97, 116, 97, 34, 58, 123, 34, 105, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 116, 114, 117, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 45, 45, 68, 114, 105, 110, 107, 115, 45, 45, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 83, 119, 101, 101, 116, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 102, 97, 108, 115, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 74, 97, 108, 101, 98, 105, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 49, 120, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 49, 47, 52, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 116, 114, 117, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 45, 45, 67, 111, 108, 100, 45, 45, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 83, 119, 101, 101, 116, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 102, 97, 108, 115, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 68, 111, 117, 98, 108, 101, 32, 67, 104, 101, 101, 115, 101, 32, 77, 97, 114, 103, 104, 101, 114, 105, 116, 97, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 49, 120, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 93, 44, 34, 116, 97, 98, 108, 101, 78, 97, 109, 101, 34, 58, 34, 116, 49, 34, 44, 34, 117, 115, 101, 114, 78, 97, 109, 101, 34, 58, 34, 85, 115, 101, 114, 49, 34, 125, 44, 34, 100, 97, 116, 97, 84, 121, 112, 101, 34, 58, 34, 80, 111, 75, 111, 116, 34, 125]',
      kotDismissed: 0,
      receivedTime: "2023-08-03 11:34:00.248373",
      fKotWithSeparator: '{"itemList":[{"childItemList":[],"groupName":"","isCategory":true,"item":" --Drinks--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Sweet","isCategory":false,"item":" Jalebi","itemAddition":[],"quantity":"1x","unit":"1/4"},{"childItemList":[],"groupName":"","isCategory":true,"item":" --Food--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Panjabi","isCategory":false,"item":" Paneer Masala","itemAddition":[],"quantity":"1x","unit":"1/4"}],"tableName":"t2","userName":"User1"}',
      hashMD5: "6-1691266524204",
      isUndoKot: false,
      snoozeDateTime: "",
      hideKot: false,
      singleCategory: 0,
      tableNameMatch: false,
      inSum: false,
    );
    // Act
    bool isSentToKitchenSumMode = await DataService.getInstance.addKot(ekot, data);

    // Assert
    expect(isSentToKitchenSumMode, isTrue);
    expect(await dbManager.kotDao.getSingle(1), isNotNull);
  });

  test('addKot() does not send the kot to Kitchen Sum Mode if the IP address is not set', () async {
    // Arrange
    DatabaseManager dbManager = await DatabaseHelper.getInstance;
    Map<String, dynamic> data = {"itemList":[{"childItemList":[],"groupName":"","isCategory":true,"item":" --Drinks--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Sweet","isCategory":false,"item":" Jalebi","itemAddition":[],"quantity":"1x","unit":"1/4"},{"childItemList":[],"groupName":"","isCategory":true,"item":" --Food--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Panjabi","isCategory":false,"item":" Paneer Masala","itemAddition":[],"quantity":"1x","unit":"1/4"}],"tableName":"t2","userName":"User1"};
    EKot ekot = EKot(
      kot: '[123, 34, 100, 97, 116, 97, 34, 58, 123, 34, 105, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 116, 114, 117, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 45, 45, 68, 114, 105, 110, 107, 115, 45, 45, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 83, 119, 101, 101, 116, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 102, 97, 108, 115, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 74, 97, 108, 101, 98, 105, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 49, 120, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 49, 47, 52, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 116, 114, 117, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 45, 45, 67, 111, 108, 100, 45, 45, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 44, 123, 34, 99, 104, 105, 108, 100, 73, 116, 101, 109, 76, 105, 115, 116, 34, 58, 91, 93, 44, 34, 103, 114, 111, 117, 112, 78, 97, 109, 101, 34, 58, 34, 83, 119, 101, 101, 116, 34, 44, 34, 105, 115, 67, 97, 116, 101, 103, 111, 114, 121, 34, 58, 102, 97, 108, 115, 101, 44, 34, 105, 116, 101, 109, 34, 58, 34, 32, 68, 111, 117, 98, 108, 101, 32, 67, 104, 101, 101, 115, 101, 32, 77, 97, 114, 103, 104, 101, 114, 105, 116, 97, 34, 44, 34, 105, 116, 101, 109, 65, 100, 100, 105, 116, 105, 111, 110, 34, 58, 91, 93, 44, 34, 113, 117, 97, 110, 116, 105, 116, 121, 34, 58, 34, 49, 120, 34, 44, 34, 117, 110, 105, 116, 34, 58, 34, 34, 125, 93, 44, 34, 116, 97, 98, 108, 101, 78, 97, 109, 101, 34, 58, 34, 116, 49, 34, 44, 34, 117, 115, 101, 114, 78, 97, 109, 101, 34, 58, 34, 85, 115, 101, 114, 49, 34, 125, 44, 34, 100, 97, 116, 97, 84, 121, 112, 101, 34, 58, 34, 80, 111, 75, 111, 116, 34, 125]',
      kotDismissed: 0,
      receivedTime: "2023-08-03 11:34:00.248373",
      fKotWithSeparator: '{"itemList":[{"childItemList":[],"groupName":"","isCategory":true,"item":" --Drinks--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Sweet","isCategory":false,"item":" Jalebi","itemAddition":[],"quantity":"1x","unit":"1/4"},{"childItemList":[],"groupName":"","isCategory":true,"item":" --Food--","itemAddition":[],"quantity":"","unit":""},{"childItemList":[],"groupName":"Panjabi","isCategory":false,"item":" Paneer Masala","itemAddition":[],"quantity":"1x","unit":"1/4"}],"tableName":"t2","userName":"User1"}',
      hashMD5: "6-1691266524204",
      isUndoKot: false,
      snoozeDateTime: "",
      hideKot: false,
      singleCategory: 0,
      tableNameMatch: false,
      inSum: false,
    );

    // Act
    bool isSentToKitchenSumMode = await DataService.getInstance.addKot(ekot, data);

    // Assert
    expect(isSentToKitchenSumMode, isFalse);
    expect(await dbManager.kotDao.getSingle(1), isNotNull);
  });
}

