import 'package:first_project/list_song.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
class PlayPage extends StatefulWidget {
  final SongModel songModel;
  final AudioPlayer audioPlayer;
  const PlayPage({super.key, required this.songModel, required this.audioPlayer});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  Duration duration=const Duration();
  Duration position=const Duration();
  bool isPlaying=false;
  @override
  void initState() {
    // TODO: implement initState
    playSong();
  }
  playSong(){
    try{
      widget.audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(widget.songModel.uri!))
      );
      widget.audioPlayer.play();
      isPlaying=true;
      print("play");
      widget.audioPlayer.durationStream.listen((event) {
        setState(() {
          duration=event!;
        });
      });
      widget.audioPlayer.positionStream.listen((event) {
        setState(() {
          position=event;
        });
      });
    }on Exception{
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed:(){
                     Navigator.pop(context);
                      } ,
                      icon:const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.white,size: 40,) ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                children: [
                   Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     CircleAvatar(
                       radius: 100,
                       child: QueryArtworkWidget(
                           artworkBorder: BorderRadius.all(Radius.circular(100)),
                           artworkWidth: 200,artworkHeight: 200,
                           id: widget.songModel.id,
                           type: ArtworkType.AUDIO
                       ),
                     )
                    ],
                  ),
                  Row(
                    children: [
                       SizedBox(width: 300,
                        child: ListTile(
                          title: Text(widget.songModel.displayName,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                          subtitle: Text(widget.songModel.displayNameWOExt,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: IconButton(
                            onPressed:(){},
                            icon:Icon(Icons.heart_broken)),
                      )
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(child: Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        min: const Duration(milliseconds: 0).inSeconds.toDouble(),
                        onChanged:(value){
                        setState(() {
                          changeSeconds(value.toInt());
                          value=value;
                        });
                      },)),
                    ],
                  ),     SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(position.toString().split(".")[0]),
                        Text(duration.toString().split(".")[0]),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed:(){} ,
                          icon:Icon(Icons.repeat,size: 40,color: Colors.white,)),
                      IconButton(
                          onPressed:(){} ,
                          icon:Icon(Icons.skip_previous_rounded,size: 40,color: Colors.white,)),
                      IconButton(
                          onPressed:(){
                            setState(() {
                              if(isPlaying){
                                widget
                                .audioPlayer.pause();
                              }else{
                                widget.audioPlayer.play();
                              }
                              isPlaying=!isPlaying;
                            });

                          } ,
                          icon:Icon(isPlaying?Icons.pause:Icons.play_arrow,size: 40,color: Colors.white,)),
                      IconButton(
                          onPressed:(){} ,
                          icon:Icon(Icons.skip_next,size: 40,color:
                            Colors.white
                            ,)),
                      IconButton(
                          onPressed:(){} ,
                          icon:Icon(Icons.arrow_drop_down_circle,size: 40,color: Colors.white,)),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed:(){} ,
                          icon:Icon(Icons.menu,size: 40,color: Colors.white,)),
                      IconButton(
                          onPressed:(){} ,
                          icon:Icon(Icons.add_circle_outline,size: 40,color: Colors.white,)),
                    ],
                  ),
                  Container(
                    height: 1000,
                    child: FutureBuilder<List<SongModel>>(
                      future: SongList().getSongs(),
                      builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(snapshot.data![index].title),
                                subtitle: Text(snapshot.data![index].displayName),
                                leading: QueryArtworkWidget(
                                    id: snapshot.data![index].id,
                                    type: ArtworkType.AUDIO
                                ),
                                onTap: (){
                                  // playSong(item.data![index].uri);
                                  // Navigator.push(
                                  //     context, MaterialPageRoute(
                                  //     builder: (context)=>PlayPage(songModel:snapshot.data![index],audioPlayer: audioPlayer,
                                  //     )));
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  void changeSeconds(int seconds){
   Duration duration=Duration(seconds: seconds);
   widget.audioPlayer.seek(duration);
  }
}
