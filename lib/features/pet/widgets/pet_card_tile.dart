// features/pet/widgets/pet_card_tile.dart

import 'package:flutter/material.dart';
import '../../../models/pet_model.dart';

class PetCardTile extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onLongPress;

  const PetCardTile({super.key, required this.pet, this.onTap, this.onFavoriteToggle, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: pet.isAdopted ? null : onTap,
      onLongPress: onLongPress,
      leading: Hero(
        tag: pet.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 80,
            width: 80,
            child: Image.network(
              pet.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stack) {
                return Image.network(
                  "https://www.shutterstock.com/image-vector/illustration-cute-baby-golden-retrieve-600nw-2488093199.jpg",
                  height: 60,
                  width: 60,
                );
              },
            ),
          ),
        ),
      ),
      title: Text(pet.name),
      subtitle: Text('Age: ${pet.age} • ₹${pet.price}'),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onFavoriteToggle,
            child: Icon(
              pet.isFavorited ? Icons.favorite : Icons.favorite_border,
              color: pet.isFavorited ? Colors.red : null,
            ),
          ),
          Text(
            pet.isAdopted ? 'Adopted' : 'Available',
            style: TextStyle(fontSize: 10, color: pet.isAdopted ? Colors.grey : Colors.green),
          ),
        ],
      ),
    );
  }
}

// // features/pet/widgets/pet_card_tile.dart
//
// import 'package:flutter/material.dart';
// import '../../../models/pet_model.dart';
//
// class PetCardTile extends StatelessWidget {
//   final Pet pet;
//   final VoidCallback? onTap;
//   final VoidCallback? onFavoriteToggle;
//
//   const PetCardTile({super.key, required this.pet, this.onTap, this.onFavoriteToggle});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: ListTile(
//         onTap: pet.isAdopted ? null : onTap,
//         leading: SizedBox(
//           width: 60,
//           height: 60,
//           child: Hero(
//             tag: pet.id,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(pet.imageUrl, fit: BoxFit.cover),
//             ),
//           ),
//         ),
//         title: Text(pet.name),
//         subtitle: Text('Age: ${pet.age} • ₹${pet.price}'),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(
//                 pet.isFavorited ? Icons.favorite : Icons.favorite_border,
//                 color: pet.isFavorited ? Colors.red : null,
//               ),
//               onPressed: onFavoriteToggle,
//             ),
//             Text(
//               pet.isAdopted ? 'Adopted' : 'Available',
//               style: TextStyle(fontSize: 10, color: pet.isAdopted ? Colors.grey : Colors.green),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
