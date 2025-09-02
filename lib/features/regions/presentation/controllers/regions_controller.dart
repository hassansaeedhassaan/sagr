import 'package:get/get.dart';
import '../../data/models/region_model.dart';
import '../../domain/usecases/get_region.dart';

class RegionsController extends GetxController {
  
  // MaritalStatusUsecase instance
  final RegionUsecase regionUsecase;

  // MaritalStatusController Constructor
  RegionsController(this.regionUsecase);

  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;
  final _items = <RegionModel>[].obs;

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;
  List<RegionModel> get regions => _items.toList();

  @override
  void onInit() {
    super.onInit();
    _findItems("SA");
  }

  // Get List Of Marital Status
  Future<void> _findItems(code) async {
    
    // Call Marital Status Usecase.
    final failureOrMaritalStatus = await regionUsecase(code);

    failureOrMaritalStatus.fold((failure) {

      // Set Loading Attr False Initially.
      _isLoading.value = false;

    }, (receivedRegionsData) {
      
      // Set Loading Attr True.
      _isLoading.value = true;
    
    
      // Add Result To Items Var.
      _items.addAll(receivedRegionsData);
      
      // Set Loading Attr False.
      _isLoading.value = false;
      update();
    });
  }



getAllRegions(code){
  _items.clear();
  _findItems(code);
  update();
}

//  Future getRegions(code) async {
    
//     // Call Marital Status Usecase.
//     final failureOrMaritalStatus = await regionUsecase(code);

//     failureOrMaritalStatus.fold((failure) {

//       // Set Loading Attr False Initially.

//     }, (receivedRegionsData) {
      
//       // Set Loading Attr True.
      
//       // Add Result To Items Var.

//       _items.clear();
//         _items.addAll(receivedRegionsData);
      
//       // Set Loading Attr False.
//         _isLoading.value = false;
//       update();
//     });
//   }

}
