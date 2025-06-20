import 'package:flutter/material.dart';
import '../../../models/pet_model.dart'; // Adjust import path

class PetCardTile extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const PetCardTile({super.key, required this.pet, required this.onTap, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4.0,
      clipBehavior: Clip.antiAlias,
      // Ensures content respects card's shape
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'pet_image_${pet.id}', // Unique tag for Hero animation
              child: AspectRatio(
                aspectRatio: 16 / 10, // Adjust as needed
                child: Image.network(
                  pet.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
                  },
                  errorBuilder: (ctx, error, stack) {
                    return Image.network(
                      "https://www.shutterstock.com/image-vector/illustration-cute-baby-golden-retrieve-600nw-2488093199.jpg",
                      width: 60,
                      height: 60,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        // Allow name to wrap if too long
                        child: Text(
                          pet.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          pet.isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: pet.isFavorited ? Colors.redAccent : Colors.grey,
                        ),
                        onPressed: onFavoriteToggle,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Age: ${pet.age} years}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '₹${pet.price}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
