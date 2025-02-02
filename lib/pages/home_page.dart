import 'dart:convert';

import 'package:basicnbaapi/model/team.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //List of teams
  List<Team> teams = [];

  //get teams
  Future getTeams() async {
    var response =
        await http.get(Uri.https('api.balldontlie.io', '/v1/teams'), headers: {
      'Accept': 'application/json',
      'Authorization': 'e790c98d-3158-45d4-bb7e-5f7e58fbbf9a'
    });

    var data = jsonDecode(response.body);

    for (var eachTeam in data['data']) {
      final Team team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );
      teams.add(team);
    }

    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          //if done loading show team data
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  border: Border.all(color: Colors.deepPurple),
                ),
                child: ListTile(
                  title: Text(teams[index].abbreviation),
                  subtitle: Text(teams[index].city),
                ),
              ),
            );
          }
          //if not show loading
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
