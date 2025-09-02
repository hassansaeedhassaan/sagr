import 'package:sagr/features/featured/data/datasource/featured_ads_data_source.dart';
import 'package:sagr/features/featured/domain/usecases/get_featured_ads.dart';
import 'package:get/get.dart';

import '../../../featured/data/repositories/customers_repository_impl.dart';
import '../../data/datasource/country_data_source.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/usecases/get_countries.dart';

class FeaturedAdsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CountriesDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => CountriesRepositoryImpl(Get.find<CountriesDataSourceImpl>()));
    Get.put(CountriesUsecase(Get.find<CountriesRepositoryImpl>()),
        permanent: true);
  }
}
