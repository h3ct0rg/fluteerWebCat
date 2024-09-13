import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DbService {
  static const String boxName = 'gatitosBox';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  Future<void> addGatito(Map<String, dynamic> gatito) async {
    var box = Hive.box(boxName);
    await box.add(gatito);
  }

  List<Map<String, dynamic>> getGatitos() {
    var box = Hive.box(boxName);
    return List<Map<String, dynamic>>.from(box.values);
  }

  Future<void> updateGatito(int index, Map<String, dynamic> gatito) async {
    var box = Hive.box(boxName);
    await box.putAt(index, gatito);
  }

  Future<void> deleteGatito(int index) async {
    var box = Hive.box(boxName);
    await box.deleteAt(index);
  }
}
