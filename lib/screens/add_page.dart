// lib/screens/add_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/brand_item.dart';
import '../provider/brand_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPage extends StatefulWidget {
  final BrandItem? brand;
  const AddPage({super.key, this.brand});

  @override
  AddPageState createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _category;
  late DateTime _selectedDate;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _name = widget.brand?.name ?? '';
    _category = widget.brand?.category ?? 'Casual';
    _selectedDate = widget.brand?.date ?? DateTime.now();
    _imagePath = widget.brand?.imagePath;
  }

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final brandProvider = Provider.of<BrandProvider>(context, listen: false);
      final brandItem = BrandItem(
        id: widget.brand?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _name,
        category: _category,
        date: _selectedDate,
        imagePath: _imagePath ?? widget.brand?.imagePath ?? '', // ใช้รูปเดิมถ้าไม่ได้เลือกใหม่
      );

      if (widget.brand == null) {
        brandProvider.addItem(brandItem);
      } else {
        brandProvider.updateItem(brandItem);
      }

      Navigator.of(context).pop();
    }
  }


  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path; // อัปเดตเฉพาะเมื่อเลือกรูปใหม่
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.brand == null ? 'Add Brand' : 'Edit Brand')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Brand Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a brand name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              DropdownButtonFormField(
                value: _category,
                items: ['Casual', 'Sportswear', 'Formal']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value.toString();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),SizedBox(
                height: 100,
                width: 100,
                child: _imagePath != null && _imagePath!.isNotEmpty && File(_imagePath!).existsSync()
                    ? Image.file(
                  File(_imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("Error loading image: $error");
                    return Icon(Icons.broken_image, size: 50, color: Colors.red);
                  },
                )
                    : (widget.brand?.imagePath != null &&
                    widget.brand!.imagePath.isNotEmpty &&
                    File(widget.brand!.imagePath).existsSync())
                    ? Image.file(
                  File(widget.brand!.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("Error loading old image: $error");
                    return Icon(Icons.broken_image, size: 50, color: Colors.red);
                  },
                )
                    : Placeholder(fallbackHeight: 100, fallbackWidth: 100),
              ),
              TextButton(
                onPressed: _selectImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('Save'),
                  ),
                  if (widget.brand != null)
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<BrandProvider>(context, listen: false).removeItem(widget.brand!.id);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Delete'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}