import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';
import '../controller/pet_controller.dart';
import '../widgets/pet_card_tile.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ReactiveState<HomeScreen, PetController> {
  TextEditingController searchTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Adoption'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchTEC,
              decoration: InputDecoration(
                hintText: 'Search by pet name...',
                filled: true,
                fillColor: Colors.grey[200],
                // Softer fill color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // More rounded
                  borderSide: BorderSide.none, // No visible border, rely on fill
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0), // Adjust padding
              ),
              onChanged: (val) {
                controller.filterPetList.value = controller.pets
                    .where((pets) => pets.name.toLowerCase().contains(val.toLowerCase()))
                    .toList();
              },
              onTapUpOutside: (f) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          Expanded(
            child: Observer(
              listenable: controller.isLoading,
              listener: (isLoading) {
                return isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Observer(
                        listenable: controller.filterPetList,
                        listener: (filterPets) {
                          if (filterPets.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_outlined, size: 60, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    searchTEC.text.isEmpty
                                        ? 'No pets available right now.'
                                        : 'No pets found for "${searchTEC.text}"',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (searchTEC.text.isNotEmpty)
                                    TextButton(
                                      onPressed: () {
                                        searchTEC.clear();
                                        controller.filterPetList.value = controller.pets;
                                      }, // Clear search
                                      child: const Text('Clear Search'),
                                    ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () async => controller.fetchPets(),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.filterPetList.length,
                              itemBuilder: (context, index) {
                                final pet = controller.filterPetList[index];
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
