import 'package:get/get.dart';
import 'package:sagr/features/nationalities/data/models/nationality_model.dart';
import 'package:sagr/features/auth/presentation/widgets/pro_dropdown.dart';
import '../../../auth/presentation/screens/create_account_screen.dart';
import '../../domain/usecases/get_nationality.dart';

class NationalitiesController extends GetxController {
  
  // MaritalStatusUsecase instance
  final NationalityUsecase nationalityUsecase;

  // MaritalStatusController Constructor
  NationalitiesController(this.nationalityUsecase);

  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;
  final _items = <NationalityModel>[].obs;

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;
  List<NationalityModel> get nationalities => _items.toList();



  // Convert NationalityModel list to DropdownItem list
  List<ProDropdownOption<NationalityModel>> get nationalityItems {
    return nationalities
        .map((n) => ProDropdownOption(
              value: n,
              label: n.name ?? 'Unknown',
            ))
        .toList();
  }


  @override
  void onInit() {
    super.onInit();
    _findItems();
  }

  // Get List Of Marital Status
  Future<void> _findItems() async {
    
    // Call Marital Status Usecase.
    final failureOrMaritalStatus = await nationalityUsecase();

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
