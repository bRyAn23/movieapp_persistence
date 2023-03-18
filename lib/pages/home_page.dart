import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:week3_movieapp/data/models/movie_model.dart';
import 'package:week3_movieapp/data/models/movie_model_impl.dart';
import 'package:week3_movieapp/data/vos/actor_vo.dart';
import 'package:week3_movieapp/data/vos/genre_vo.dart';
import 'package:week3_movieapp/data/vos/movie_vo.dart';
import 'package:week3_movieapp/pages/move_details_page.dart';
import 'package:week3_movieapp/resources/colors.dart';
import 'package:week3_movieapp/resources/dimens.dart';
import 'package:week3_movieapp/resources/strings.dart';
import 'package:week3_movieapp/viewitems/banner_view.dart';
import 'package:week3_movieapp/viewitems/movie_view.dart';
import 'package:week3_movieapp/viewitems/showcase_view.dart';
import 'package:week3_movieapp/widgets/actor_item_view.dart';
import 'package:week3_movieapp/widgets/actors_and_creators_section_view.dart';
import 'package:week3_movieapp/widgets/see_more_text.dart';
import 'package:week3_movieapp/widgets/title_text.dart';
import 'package:week3_movieapp/widgets/title_text_with_see_more_view.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> genreList= ["Action","Adventure","Horror","Comedy","Thriller","Drama"];

  //State Variables
  List<MovieVO>? nowPlayingMovie;
  List<MovieVO>? popularMovies;
  List<MovieVO>? topRatedMovies;
  List<MovieVO>? moviesByGenre;
  List<GenreVO>? genres;
  List<ActorVO>? actors;
  MovieModel movieModel = MovieModelImpl();

  @override
  void initState() {
    //Now Playing
    movieModel.getNowPlayingMovies()
    .then((movieList){
      setState(() {
        nowPlayingMovie = movieList;
      });
    }).catchError((error,stacktrace){
       debugPrint(error.toString());
    });

    //Popular Movies
    movieModel.getPopularMovies()
        .then((movieList){
      setState(() {
        popularMovies = movieList;
      });
    }).catchError((error,stacktrace){
      debugPrint(error.toString());
    });

    //Top Rated Movies
    movieModel.getTopRatedMovies()
        .then((movieList){
      setState(() {
        topRatedMovies = movieList;
      });
    }).catchError((error,stacktrace){
      debugPrint(error.toString());
    });

    //Genres
    movieModel.getGenres()
        .then((genreList){
      setState(() {
        this.genres = genreList;
      });
      //getMovieByGenreBy 0 position id of genres
      _getMovieByGenre(genres?.first.id ?? 0);
    }).catchError((error,stacktrace){
      debugPrint(error.toString());
    });

    //Actors
    movieModel.getActors()
        .then((actorList){
      setState(() {
        actors = actorList;
      });
    }).catchError((error,stacktrace){
      debugPrint(error.toString());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: PRIMARY_COLOR,
          title: const Center(
            child: Text(
              MAIN_SCREEN_APP_BAR_TITLE,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          leading: const Icon(
            Icons.menu,
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(
                top: 0,
                left: 0,
                bottom: 0,
                right: MARGIN_MEDIUM_2,
              ),
              child: Icon(
                Icons.search,
              ),
            ),
          ]),
      body: Container(
        color: HOME_SCREEN_BACKGROUND_COLOR,
        child: SingleChildScrollView(
          child: Column(children: [
            BannerSectionView(
              movieList: popularMovies?.take(5).toList(),
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            BestPopularMoviesAndSerialSectionView(
                OnTapMovie: (movieId)=> _navigateToMovieDetailScreen(context,movieId),
                movieList: nowPlayingMovie,
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            CheckMovieShowTimeSectionView(),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            GenreSectionView(
                OnTapMovie:
                (movieId)=>_navigateToMovieDetailScreen(context, movieId),
                genreList: genres,
              movieByGenre: moviesByGenre,
              onChooseGenre: (genreId){
                  if(genreId != null){
                    _getMovieByGenre(genreId);
                  }
              }
              ,
            ),

            SizedBox(
              height: MARGIN_LARGE,
            ),
            ShowCasesSectionView(topRatedMovies: this.topRatedMovies,),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            ActorsAndCreatorsSectionView(
                  titleText: BEST_ACTOR_TITLE,
                  seeMoreText: BEST_ACTOR_SEE_MORE,
                  actorsList: this.actors),
            SizedBox(
              height: MARGIN_LARGE,
            ),
          ]),
        ),
      ),
    );
  }
  void _navigateToMovieDetailScreen(BuildContext context, int? movieId) {
    if(movieId != null)
      {
        Navigator.push(context,MaterialPageRoute(
            builder: (context)=> MovieDetailsPage(movieId: movieId,)
        ));
      }

  }
  void _getMovieByGenre(int genreID){
    movieModel.getMoviesByGenre(genreID)
        .then((moviesByGenre) {
    setState(() {
    this.moviesByGenre = moviesByGenre;
    });
    }).catchError((error, stacktrace) {
    debugPrint(error.toString());
    });
  }
}

class GenreSectionView extends StatelessWidget {
    const GenreSectionView({
      required this.OnTapMovie,
      required this.genreList,
      required this.movieByGenre,
      required this.onChooseGenre,
  });
  final List<GenreVO>? genreList;
  final List<MovieVO>? movieByGenre;
  final Function(int?) OnTapMovie;
  final Function(int?) onChooseGenre;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_2,),
          child: DefaultTabController(
              length: genreList?.length ?? 0,
              child: TabBar(
                  isScrollable: true,
                  indicatorColor :PLAY_BUTTON_COLOR,
                  unselectedLabelColor: HOME_SCREEN_LIST_TITLE_COLOR,
                  tabs: genreList
                      ?.map(
                        (genre)=> Tab(
                      child: Text(genre?.name ?? "",),
                    ),
                  ).toList() ?? [],
                  onTap: (index)
                  {
                    onChooseGenre(genreList?[index].id ?? 0);
                  }
              ),
          ),
        ),
        Container(
          color:PRIMARY_COLOR,
          padding: EdgeInsets.only(
              top:MARGIN_MEDIUM_2,
            bottom: MARGIN_LARGE,
          ),
          child:HorizontalMovieListVIew(
              OnTapMovie: (movieId) => this.OnTapMovie(movieId),
              movieList: movieByGenre,
          ),
        ),
      ],
    );
  }
}

