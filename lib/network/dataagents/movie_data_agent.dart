import 'package:week3_movieapp/data/vos/actor_vo.dart';
import 'package:week3_movieapp/data/vos/genre_vo.dart';
import 'package:week3_movieapp/data/vos/movie_vo.dart';

abstract class MovieDataAgent{
  Future<List<MovieVO>?> getNowPlayingMovies(int page);
  Future<List<MovieVO>?> getPopularMovies(int page);
  Future<List<MovieVO>?> getTopRatedMovies(int page);
  Future<List<GenreVO>?> getGenres();
  Future<List<MovieVO>?> getMoviesByGenre(int genreId);
  Future<List<ActorVO>?> getActors(int genreId);
  Future<MovieVO?> getMovieDetail(int movieId);
  Future<List<List<ActorVO>?>> getCreditByMovie(int movieId);
}