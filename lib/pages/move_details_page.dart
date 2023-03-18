import 'package:flutter/material.dart';
import 'package:week3_movieapp/data/models/movie_model.dart';
import 'package:week3_movieapp/data/models/movie_model_impl.dart';
import 'package:week3_movieapp/data/vos/actor_vo.dart';
import 'package:week3_movieapp/data/vos/movie_vo.dart';
import 'package:week3_movieapp/network/api_constants.dart';
import 'package:week3_movieapp/resources/colors.dart';
import 'package:week3_movieapp/resources/dimens.dart';
import 'package:week3_movieapp/resources/strings.dart';
import 'package:week3_movieapp/widgets/actors_and_creators_section_view.dart';
import 'package:week3_movieapp/widgets/graddient_view.dart';
import 'package:week3_movieapp/widgets/rating_view.dart';
import 'package:week3_movieapp/widgets/title_text.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  MovieDetailsPage({required this.movieId});
  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  //Model
  final List<String> genreList=["Action","Adventure","Thriller"];

  //State Variable
  MovieModel movieModel = MovieModelImpl();
  List<ActorVO>? cast;
  List<ActorVO>? crew;
  MovieVO? movieDetails;

  @override
  void initState() {
    //Now Playing
    movieModel.getMovieDetails(widget.movieId)
        .then((movieDetails) {
      setState(() {
        this.movieDetails = movieDetails;
      });
    }).catchError((error, stacktrace) {
      debugPrint("Movie Cast ==> ${error}");
    });

    movieModel.getCreditByMovie(widget.movieId)
        .then((castAndCrew) {
      setState(() {
        this.cast = castAndCrew.first;
        this.crew = castAndCrew[1];
        //debugPrint("Heyyyy ==> ${this.cast?[0].name}");
      });
    }).catchError((error, stacktrace) {
      debugPrint("Error Cast ==> '/3/movie/${widget.movieId}/credits' ==> ${error}");
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HOME_SCREEN_BACKGROUND_COLOR,
        child: CustomScrollView(
          slivers:[
            MovieDetailSliverAppBarView(
                OnTapBack: () => Navigator.pop(context),
                movie: this.movieDetails,
            ),
            SliverList(
              delegate:SliverChildListDelegate(
                [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MARGIN_MEDIUM_2,
                    ),
                    child:TrailerSection(
                        genreList: this.movieDetails?.getGenreListAsStingList() ?? [],
                      storyLine: this.movieDetails?.overview ?? "",
                      runtime: this.movieDetails?.getMovieLength() ?? "",
                    ),
                  ),
                  SizedBox(height: MARGIN_LARGE),
                  ActorsAndCreatorsSectionView(
                      titleText : MOVIE_DETAIL_SCREEN_ACTORS_TITLE,
                      seeMoreText: "",
                      actorsList: this.cast,
                      seeMoreButtonVisibility:false),
                  SizedBox(height: MARGIN_LARGE,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2,),
                    child: AboutSectionFilmView(
                      movie: this.movieDetails,
                    ),
                  ),
                  SizedBox(height: MARGIN_LARGE,),
                  ActorsAndCreatorsSectionView(
                      titleText : MOVIE_DETAIL_SCREEN_CREATORS_TITLE,
                      seeMoreText: MOVIE_DETAIL_SCREEN_CREATORS_SEE_MORE,
                      actorsList: this.crew,
                      seeMoreButtonVisibility:false),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

class AboutSectionFilmView extends StatelessWidget {
  MovieVO? movie;
  AboutSectionFilmView({
  required this.movie
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children :[
        TitleText("About Film"),
        SizedBox(height: MARGIN_MEDIUM_2),
        AboutFilmInfoView("Original Title :",movie?.originalTitle?? ""),
        SizedBox(height: MARGIN_MEDIUM_2),
        AboutFilmInfoView("Type :",movie?.getGenreListAsCommaSeparatedString()??""),
        SizedBox(height: MARGIN_MEDIUM_2),
        AboutFilmInfoView("Production :",movie?.getProductionCountiesAsCommaSeperatedString() ?? ""),
        SizedBox(height: MARGIN_MEDIUM_2),
        AboutFilmInfoView("Premiere :",movie?.releaseDate ?? ""),
        SizedBox(height: MARGIN_MEDIUM_2),
        AboutFilmInfoView("Description :",movie?.overview?? ""),
      ]
    );
  }
}

class AboutFilmInfoView extends StatelessWidget {

  final String label;
  final String description;
  AboutFilmInfoView(this.label,this.description);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
     children:[
       Container(
         width: MediaQuery.of(context).size.width /4,
         child: Text(
           label,
         style: TextStyle(
          color : MOVIE_DETAIL_INFO_TEXT_COLOR,
           fontSize: MARGIN_MEDIUM_2,
           fontWeight: FontWeight.w600,
         ),
         ),
       ),
       SizedBox(width: MARGIN_CARD_MEDIUM_2,),
       Expanded(
         child :
         Text(
         description,
           style: TextStyle(
             color : Colors.white,
             fontSize: MARGIN_MEDIUM_2,
             fontWeight: FontWeight.w600,
           ),
         ),
       ),
     ]
    );
  }
}

class TrailerSection extends StatelessWidget {
  final List<String> genreList;
  final String storyLine;
  final String runtime;
  TrailerSection({required this.genreList, required this.storyLine,required this.runtime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieTimeAndGenreView(genreList: genreList,runtime: runtime,),
        SizedBox(height: MARGIN_MEDIUM_3),
        StoreyLineView(storyLine: storyLine,),
        SizedBox(height: MARGIN_MEDIUM_2),
        Row(
          children: [
            MovieDetailsScreenButtonView("PLAY TRAILER",PLAY_BUTTON_COLOR,
            Icon(
              Icons.play_circle_fill,
              color:Colors.black54,
            )
            ),
            SizedBox(width: MARGIN_CARD_MEDIUM_2),
            MovieDetailsScreenButtonView("RATE MOVIE",HOME_SCREEN_BACKGROUND_COLOR,
                Icon(
                  Icons.star,
                  color: PLAY_BUTTON_COLOR,
                ),isGhostButton: true),
          ],
        ),
      ],
    );
  }
}

class MovieDetailsScreenButtonView extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Icon buttonIcon;
  final bool isGhostButton;
  MovieDetailsScreenButtonView(
      this.title,this.backgroundColor,this.buttonIcon,
      {this.isGhostButton = false}
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.symmetric(horizontal: MARGIN_CARD_MEDIUM_2,),
      height:MARGIN_XXLARGE,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(MARGIN_LARGE,
        ),
        border: (isGhostButton) ?Border.all(
          color: Colors.white,
          width: 2,
        ) : null,
      ),
      child:Center(
        child: Row(
          children: [
            buttonIcon,
            SizedBox(width:MARGIN_MEDIUM),
            Text(title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: TEXT_REGULAR_2X,
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreyLineView extends StatelessWidget {
  final String storyLine;
  StoreyLineView({required this.storyLine});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(MOVIE_DETAIL_STORYLINES_TITLE),
        SizedBox(height: MARGIN_MEDIUM),
        Text(
          storyLine,
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
      ],
    );
  }
}

class MovieTimeAndGenreView extends StatelessWidget {
  const MovieTimeAndGenreView({
    Key? key,
    required this.genreList,
    required this.runtime,
  }) : super(key: key);

  final List<String> genreList;
  final String runtime;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(
          Icons.access_time,
          color:PLAY_BUTTON_COLOR,
        ),
        SizedBox(width: MARGIN_SMALL,),
        Text(runtime,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )
        ),
        SizedBox(width: MARGIN_MEDIUM,),
        ...genreList
          .map((genre)=>GenreChipView(genre))
              .toList(),
        Icon(
          Icons.favorite_border,
          color: Colors.white,
        ),
      ],
    );
  }
}

