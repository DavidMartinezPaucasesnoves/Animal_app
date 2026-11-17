import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_providers.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class AnimalCards extends StatelessWidget {

  final int idAnimal;

  const AnimalCards(this.idAnimal);

  @override
  Widget build(BuildContext context) {

    final animalProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: animalProvider.getAnimalObservations(idAnimal),
      builder: (BuildContext context, AsyncSnapshot<List<Observation>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final casting = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          // color: Colors.red,
          child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => _AnimalCard(animal: casting[index])),
        );

      },
    );
    
  }
}

class _AnimalCard extends StatelessWidget {

  final Observation animal;

  const _AnimalCard({
    Key? key, 
    required this.animal 
  }) : super(key : key);


  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      // color: Colors.green,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(animal.fullPhotoUrl),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            animal.placeGuess ?? animal.userName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
