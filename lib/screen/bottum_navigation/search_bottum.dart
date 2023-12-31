import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchResults = value.isNotEmpty ? ["Song 1", "Song 2", "Song 3"] : [];
            });
          },
          decoration: InputDecoration(
            hintText: "Search songs",
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(searchResults[index]),
            onTap: () {
              // Pass the selected song's index, context, and concatenatingAudioSources to the newSong function

            },
          );
        },
      ),
    );
  }
}