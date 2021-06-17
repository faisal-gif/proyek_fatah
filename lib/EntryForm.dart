import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/Item.dart';
import '../Models/kategori.dart';

import 'DbHelper/DbHelper.dart';
import 'FireDatabase/Database.dart';

class EntryForm extends StatefulWidget {
  final Item item;
  final String id;
  final String nama;
  final String kategori;
  final String docId;
  final int stok;
  final int price;

  EntryForm(this.item, this.id, this.nama, this.kategori, this.stok, this.price,
      this.docId);
  @override
  EntryFormState createState() => EntryFormState(this.item, this.id, this.nama,
      this.kategori, this.stok, this.price, this.docId);
}

//class controller
class EntryFormState extends State<EntryForm> {
  Item item;
  String id;
  String nama;
  String kategori;
  String docId;
  int stok;
  int price;
  EntryFormState(this.item, this.id, this.nama, this.kategori, this.stok,
      this.price, this.docId);
  DbHelper dbHelper = DbHelper();
  int countKat = 0;
  String _val = "Kategori";

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  List<String> _animals = <String>[];
  initState() {
    super.initState();

    // when loading your widget for the first time, loads animals from sqflite
    _loadAnimals();
  }
  _loadAnimals() async {
    // gets data from sqflite
    final loadedAnimals = await dbHelper.selectKategori();
    setState(() {
      // converts sqflite row data to List<String>, updating state
      _animals = loadedAnimals.toList();
    });

   
  }

  Widget build(BuildContext context) {
    //kondisi
   if (nama != null) {
      nameController.text = nama;
      priceController.text = price.toString();
      _val = kategori;
      stockController.text = stok.toString();
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          title: item == null ? Text('Tambah') : Text('Ubah'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              // nama
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nama Barang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              // harga
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              //stock
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              //kategori

              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: DropdownButton<String>(
                    hint: Text(_val),
                    items: _animals.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        _val = newValue;
                      });
                    }),
              ),
              // tombol button
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    // tombol simpan
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (nama == null) {
                            // tambah data
                            DatabaseF.addItem(
                                i: id,
                                name: nameController.text,
                                kategori: _val,
                                stock: int.parse(stockController.text),
                                price: int.parse(priceController.text));
                          } else {
                            // ubah data
                            DatabaseF.updateItem(
                                uid: id,
                                name: nameController.text,
                                kategori: _val,
                                stock: int.parse(stockController.text),
                                price: int.parse(priceController.text),
                                docId: docId);
                          }
                          // kembali ke layar sebelumnya dengan membawa objek item
                          Navigator.pop(context, item);
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    // tombol batal
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
