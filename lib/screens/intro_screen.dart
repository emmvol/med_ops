import 'package:flutter/material.dart';

import '../data/campaigns.dart';
import '../models/team.dart';
import 'game_screen.dart';

class IntroScreen extends StatefulWidget {

  final List<Team> teams;

  const IntroScreen({
    super.key,
    required this.teams,
  });

  @override
  State<IntroScreen> createState() => _IntroScreenState();

}

class _IntroScreenState extends State<IntroScreen> {

  int page = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Operación Quimera"),

      ),

      body: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          children: [

            Expanded(

              child: Center(

                child: Text(

                  operationQuimera.intro[page],

                  textAlign: TextAlign.center,

                  style: const TextStyle(

                    fontSize: 24,

                    height: 1.6,

                  ),

                ),

              ),

            ),

            FilledButton(

              onPressed: (){

                if(page < operationQuimera.intro.length - 1){

                  setState((){

                    page++;

                  });

                }

                else{

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(

                      builder: (_) => GameScreen(

                        teams: widget.teams,

                      ),

                    ),

                  );

                }

              },

              child: Text(

                page == operationQuimera.intro.length - 1

                    ? "Comenzar"

                    : "Continuar",

              ),

            ),

          ],

        ),

      ),

    );

  }

}