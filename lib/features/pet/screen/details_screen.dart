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
        child: Column(
          children: [
            Hero(
              tag: petId,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PhotoView(
                    //imageProvider: NetworkImage(widget.pet.imageUrl),
                    imageProvider: NetworkImage(widget.pet.imageUrl),
                    errorBuilder: (ctx, error, stack) {
                      return Image.network(
                        "https://www.shutterstock.com/image-vector/illustration-cute-baby-golden-retrieve-600nw-2488093199.jpg",
                      );
                    },
                    backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.pet.name, style: Theme.of(context).textTheme.headlineSmall),
            Text('Age: ${widget.pet.age} years'),
            Text('Price: ₹${widget.pet.price}'),
            const SizedBox(height: 20),
            Observer(
              listenable: controller.pets,
              listener: (_) {
                final updatedPet = controller.pets.firstWhere(
                  (p) => p.id == widget.pet.id,
                  orElse: () => widget.pet,
                );
                final isAdopted = updatedPet.isAdopted;

                return ElevatedButton(
                  onPressed: isAdopted
                      ? null
                      : () {
                          controller.adoptPet(updatedPet);
                          _showAdoptDialog(widget.pet);
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: isAdopted ? Colors.grey : Colors.green),
                  child: Text(isAdopted ? 'Already Adopted' : 'Adopt Me'),
                );
              },
            ),
          ],
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
        title: const Text('Adoption Successful 🎉'),
        content: Text("You've now adopted ${pet.name} ✅"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}
