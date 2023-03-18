import 'package:json_annotation/json_annotation.dart';

part 'spoken_language_vo.g.dart';

@JsonSerializable()
class SpokenLanguageVO{

  @JsonKey(name:"english_name")
  String? englishName;
  @JsonKey(name:"iso_639_1")
  String? iso6391;
  @JsonKey(name:"name")
  String? name;

  SpokenLanguageVO(this.englishName, this.iso6391, this.name);

  //Network data to VO
  factory SpokenLanguageVO.fromJson(Map<String, dynamic> json) => _$SpokenLanguageVOFromJson(json);

  //VO to Json
  Map<String, dynamic> toJson() => _$SpokenLanguageVOToJson(this);
}