import 'dart:convert';

Poem poemFromJson(String str) => Poem.fromJson(json.decode(str));

String poemToJson(Poem data) => json.encode(data.toJson());

class Poem {
  Poem({
    this.result,
  });

  Result? result;

  factory Poem.fromJson(Map<String, dynamic> json) => Poem(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result!.toJson(),
  };
}

class Result {
  Result({
    this.poemName,
    this.poem,
  });

  String? poemName;
  String? poem;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    poemName: json["poem_name"],
    poem: json["poem"],
  );

  Map<String, dynamic> toJson() => {
    "poem_name": poemName,
    "poem": poem,
  };
}
