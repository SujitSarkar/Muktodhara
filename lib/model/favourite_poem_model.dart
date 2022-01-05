class FavouritePoemModel{
  int? _id;
  String? _postId;
  String? _poemName;
  String? _firstLine;
  String? _poem;

  FavouritePoemModel(this._postId, this._poemName,this._firstLine,this._poem);

  int? get id => _id;
  String get postId => _postId!;
  String get poemName => _poemName!;
  String get firstLine => _firstLine!;
  String get poem => _poem!;

  // set postId(String value) => _postId = value;
  // set poemName(String value) => _poemName = value;
  // set firstLine(String value) => _firstLine = value;



  //Convert a note object to mop object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = _id;
    }

    map['postId'] = _postId;
    map['poemName'] = _poemName;
    map['firstLine'] = _firstLine;
    map['poem'] = _poem;
    return map;
  }

  //Extract a note object from a map object
  FavouritePoemModel.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _postId = map['postId'];
    _poemName = map['poemName'];
    _firstLine = map['firstLine'];
    _poem = map['poem'];
  }
}