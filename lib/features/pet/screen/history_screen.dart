import 'package:flutter/material.dart';
import 'package:pet_adoption_app/features/pet/screen/main_navigation_screen.dart';
import 'package:reactiv/reactiv.dart';
import '../../../models/pet_model.dart';
import '../controller/pet_controller.dart';
import 'details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ReactiveState<HistoryScreen, PetController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adoption History"), centerTitle: true, elevation: 2.0),
      body: Observer(
        listenable: controller.pets,
        listener: (pets) {
          final adoptedPets = pets.where((p) => p.isAdopted).toList().reversed.toList(); // most recent first

          if (adoptedPets.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_work_outlined, size: 80, color: Colors.grey[400]), // Example Icon
                    // Or use an Image.asset('assets/images/empty_history.png') if you have one
                    const SizedBox(height: 20),
                    Text(
                      "Your Adoption Journey is Yet to Begin!",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Adopt a pet to see them here. 🐾",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.pets_outlined),
                      label: const Text("Click here to Adopt"),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigationScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: adoptedPets.length,
            itemBuilder: (context, index) {
              final pet = adoptedPets[index];
              return Hero(
                tag: pet.id,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 500 + index * 50),
                    tween: Tween(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
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
                            errorBuilder: (ctx, error, stack) {
                              return Image.network(
                                "https://www.shutterstock.com/image-vector/illustration-cute-baby-golden-retrieve-600nw-2488093199.jpg",
                                width: 60,
                                height: 60,
                              );
                            },
                          ),
                        ),
                        title: Text(pet.name),
                        subtitle: Text('Age: ${pet.age} • ₹${pet.price}'),
                        trailing: Icon(
                          pet.isAdopted ? Icons.check_circle : Icons.favorite,
                          color: pet.isAdopted ? Colors.grey : Colors.red,
                        ),
                        onLongPress: () {
                          _confirmDelete(pet);
                        },
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(pet: pet)));
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(Pet pet) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Are you sure you want to delete ${pet.name} from history?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteAdoptedPet(pet);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
