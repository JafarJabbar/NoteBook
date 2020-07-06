class Notes {
  int _note_id;
  int _category_id;
  String _note_title;
  String _note_content;
  int _note_priority;
  String _note_date;


  Notes(this._category_id, this._note_title, this._note_content,
      this._note_priority, this._note_date);

  Notes.withId(this._note_id, this._category_id, this._note_title,
      this._note_content, this._note_priority, this._note_date);

  Map<String, dynamic> toMap() {
    var map=Map<String, dynamic>();
    map['note_id'] = _note_id;
    map['category_id'] = _category_id;
    map['note_title'] = _note_title;
    map['note_content'] = _note_content;
    map['note_priority'] = _note_priority;
    map['note_date'] = _note_date;
    return map;
  }

  set note_id(int value) {
    _note_id = value;
  }

  int get note_id => _note_id;

  Notes.fromMap(Map<String, dynamic> map) {
    this._note_id = map['note_id'];
    this._category_id = map['category_id'];
    this._note_title = map['note_title'];
    this._note_content = map['note_content'];
    this._note_date = map['note_date'];
    this._note_priority = map['note_priority'];
  }

  int get category_id => _category_id;

  String get note_date => _note_date;

  int get note_priority => _note_priority;

  String get note_content => _note_content;

  String get note_title => _note_title;

  set category_id(int value) {
    _category_id = value;
  }

  set note_date(String value) {
    _note_date = value;
  }

  @override
  String toString() {
    return 'Notes{_note_id: $_note_id, _category_id: $_category_id, _note_title: $_note_title, _note_content: $_note_content, _note_priority: $_note_priority, _note_date: $_note_date}';
  }

  set note_priority(int value) {
    _note_priority = value;
  }

  set note_content(String value) {
    _note_content = value;
  }

  set note_title(String value) {
    _note_title = value;
  }


}
