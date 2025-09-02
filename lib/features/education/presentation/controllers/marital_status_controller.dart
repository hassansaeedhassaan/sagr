import 'package:get/get.dart';
import '../../data/models/education_model.dart';
import '../../domain/usecases/get_education.dart';

class EducationsController extends GetxController {
  
  // MaritalStatusUsecase instance
  final EducationUsecase educationUsecase;

  // MaritalStatusController Constructor
  EducationsController(this.educationUsecase);

  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;
  final _items = <EducationModel>[].obs;

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;
  List<EducationModel> get educations => _items.toList();

  @override
  void onInit() {
    super.onInit();
    _findItems();
    print("🎉");
    print(educations);
        print("🎉");
  }

  // Get List Of Marital Status
  Future<void> _findItems() async {
    
    // Call Marital Status Usecase.
    final failureOrMaritalStatus = await educationUsecase();

    failureOrMaritalStatus.fold((failure) {

      // Set Loading Attr False Initially.
      _isLoading.value = false;

    }, (receivedJobsData) {
      
      // Set Loading Attr True.
      _isLoading.value = true;
      
      // Add Result To Items Var.
      _items.addAll(receivedJobsData);
      
      // Set Loading Attr False.
      _isLoading.value = false;
      update();
    });
  }
}
