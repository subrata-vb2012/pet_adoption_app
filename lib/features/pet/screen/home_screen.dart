// features/pet/screen/home_screen.dart

import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';
import '../../../models/pet_model.dart';
import '../controller/pet_controller.dart';
import '../widgets/pet_card_tile.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ReactiveState<HomeScreen, PetController> {
  final ReactiveString searchText = ReactiveString('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Adoption'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by pet name...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (val) => searchText.value = val,
            ),
          ),
          Expanded(
            child: Observer(
              listenable: controller.isLoading,
              listener: (isLoading) {
                return isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Observer(
                        listenable: controller.pets,
                        listener: (pets) {
                          final filteredPets = pets
                              .where((pet) => pet.name.toLowerCase().contains(searchText.value.toLowerCase()))
                              .toList();

                          return RefreshIndicator(
                            onRefresh: () async => controller.fetchPets(),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: filteredPets.length,
                              itemBuilder: (context, index) {
                                final pet = controller.pets[index];
                                return PetCardTile(
                                  pet: pet,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DetailsScreen(pet: pet)),
                                  ),
                                  onFavoriteToggle: () => controller.toggleFavorite(pet),
                                );
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
