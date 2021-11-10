import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  Book({
    this.result,
  });

  List<Result>? result;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.postId,
    this.poemName,
    this.firstLine,
  });

  String? postId;
  String? poemName;
  dynamic firstLine;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    postId: json["post_id"],
    poemName: json["poem_name"],
    firstLine: json["first_line"],
  );

  Map<String, dynamic> toJson() => {
    "post_id": postId,
    "poem_name": poemName,
    "first_line": firstLine,
  };
}
