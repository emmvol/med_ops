import 'package:flutter/material.dart';

import '../data/campaigns.dart';
import 'intro_screen.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: ConstrainedBox(

          constraints: const BoxConstraints(maxWidth: 700),

          child: Padding(

            padding: const EdgeInsets.all(32),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                const Icon(
                  Icons.science,
                  size: 90,
                ),

                const SizedBox(height: 30),

                Text(
                  operationQuimera.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  operationQuimera.subtitle,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                Text(
                  operationQuimera.description,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                FilledButton.icon(

                  icon: const Icon(Icons.play_arrow),

                  label: const Text("Iniciar campaña"),

                  onPressed: (){

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) => const IntroScreen(),

                      ),

                    );

                  },

                )

              ],

            ),

          ),

        ),

      ),

    );

  }

}