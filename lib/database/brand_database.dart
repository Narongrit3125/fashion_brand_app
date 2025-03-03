// lib/database/brand_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/brand_item.dart';

class BrandDatabase {
  static final BrandDatabase instance = BrandDatabase._init();
  static Database? _database;

  BrandDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('brands.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE brands (
        id INTEGER PRIMARY KEY,
        name TEXT,
        category TEXT,
        date TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<void> insertBrand(BrandItem brand) async {
    final db = await instance.database;
    await db.insert('brands', brand.toMap());
  }

  Future<List<BrandItem>> getBrands() async {
    final db = await instance.database;
    final result = await db.query('brands');
    return result.map((map) => BrandItem.fromMap(map)).toList();
  }

  Future<void> deleteBrand(int id) async {
    final db = await instance.database;
    await db.delete('brands', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateBrand(BrandItem brand) async {
    final db = await database;
    await db.update(
      'brands',
      brand.toMap(),
      where: 'id = ?',
      whereArgs: [brand.id],
    );
  }

}

