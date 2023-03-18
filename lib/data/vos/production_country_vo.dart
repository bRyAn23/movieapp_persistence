import 'package:json_annotation/json_annotation.dart';
part 'production_country_vo.g.dart';

@JsonSerializable()
class ProductionCountryVO{
  @JsonKey(name: "iso_3166_1")
  String? iso_3166_1;
  @JsonKey(name: "name")
  String? name;

  ProductionCountryVO(this.iso_3166_1, this.name);

  //Network data to VO
  factory ProductionCountryVO.fromJson(Map<String, dynamic> json) => _$ProductionCountryVOFromJson(json);

  //VO to Json
  Map<String, dynamic> toJson() => _$ProductionCountryVOToJson(this);

}