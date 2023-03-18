import 'package:week3_movieapp/data/models/movie_model.dart';
import 'package:week3_movieapp/data/vos/actor_vo.dart';
import 'package:week3_movieapp/data/vos/genre_vo.dart';
import 'package:week3_movieapp/data/vos/movie_vo.dart';
import 'package:week3_movieapp/network/dataagents/movie_data_agent.dart';
import 'package:week3_movieapp/network/dataagents/retrofit_data_agent_impl.dart';

class MovieModelImpl extends MovieModel{

  MovieModelImpl._internal();
  static MovieModelImpl _singleton = MovieModelImpl._internal();
  factory MovieModelImpl(){
    return _singleton;
  }

  MovieDataAgent _dataAgent = RetrofitDataAgentImpl();

  @override
  Future<List<MovieVO>?> getNowPlayingMovies() {
    return _dataAgent.getNowPlayingMovies(1);
  }

  @override
  Future<List<MovieVO>?> getPopularMovies() {
    return _dataAgent.getPopularMovies(1);
  }

  @override
  Future<List<MovieVO>?> getTopRatedMovies() {
    return _dataAgent.getTopRatedMovies(1);
  }

  @override
  Future<List<GenreVO>?> getGenres() {
    return _dataAgent.getGenres();
  }

  @override
  Future<List<MovieVO>?> getMoviesByGenre(int genreId) {
    return _dataAgent.getMoviesByGenre(genreId);
  }

  @override
  Future<List<ActorVO>?> getActors() {
    return _dataAgent.getActors(1);
  }

  @override
  Future<MovieVO?> getMovieDetails(int movieId) {
    return _dataAgent.getMovieDetail(movieId);
  }

  @override
  Future<List<List<ActorVO>?>> getCreditByMovie(int movieId) {
    return _dataAgent.getCreditByMovie(movieId);
  }

}