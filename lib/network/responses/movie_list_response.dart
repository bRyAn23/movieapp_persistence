import 'package:json_annotation/json_annotation.dart';
import 'package:week3_movieapp/data/vos/date_vo.dart';
import 'package:week3_movieapp/data/vos/movie_vo.dart';

part 'movie_list_response.g.dart';

@JsonSerializable()
class MovieListResponse{

  @JsonKey(name: "page")
  late int? page;

  @JsonKey(name: "results")
  late List<MovieVO>? results;

  @JsonKey(name: "dates")
  late DateVO? dates;

  MovieListResponse(
      this.page,
      this.results,
      this.dates
      );

  //Network data to VO
  factory MovieListResponse.fromJson(Map<String, dynamic> json)
  => _$MovieListResponseFromJson(json);

  //VO to Json
  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);

}