import 'package:get/get.dart';
import '../../data/models/job_model.dart';
import '../../domain/usecases/get_job.dart';

class JobsController extends GetxController {
  
  // MaritalStatusUsecase instance
  final JobUsecase jobUsecase;

  // MaritalStatusController Constructor
  JobsController(this.jobUsecase);

  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;
  final _items = <JobModel>[].obs;

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;
  List<JobModel> get jobs => _items.toList();

  @override
  void onInit() {
    super.onInit();
    _findItems();
  }

  // Get List Of Marital Status
  Future<void> _findItems() async {
    
    // Call Marital Status Usecase.
    final failureOrMaritalStatus = await jobUsecase();

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
