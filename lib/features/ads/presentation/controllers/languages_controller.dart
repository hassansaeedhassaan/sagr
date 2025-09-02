import 'package:get/get.dart';
import '../../data/models/language_model.dart';
import '../../domain/usecases/get_language.dart';

class LanguagesController extends GetxController {
  
  // MaritalStatusUsecase instance
  final LanguageUsecase languageUsecase;

  // MaritalStatusController Constructor
  LanguagesController(this.languageUsecase);

  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;
  final _items = <LanguageModel>[].obs;

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;
  List<LanguageModel> get languages => _items.toList();

  @override
  void onInit() {
    super.onInit();
    _findItems();
  }

  // Get List Of Marital Status
  Future<void> _findItems() async {
    
    // Call Marital Status Usecase.
    final failureOrMaritalStatus = await languageUsecase();

    failureOrMaritalStatus.fold((failure) {

      // Set Loading Attr False Initially.
      _isLoading.value = false;

    }, (receivedLanguagesData) {
      
      // Set Loading Attr True.
      _isLoading.value = true;
      
      // Add Result To Items Var.
      _items.addAll(receivedLanguagesData);
      
      // Set Loading Attr False.
      _isLoading.value = false;
      update();
    });
  }
}
