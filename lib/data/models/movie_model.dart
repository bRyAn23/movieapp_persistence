//Data Manipulator
import 'package:week3_movieapp/data/vos/actor_vo.dart';
import 'package:week3_movieapp/data/vos/genre_vo.dart';
import 'package:week3_movieapp/data/vos/movie_vo.dart';

abstract class MovieModel{
  Future<List<MovieVO>?> getNowPlayingMovies();
  Future<List<MovieVO>?> getPopularMovies();
  Future<List<MovieVO>?> getTopRatedMovies();
  Future<List<GenreVO>?> getGenres();
  Future<List<MovieVO>?> getMoviesByGenre(int genreId);
  Future<List<ActorVO>?> getActors();
  Future<MovieVO?> getMovieDetails(int movieId);
  Future<List<List<ActorVO>?>> getCreditByMovie(int movieId);
}