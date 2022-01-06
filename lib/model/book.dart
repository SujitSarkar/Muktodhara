import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

class Book {
  Book({
    this.result,
  });

  List<PoemModel>? result;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    result: List<PoemModel>.from(json["result"].map((x) => PoemModel.fromJson(x))),
  );
}

class PoemModel {
  PoemModel({
    this.bookId,
    this.postId,
    this.poemName,
    this.firstLine,
    this.poem,
  });

  String? bookId;
  String? postId;
  String? poemName;
  dynamic firstLine;
  String? poem;

  factory PoemModel.fromJson(Map<String, dynamic> json) => PoemModel(
    bookId: json["book_id"],
    postId: json["post_id"],
    poemName: json["poem_name"],
    firstLine: json["first_line"],
    poem: json["poem"],
  );
}
