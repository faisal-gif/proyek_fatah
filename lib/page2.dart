import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../DbHelper/DbHelper.dart';
import 'EntryOut.dart';
import 'FireDatabase/Database.dart';
import 'Models/Item.dart';

//pendukung program asinkron
class Page2 extends StatefulWidget {
  @override
    static String tag = 'page2-page';
  Page2State createState() => Page2State();
 
}

class Page2State extends State<Page2> {
  List<String> listItem = ["Delete", "Update"];
  String _newValuePerem = "";
  DbHelper dbHelper = DbHelper();
  int count = 0;
  int countUser = 0;

  List<Item> itemList;
  @override
  Widget build(BuildContext context) {
    final User userArgs = ModalRoute.of(context).settings.arguments;
    String id = userArgs.uid;
    if (itemList == null) {
      itemList = List<Item>();
    }
    return Column(children: [
         SizedBox(height: 8.0),
      Container(
        alignment: Alignment.center,
        child: Text('Barang Masuk'),
      ),
      SizedBox(height: 10.0),
      Expanded(
        child:fireList(id),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10, right: 10),
        alignment: Alignment.bottomRight,
        child: SizedBox(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
             await navigateToEntryForm(context, null,id,null,null,null,null,null);
             
            },
          ),
        ),
      ),
    ]);
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item item, String id,
      String nama, String kategori, int stok, int price, String docID) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryOut(item,id,nama,kategori,stok,price,docID);
    }));
    return result;
  }
  
  StreamBuilder fireList(String a) {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseF().readBarang(a),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              alignment: Alignment.center,
              child: Text('Loading',
                  style: TextStyle(fontWeight: FontWeight.bold)));
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data.docs[index].data();
              String docID = snapshot.data.docs[index].id;
              String name = noteInfo['name'];
              String kategori = noteInfo['kategori'];
              int price = noteInfo['price'];
              int stock = noteInfo['stock'];

              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.cake_rounded),
                  ),
                  title: Text(
                    name,
                    style: textStyle,
                  ),
                  subtitle: Text(stock.toString()),
                  trailing: GestureDetector(
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      icon: Icon(Icons.menu),
                      items: listItem.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String changeValue) async {
                        if (changeValue == "Delete") {
                         DatabaseF.deleteBarang(uid: a,docId: docID);
                        } else if (changeValue == "Update") {
                          await navigateToEntryForm(
                              context, null,a,name,kategori, price, stock, docID);
                        }
                        ;
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  
  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //TODO 1 Select data dari DB
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
