import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:week3_movieapp/network/dataagents/dio_move_data_agent_impl.dart';
import 'package:week3_movieapp/network/dataagents/retrofit_data_agent_impl.dart';
import 'pages/home_page.dart';

void main() async{
  await Hive.initFlutter();

  Hive.registerAdapter(ActorVOAdapter());

  //HttpMovieDataAgentImpl().getNowPlayingMovies(1);
  //DioMovieDataAgentImpl().getNowPlayingMovies(1);
  //RetrofitDataAgentImpl().getNowPlayingMovies(1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

