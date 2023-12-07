
import 'package:first_project/model/addres_folder.dart';
import 'package:flutter/material.dart';

class AlbumList extends StatelessWidget {


  AlbumList({Key? key,}) : super(key: key);
  TextStyle style =const TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: AddressFolder().Location(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              List<String> address=[];
              List<String> file=[];
                for(int i=0; i<snapshot.data!.length;i++){
                  List<String> parts = snapshot.data![i].split('/');
                  String fileName = parts[parts.length - 2];
                  if (file.isEmpty) {
                    file.add(fileName);
                  }else {
                    if (file.last!=fileName) {
                      file.add(fileName);
                    }
                  }
                }
                address =file.toSet().toList();


              return ListTile(
                title: Text(maxLines: 1,snapshot.data![index],style: TextStyle(color: Colors.white),),
                subtitle: Text(maxLines: 1,snapshot.data![index]),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  namefolder() async {
    List<String> path = await AddressFolder().getAddress();
  }
}
