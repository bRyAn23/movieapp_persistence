import 'package:json_annotation/json_annotation.dart';
import 'package:week3_movieapp/data/vos/genre_vo.dart';


part 'get_genres_response.g.dart';

@JsonSerializable()
class GetGenresResponse{

  @JsonKey(name: "genres")
  List<GenreVO>? genres;

  GetGenresResponse(
     this.genres
      );

  //Network data to VO
  factory GetGenresResponse.fromJson(Map<String, dynamic> json)
  => _$GetGenresResponseFromJson(json);

  //VO to Json
  Map<String, dynamic> toJson() => _$GetGenresResponseToJson(this);

}