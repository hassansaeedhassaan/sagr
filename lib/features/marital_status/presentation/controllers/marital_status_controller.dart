import 'package:get/get.dart';
import '../../data/models/marital_status_model.dart';
import '../../domain/usecases/get_marital_status.dart';

class MaritalStatusController extends GetxController {
  
  // MaritalStatusUsecase instance
  final MaritalStatusUsecase maritalStatusUsecase;

  // MaritalStatusController Constructor
  MaritalStatusController(this.maritalStatusUsecase);

  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;
  final _items = <MaritalStatusModel>[].obs;

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;
  List<MaritalStatusModel> get maritalStatus => _items.toList();

  @override
  void onInit() {
    super.onInit();
    _findItems();
  }

  // Get List Of Marital Status
  Future<void> _findItems() async {
    
    // Call Marital Status Usecase.
    final failureOrMaritalStatus = await maritalStatusUsecase();

    failureOrMaritalStatus.fold((failure) {

      // Set Loading Attr False Initially.
      _isLoading.value = false;

    }, (receivedMaritalStatusData) {
      
      // Set Loading Attr True.
      _isLoading.value = true;
      
      // Add Result To Items Var.
      _items.addAll(receivedMaritalStatusData);
      
      // Set Loading Attr False.
      _isLoading.value = false;
      update();
    });
  }
}
