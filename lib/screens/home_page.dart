import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/brand_provider.dart';
import 'dart:io';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<BrandProvider>(context, listen: false).fetchAndSetBrands());
  }

  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);
    final brands = brandProvider.items;

    return Scaffold(
      appBar: AppBar(title: Text('Brand List')),
      body: brands.isEmpty
          ? Center(child: Text('No brands added yet.'))
          : ListView.builder(
        itemCount: brands.length,
        itemBuilder: (ctx, index) {
          final brand = brands[index];
          return Dismissible(
            key: ValueKey(brand.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              brandProvider.removeItem(brand.id);
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                  leading: brand.imagePath != null && brand.imagePath.isNotEmpty
                      ? FutureBuilder<bool>(
                    future: File(brand.imagePath).exists(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // กำลังโหลด
                      }
                      if (snapshot.hasData && snapshot.data == true) {
                        return Image.file(
                          File(brand.imagePath),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        );
                      }
                      return Icon(Icons.broken_image, size: 50, color: Colors.red);
                    },
                  )
                      : Icon(Icons.image, size: 50, color: Colors.grey),
                title: Text(brand.name),
                subtitle: Text(
                    '${brand.category} - ${brand.date.toLocal().toString().split(' ')[0]}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => AddPage(brand: brand)),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => AddPage()));
        },
      ),
    );
  }
}
