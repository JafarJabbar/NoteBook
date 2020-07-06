class Categories{

  int _category_id;
  String _category_title;

  Categories.withId(this._category_id, this._category_title);

  Categories(this._category_title);

  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['category_id']=_category_id;
    map['category_title']=_category_title;
    return map;
  }


  set category_id(int value) {
    _category_id = value;
  }

  int get category_id => _category_id;

  Categories.fromMap(Map<String,dynamic> map){
    this._category_id=map['category_id'];
    this._category_title=map['category_title'];
  }

  @override
  String toString() {
    return 'Categories{_category_id: $_category_id, category_title: $_category_title}';
  }

  String get category_title => _category_title;

  set category_title(String value) {
    _category_title = value;
  }


}