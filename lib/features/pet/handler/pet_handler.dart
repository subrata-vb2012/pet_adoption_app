import '../../../models/pet_model.dart';
import '../repository/pet_repository.dart';

class PetHandler {
  final PetRepository _repository;

  PetHandler(this._repository);

  Future<List<Pet>> getPetList() async {
    final jsonList = await _repository.fetchPets();
    return jsonList.map((e) => Pet.fromJson(e)).toList();
  }
}