class GenreChipView extends StatelessWidget {
  final String genreText;
  GenreChipView(this.genreText);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(
          backgroundColor: MOVE_DETAILS_SCREEN_CHIP_BACKGROUND_COLOR_,
          label: Text(
            genreText,
            style: TextStyle(
              color:Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: MARGIN_SMALL,),
      ],
    );
  }
}

class MovieDetailSliverAppBarView extends StatelessWidget {
  final Function OnTapBack;
  final MovieVO? movie;
  MovieDetailSliverAppBarView({required this.OnTapBack, required this.movie});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: PRIMARY_COLOR,
      expandedHeight: MOVIE_DETAILS_SCREEN_SLIVER_APP_BAR_HEIGHT,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned.fill(
              child:  MovieDetailsAppBarImageView(
                imgUrl: movie?.posterPath ?? "",
              ),
            ),
            Positioned.fill(
              child:  GradientView(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MARGIN_XXLARGE,
                  left:MARGIN_MEDIUM_2,
                ),
                child: backButtonView(
                    (){
                      OnTapBack();
                    }
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MARGIN_XXLARGE + MARGIN_MEDIUM,
                  right:MARGIN_MEDIUM_2,
                ),
                child: SearchButtonView(),
              ),
            ),
            Align(
              alignment:Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left:MARGIN_MEDIUM_2,right:MARGIN_MEDIUM_2,
                  bottom: MARGIN_LARGE,
                ),
                child: MovieDetailsAppBarInfoView(
                  movie: this.movie
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailsAppBarInfoView extends StatelessWidget {
  final MovieVO? movie;
  MovieDetailsAppBarInfoView({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children:[
        Row(
          children: [
            MovieDetailsYearView(
              year: movie?.releaseDate?.substring(0,4) ?? ""
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingView(),
                    SizedBox(
                      height: MARGIN_SMALL,
                    ),
                    TitleText("${(movie?.voteCount??0).toString()} VOTES"),
                    SizedBox(
                      height: MARGIN_CARD_MEDIUM_2,
                    ),
                  ],
                ),
                SizedBox(width:MARGIN_MEDIUM),
                Text(
                  (movie?.voteAverage??0).toString(),
                  style: TextStyle(
                    color:Colors.white,
                    fontSize:MOVIE_DETAILS_RATING_TEXT_SIZE,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: MARGIN_MEDIUM_2,),
        Text(
          movie?.title ?? "",
          style: TextStyle(
            color:Colors.white,
            fontSize:TEXT_HEADING_2x,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class MovieDetailsYearView extends StatelessWidget {
  final String year;
  MovieDetailsYearView({required this.year});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MARGIN_XLARGE,
      padding: EdgeInsets.symmetric(horizontal:MARGIN_MEDIUM_2),
      decoration: BoxDecoration(
          color: PLAY_BUTTON_COLOR,
        borderRadius: BorderRadius.circular(MARGIN_LARGE),
      ),
      child: Center(
        child: Text(
          year,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SearchButtonView extends StatelessWidget {
  const SearchButtonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.search,
      color:Colors.white,
      size: MARGIN_XLARGE,
    );
  }
}

class backButtonView extends StatelessWidget {
  final Function OnTapBack;
  backButtonView(this.OnTapBack);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:(){
          OnTapBack();
        },
        child : Container(
          width: MARGIN_XXLARGE,
          height: MARGIN_XXLARGE,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:Colors.black54,
          ),
          child: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 36,
          ),
        )
    );
  }
}

class MovieDetailsAppBarImageView extends StatelessWidget {
  final String imgUrl;
  MovieDetailsAppBarImageView({required this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return Image.network(
      "$IMAGE_BASE_URL$imgUrl",
      fit: BoxFit.cover);
  }
}
