import 'package:json_annotation/json_annotation.dart';
//To geneate file name
part 'genre_vo.g.dart';
@JsonSerializable()
class GenreVO{
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;

  GenreVO(
      this.id,
      this.name);

  //Network data to VO
  factory GenreVO.fromJson(Map<String, dynamic> json) => _$GenreVOFromJson(json);

  //VO to Json
  Map<String, dynamic> toJson() => _$GenreVOToJson(this);

  @override
  String toString() {
    return 'GenreVO{id: $id, name: $name}';
  }
}