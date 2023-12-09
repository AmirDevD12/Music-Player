
import 'package:first_project/model/addres_folder.dart';
import 'package:first_project/screen/folder/showSongFolder.dart';
import 'package:flutter/material.dart';

class AlbumList extends StatelessWidget {


  AlbumList({Key? key,}) : super(key: key);
  TextStyle style =const TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    // namefolder();
    return FutureBuilder<List<String>>(
      future: AddressFolder().location(),
      builder: (context, snapshot) {
        List<String> file=[];
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ,
            itemBuilder: (context, index) {
              for(int i=0; i<snapshot.data!.length-1;i++){
                List<String> parts = snapshot.data![index].split('/');
                String fileName = parts[parts.length-1];
                  file.add(fileName);
              }
              return ListTile(
                title: Text(maxLines: 1,file[index],style: TextStyle(color: Colors.white),),
                subtitle: Text(maxLines: 1,snapshot.data![index],style: TextStyle(fontSize: 18),),
                leading: Image.asset("assets/icon/folder.png",color:Colors.deepPurpleAccent ,),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowSongFolder(path: snapshot.data![index],nameFile:file[index])));
                  
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  // namefolder() async {
  //   List<String> path = await AddressFolder().getSongs();
  //   print(path);
  // }
}
