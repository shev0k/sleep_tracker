import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/(home)/obtained_item.dart';

class DataProvider {
  Future<List<ObtainedItem>> fetchObtainedItems() async {
    final String response = await rootBundle.loadString('assets/data/obtained_items.json');
    final List<dynamic> data = json.decode(response);
    return data.map((item) => ObtainedItem.fromJson(item)).toList();
  }
}
