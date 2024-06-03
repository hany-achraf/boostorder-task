import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/constants.dart';
import '../common/models/product.dart';
import 'paginated_response.dart';

part 'api.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  @GET('/products?status=publish')
  Future<PaginatedResponse<Product>> getProducts({
    @Query('page') required int page,
  });

  // For Testing Disable Caching for desired endpoints
  @GET('/products?status=publish')
  @Extra({'no-cache': true})
  Future<PaginatedResponse<Product>> getProductsNoCache({
    @Query('page') required int page,
  });
}