class CheckMovieShowTimeSectionView extends StatelessWidget {
  const CheckMovieShowTimeSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      height: SHOWTIME_SECTION_HEIGHT,
      padding: EdgeInsets.all(MARGIN_LARGE),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MAIN_SCREEN_CHECK_MOVIE_SHOWTIMES,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_HEADING_1x,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              SeeMoreText(MAIN_SCREEN_SEE_MORE, textColor: Colors.yellow),
            ],
          ),
          Spacer(),
          Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: BANNER_PLAY_BUTTON_SIZE,
          ),
        ],
      ),
    );
  }
}



class ShowCasesSectionView extends StatelessWidget {
  final List<MovieVO>? topRatedMovies;
  const ShowCasesSectionView({
    required this.topRatedMovies
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: TitleTextWithSeeMoreView(
            SHOW_CASES_TITLE,
            SHOW_CASES_SEE_MORE,
          ),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Container(
          height: SHOW_CASES_HEIGHT,
          child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left:MARGIN_MEDIUM_2,),
              children: topRatedMovies?.map(
                (topRatedMovie) => ShowCaseView(
                    movie: topRatedMovie))
            .toList() ?? [],
          ),
        ),
      ],
    );
  }
}

class BestPopularMoviesAndSerialSectionView extends StatelessWidget {
  final Function(int?) OnTapMovie;
  final List<MovieVO>? movieList;
  BestPopularMoviesAndSerialSectionView(
  {required this.OnTapMovie,required this.movieList});
  //final List<MovieVO>?  nowPlayingMovies;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(
          left: MARGIN_MEDIUM_2,
        ),
        child: TitleText(BEST_POPULAR_FILMS_AND_SERIALS),
      ),
      SizedBox(
        height: MARGIN_MEDIUM,
      ),
      HorizontalMovieListVIew(
          OnTapMovie: (movieId) => this.OnTapMovie(movieId),
          movieList: this.movieList
      ),
    ]);
  }
}

class HorizontalMovieListVIew extends StatelessWidget {
  final Function(int?) OnTapMovie;
  final List<MovieVO>? movieList;
  HorizontalMovieListVIew({
    required this.OnTapMovie,
    required this.movieList
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_HEIGHT,
      child: ListView.builder(
        padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
        itemCount: movieList?.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return
          GestureDetector(
            onTap: ()=> OnTapMovie(movieList?[index].id),
            child: MovieView(
            movie: movieList?[index],
            ),
          );
          },
          ),
      );
  }
}

class BannerSectionView extends StatefulWidget {
  final List<MovieVO>? movieList;
  BannerSectionView({required this.movieList});
  @override
  State<BannerSectionView> createState() => _BannerSectionViewState();
}

class _BannerSectionViewState extends State<BannerSectionView> {
  double _postion = 0.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4,
          child: PageView(
            onPageChanged: (page){
              setState((){//refresh widget rebuild nearest build method
                _postion = page.toDouble();
              });
            },
              children: widget.movieList?.map(
                  (movie) => BannerView(
                    movie: movie,
                  )
              ).toList() ?? [],
          //     [
          //   BannerView(),
          //   BannerView(),
          //   BannerView(),
          // ]
          ),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        DotsIndicator(
          dotsCount: widget.movieList?.length ?? 1,//movieList inside widget
          position: _postion,
          decorator: DotsDecorator(
            color: HOME_SCREEN_BANNER_DOTS_INACTIVE_COLOR,
            activeColor: PLAY_BUTTON_COLOR,
          ),
        ),
      ],
    );
  }
}

