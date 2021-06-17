class Kategori {
  int _id;
  String _name;
 
  int get id => _id;
  String get name => this._name;
  set name(String value) => this._name = value;
  
// konstruktor versi 1
  Kategori(this._name);
// konstruktor versi 2: konversi dari Map ke Item
  Kategori.fromMapKategori(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    
  }
  // konversi dari Item ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
   
    return map;
  }
}
