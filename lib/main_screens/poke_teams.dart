import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_team_planner/main_screens/pokemon_team_detail_page.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poke_team_planner/utils/boxes.dart';
import 'package:poke_team_planner/utils/pokemon_team.dart';

//TODO: use https://pokeapi.co/api/v2//type/12/ for damage calculations
//TODO: figure out firebase db
//TODO: add button to create a team
  //TODO: team should have name, be in a listview, maybe show first pokemon pic, have number of pokemon in team
//TODO: create actual team display
  //TODO: team name, list of pokemon with types, part that shows strengths/weaknesses based on typing
//TODO: add a dropdown for poke_detail page to add to team

class PokeTeams extends StatefulWidget {
  const PokeTeams({Key? key}) : super(key: key);

  @override
  State<PokeTeams> createState() => _PokeTeamsState();

}

class _PokeTeamsState extends State<PokeTeams> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  void onClickedDone(String name) {
    addPokeTeam(name);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PokeAppBar(),
      body: ValueListenableBuilder<Box<PokemonTeam>>(
        valueListenable: Boxes.getPokemonTeams().listenable(),
        builder: (context, box, _) {
          final pokemonTeams = box.values.toList().cast<PokemonTeam>().where((element) => element.userID == FirebaseAuth.instance.currentUser?.uid).toList();

          return buildContent(pokemonTeams);
        },
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("TEST"),
                  content: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 8),
                          buildName(),
                          SizedBox(height: 8),
                          // buildAmount(),
                          SizedBox(height: 8),
                          // buildRadioButtons(),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text("Add"),
                      onPressed: () async {
                        final isValid = formKey.currentState!.validate();

                        if (isValid) {
                          final name = nameController.text;

                          addPokeTeam(name);

                          Navigator.of(context).pop();
                        }
                      },
                    )
                    // buildCancelButton(context),
                    // buildAddButton(context, isEditing: isEditing),
                  ],
                ),
          ) ,
          //   {
          //   // addPokeTeam("Team1");
          //   return AlertDialog(
          //     title: Text("TEST"),
          //     content: Form(
          //       key: formKey,
          //       child: SingleChildScrollView(
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: <Widget>[
          //             SizedBox(height: 8),
          //             // buildName(),
          //             SizedBox(height: 8),
          //             // buildAmount(),
          //             SizedBox(height: 8),
          //             // buildRadioButtons(),
          //           ],
          //         ),
          //       ),
          //     ),
          //     actions: <Widget>[
          //       // buildCancelButton(context),
          //       // buildAddButton(context, isEditing: isEditing),
          //     ],
          //   );
          // },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        )
      //   Padding(
      //   padding: const EdgeInsets.all(30.0),
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //       TextButton(
      //       onPressed: () {
      //         addPokeTeam("Team1");
      //       },
      //       child: Text(
      //         "Add Pokemon Team",
      //       ),
      //       )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget buildName() => TextFormField(
    controller: nameController,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Enter Name',
    ),
    validator: (name) =>
    name != null && name.isEmpty ? 'Enter a name' : null,
  );

  Future addPokeTeam(String name) async {
   final pokeTeam = PokemonTeam()
       ..name = name
       ..pokemonTeam = {}
       ..pokemonTeamTypes = []
       ..userID = FirebaseAuth.instance.currentUser?.uid;

   final box = Boxes.getPokemonTeams();
   box.add(pokeTeam);
  }

  Widget buildContent(List<PokemonTeam> pokemonTeams) {
    if (pokemonTeams.isEmpty) {
      return Center(
        child: Text(
          'No teams yet',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {


      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Pokemon Teams: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: pokemonTeams.length,
              itemBuilder: (BuildContext context, int index) {
                final pokemonTeam = pokemonTeams[index];

                return buildTransaction(context, pokemonTeam);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildTransaction(
      BuildContext context,
      PokemonTeam pokemonTeam,
      ) {
    // final color = transaction.isExpense ? Colors.red : Colors.green;
    // final date = DateFormat.yMMMd().format(transaction.createdDate);
    // final amount = '\$' + transaction.amount.toStringAsFixed(2);

    return Card(
      color: Colors.white,
      child: ListTile(
        // tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          pokemonTeam.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onTap: (){
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonTeamDetailPage(pokemonTeamObject: pokemonTeam),
          ),
        );
    },
        // subtitle: Text(date),
        // trailing: Text(
        //   amount,
        //   style: TextStyle(
        //       color: color, fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // children: [
        //   buildButtons(context, transaction),
        // ],
      ),
    );
  }
}
