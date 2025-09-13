import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/model/booking/booking_create_request.dart';

class BookingService {
  Future<ResultModel> createBooking(BookingCreateRequest req) async {
    return await DioService().postRequest('/tour/booking', req.toJson());
  }
}
