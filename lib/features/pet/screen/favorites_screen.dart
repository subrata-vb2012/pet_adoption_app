import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';
import '../controller/pet_controller.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ReactiveState<FavoritesScreen, PetController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Observer(
        listenable: controller.pets,
        listener: (pets) {
          final favoritedPets = pets.where((p) => p.isFavorited).toList();

          if (favoritedPets.isEmpty) {
            return const Center(child: Text("No favorites yet 💔"));
          }

          return ListView.builder(
            itemCount: favoritedPets.length,
            itemBuilder: (context, index) {
              final pet = favoritedPets[index];
              return Hero(
                tag: pet.id,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        pet.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(pet.name),
                    subtitle: Text('Age: ${pet.age}  •  ₹${pet.price}'),
                    trailing: Icon(
                      pet.isAdopted ? Icons.check_circle : Icons.favorite,
                      color: pet.isAdopted ? Colors.grey : Colors.red,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(pet: pet),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
