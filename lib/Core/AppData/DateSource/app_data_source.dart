import 'package:dartz/dartz.dart';
import 'package:portfolio_app/Core/core.dart';

abstract class BaseAppRemoteDataSource {
  // Future<Either<Failure, UserEntity>> getUserData();
  //
  //
  // Future<Either<Failure, ThemeModel>> getThemeData();

  Future<Either<Failure, AlertModel>> getAlertData();
}

class AppRemoteDataSource extends BaseAppRemoteDataSource {
  @override
  // Future<Either<Failure, UserEntity>> getUserData() async {
  //   try {
  //     final response = await DioHelper.getData(
  //       endPoint: 'users/${CacheHelper.get(key: 'userId')}',
  //     );
  //     return response.fold((failure) {
  //       debugPrint('==> getUserData failure ${failure.toString()}');
  //       return Left(failure);
  //     }, (data) {
  //       debugPrint('==> getUserData ${data['data']}');
  //
  //       CacheHelper.init();
  //       CacheHelper.put(
  //           key: 'departmentColor',
  //           value: data['data']['department_color']);
  //       CacheHelper.put(
  //           key: 'departmentName',
  //           value: data['data']['department_name']);
  //       CacheHelper.put(
  //           key: 'profileImage', value: data['data']['avatar']);
  //
  //       return Right(UserModel.fromJson(data['data']));
  //     });
  //     // if (response.data['statusCode'] == 200) {
  //     //   CacheHelper.init();
  //     //   CacheHelper.put(
  //     //       key: 'departmentColor',
  //     //       value: response.data['data']['department_color']);
  //     //   CacheHelper.put(
  //     //       key: 'departmentName',
  //     //       value: response.data['data']['department_name']);
  //     //   CacheHelper.put(
  //     //       key: 'profileImage', value: response.data['data']['avatar']);
  //     //
  //     //   return UserModel.fromJson(response.data['data']);
  //     // } else {
  //     //   debugPrint(response.data.toString());
  //     //   throw ServerException(
  //     //     errorMessageModel: ErrorMessageModel.fromJson(response.data),
  //     //   );
  //     // }
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, ThemeModel>> getThemeData() async {
  //   try {
  //     final response = await DioHelper.getData(
  //       endPoint: 'themes',
  //     );
  //     return response.fold((failure) => Left(failure), (data) {
  //       return Right(ThemeModel.fromJson(data['data']));
  //     });
  //     // if (response.data['statusCode'] == 200) {
  //     //   return ThemeModel.fromJson(response.data['data']);
  //     // } else {
  //     //   debugPrint(response.data.toString());
  //     //   throw ServerException(
  //     //     errorMessageModel: ErrorMessageModel.fromJson(response.data),
  //     //   );
  //     // }
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, AlertModel>> getAlertData() async {
    try {
      final response = await DioHelper.getData(
        endPoint: 'current/date/alert',
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(AlertModel.fromJson(data['data']));
      });
      // if (response.data['statusCode'] == 200) {
      //   return AlertModel.fromJson(response.data['data']);
      // } else {
      //   debugPrint(response.data.toString());
      //   throw ServerException(
      //     errorMessageModel: ErrorMessageModel.fromJson(response.data),
      //   );
      // }
    } on DioException catch (e) {
      return Left(ServerFailure(DioHelper.handleError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
