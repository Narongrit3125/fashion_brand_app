// lib/provider/brand_provider.dart
import 'package:flutter/material.dart';
import '../models/brand_item.dart';
import '../database/brand_database.dart';

class BrandProvider extends ChangeNotifier {
  List<BrandItem> _items = [];

  List<BrandItem> get items => _items;
  Future<void> fetchAndSetBrands() async {
    final dataList = await BrandDatabase.instance.getBrands();
    _items = dataList;
    notifyListeners();
  }


  Future<void> fetchItems() async {
    _items = await BrandDatabase.instance.getBrands();
    notifyListeners();
  }

  Future<void> addItem(BrandItem brand) async {
    _items.add(brand);
    await BrandDatabase.instance.insertBrand(brand); // ✅ บันทึกลง SQLite
    notifyListeners();
  }

  Future<void> updateItem(BrandItem brand) async {
    final index = _items.indexWhere((item) => item.id == brand.id);
    if (index != -1) {
      _items[index] = brand;
      await BrandDatabase.instance.updateBrand(brand); // ✅ บันทึกการแก้ไข
      notifyListeners();
    }
  }


  Future<void> removeItem(int id) async {
    await BrandDatabase.instance.deleteBrand(id);
    await fetchItems();
  }
}
