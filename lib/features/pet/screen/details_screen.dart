import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';
import 'package:photo_view/photo_view.dart';
import '../../../models/pet_model.dart';
import '../controller/pet_controller.dart';

class DetailsScreen extends StatefulWidget {
  final Pet pet;

  const DetailsScreen({super.key, required this.pet});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ReactiveState<DetailsScreen, PetController> {
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 6));

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petId = widget.pet.id;

    return Scaffold(
      appBar: AppBar(title: Text(widget.pet.name)),
      body: ConfettiWidget(
        blastDirectionality: BlastDirectionality.explosive,
        confettiController: _confettiController,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: petId,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  clipBehavior: Clip.antiAlias,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: PhotoView(
                        imageProvider: NetworkImage(widget.pet.imageUrl),
                        loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
                        errorBuilder: (ctx, error, stack) {
                          return PhotoView(
                            imageProvider: NetworkImage(
                              'https://www.shutterstock.com/image-vector/illustration-cute-baby-golden-retrieve-600nw-2488093199.jpg',
                            ),
                          );
                        },
                        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  children: [
                    Text(
                      widget.pet.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark, // Example color
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.cake_outlined, size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        Text('Age: ${widget.pet.age} years', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.sell_outlined, size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        Text('Price: ₹${widget.pet.price}', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Observer(
                listenable: controller.pets,
                listener: (_) {
                  final updatedPet = controller.pets.firstWhere(
                    (p) => p.id == widget.pet.id,
                    orElse: () => widget.pet,
                  );
                  final isAdopted = updatedPet.isAdopted;

                  return ElevatedButton.icon(
                    icon: Icon(isAdopted ? Icons.check_circle : Icons.pets_outlined),
                    label: Text(
                      isAdopted ? 'ADOPTED' : 'ADOPT ME!',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: isAdopted
                        ? null
                        : () {
                            controller.adoptPet(updatedPet);
                            _showAdoptDialog(widget.pet);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAdopted ? Colors.grey[400] : Colors.greenAccent[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      elevation: isAdopted ? 0 : 5,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdoptDialog(Pet pet) {
    controller.adoptPet(pet);
    _confettiController.play();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),

        title: const Text('Adoption Successful 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("You've now adopted ${pet.name} ✅"),
            const SizedBox(height: 8),
            const Text("Get ready for lots of fun!", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('AWESOME!', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
