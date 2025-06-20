import 'package:hive/hive.dart';
import 'package:reactiv/reactiv.dart';
import '../../../models/pet_model.dart';
import '../handler/pet_handler.dart';
import '../repository/pet_repository.dart';

class PetController extends ReactiveController {
  final ReactiveList<Pet> pets = ReactiveList<Pet>([]);
  final ReactiveBool isLoading = ReactiveBool(true);

  final PetHandler _handler;

  PetController() : _handler = PetHandler(PetRepository());

  @override
  void onInit() {
    super.onInit();
    fetchPets();
  }

  Future<void> fetchPets() async {
    isLoading.value = true;
    try {
      final box = Hive.box<Pet>('pets');

      if (box.isNotEmpty) {
        pets.value = box.values.toList();
      } else {
        final result = await _handler.getPetList();
        pets.value = result;

        // Save to Hive
        for (final pet in result) {
          box.put(pet.id, pet);
        }
      }
    } catch (e) {
      // error handling
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(Pet pet) {
    pet.isFavorited = !pet.isFavorited;
    pets.refresh();
    Hive.box<Pet>('pets').put(pet.id, pet);
  }

  void adoptPet(Pet pet) {
    pet.isAdopted = true;
    pets.refresh();
    Hive.box<Pet>('pets').put(pet.id, pet);
  }

  void deleteAdoptedPet(Pet pet) {
    pets.removeWhere((p) => p.id == pet.id);
    Hive.box<Pet>('pets').delete(pet.id);
    pets.refresh();
  }

  List<Pet> get favoritePets => pets.where((p) => p.isFavorited).toList();

  List<Pet> get adoptedPets => pets.where((p) => p.isAdopted).toList();
}
