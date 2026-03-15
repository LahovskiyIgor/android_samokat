import 'package:by_happy/data/repositories/app_settings_repository_impl.dart';
import 'package:by_happy/data/repositories/payment_repository_impl.dart'; // ← новый
import 'package:by_happy/data/repositories/scooter_repository_impl.dart';
import 'package:by_happy/data/repositories/zone_repository_impl.dart';
import 'package:by_happy/data/service/app_setting_service.dart';
import 'package:by_happy/data/service/device_info_service_impl.dart';
import 'package:by_happy/data/service/security_service_impl.dart';
import 'package:by_happy/domain/repositories/app_settings_repository.dart';
import 'package:by_happy/domain/repositories/payment_repository.dart'; // ← новый
import 'package:by_happy/domain/repositories/pin_repository.dart';
import 'package:by_happy/domain/repositories/profile_repository.dart';
import 'package:by_happy/domain/repositories/scooter_repository.dart';
import 'package:by_happy/domain/repositories/zone_repository.dart';
import 'package:by_happy/domain/service/security_service.dart';
import 'package:by_happy/domain/usecase/add_payment_card_usecase.dart'; // ← новый
import 'package:by_happy/domain/usecase/create_pin_usecase.dart';
import 'package:by_happy/domain/usecase/get_address_by_point_usecase.dart';
import 'package:by_happy/domain/usecase/get_available_scooters_usecase.dart';
import 'package:by_happy/domain/usecase/get_available_zones_usecase.dart';
import 'package:by_happy/domain/usecase/get_map_settings_usecase.dart';
import 'package:by_happy/domain/usecase/get_pedestrian_routes_usecase.dart';
import 'package:by_happy/domain/usecase/get_profile_usecase.dart';
import 'package:by_happy/domain/usecase/get_scooter_usecase.dart';
import 'package:by_happy/domain/usecase/login_usecase.dart';
import 'package:by_happy/domain/usecase/logout_usecase.dart';
import 'package:by_happy/domain/usecase/refresh_token_usecase.dart';
import 'package:by_happy/domain/usecase/save_map_settings_usecase.dart';
import 'package:by_happy/domain/usecase/update_profile_usecase.dart';
import 'package:by_happy/domain/usecase/upload_profile_photo_usecase.dart';
import 'package:by_happy/domain/usecase/verify_code_usecase.dart';
import 'package:by_happy/presentation/viewmodel/add_card_bloc.dart'; // ← новый
import 'package:by_happy/presentation/viewmodel/map_settings_modal_bloc.dart';
import 'package:by_happy/presentation/viewmodel/pin_bloc.dart';
import 'package:by_happy/presentation/viewmodel/profile_bloc.dart';
import 'package:by_happy/presentation/viewmodel/scooter_detail_bloc.dart';
import 'package:by_happy/presentation/viewmodel/splash_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/api_service.dart';
import '../data/network/geocoding_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/pin_repository_impl.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/service/device_info_service.dart';
import '../presentation/viewmodel/auth_bloc.dart';
import '../presentation/viewmodel/edit_profile_bloc.dart';
import '../presentation/viewmodel/map_bloc.dart';
import '../presentation/viewmodel/scooter_detail_modal_bloc.dart';
import '../presentation/viewmodel/verify_code_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  // HTTP
  getIt.registerSingleton<http.Client>(http.Client());
  //SecureStorage
  getIt.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());

  //SharedPrefs
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Service
  getIt.registerSingleton<SecurityService>(SecurityServiceImpl(getIt()));

  getIt.registerSingleton<ApiService>(ApiService(getIt()));

  getIt.registerSingleton<GeocodingRemoteDataSource>(GeocodingRemoteDataSource());

  getIt.registerSingleton<DeviceInfoService>(DeviceInfoServiceImpl());

  getIt.registerSingleton<AppSettingsService>(AppSettingsService(getIt()));

  // Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt(), getIt(), getIt()),
  );

  getIt.registerSingleton<PinRepository>(PinRepositoryImpl(getIt()));

  getIt.registerSingleton<UserProfileRepository>(
    UserProfileRepositoryImpl(getIt()),
  );

  getIt.registerSingleton<ScooterRepository>(ScooterRepositoryImpl(getIt()));

  getIt.registerSingleton<ZoneRepository>(ZoneRepositoryImpl(getIt()));

  getIt.registerSingleton<AppSettingsRepository>(AppSettingsRepositoryImpl(getIt()));

  getIt.registerSingleton<PaymentRepository>(PaymentRepositoryImpl(getIt()));

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt()));

  getIt.registerSingleton<LogoutUseCase>(LogoutUseCase(getIt()));

  getIt.registerSingleton<VerifyCodeUseCase>(VerifyCodeUseCase(getIt()));

  getIt.registerSingleton<RefreshTokenUseCase>(RefreshTokenUseCase(getIt()));

  getIt.registerSingleton<CreatePinUseCase>(CreatePinUseCase(getIt()));

  getIt.registerSingleton<GetProfileUseCase>(GetProfileUseCase(getIt()));

  getIt.registerSingleton<UpdateProfileUseCase>(UpdateProfileUseCase(getIt()));

  getIt.registerSingleton<UploadProfilePhotoUsecase>(
    UploadProfilePhotoUsecase(getIt()),
  );

  getIt.registerSingleton<GetAvailableScootersUsecase>(
    GetAvailableScootersUsecase(getIt()),
  );

  getIt.registerSingleton<GetScooterUsecase>(GetScooterUsecase(getIt()));
  getIt.registerSingleton<GetAddressByPointUsecase>(GetAddressByPointUsecase(getIt()));
  getIt.registerSingleton<GetPedestrianRoutesUsecase>(GetPedestrianRoutesUsecase(getIt()));
  getIt.registerSingleton<GetAvailableZonesUsecase>(GetAvailableZonesUsecase(getIt()));
  getIt.registerSingleton<GetMapSettingsUsecase>(GetMapSettingsUsecase(getIt()));
  getIt.registerSingleton<SaveMapSettingsUsecase>(SaveMapSettingsUsecase(getIt()));

  getIt.registerSingleton<AddPaymentCardUsecase>(AddPaymentCardUsecase(getIt()),
  );

  // Blocs
  getIt.registerLazySingleton<SplashBloc>(() => SplashBloc(getIt()));

  getIt.registerFactory<PhoneAuthBloc>(() => PhoneAuthBloc(getIt()));

  getIt.registerFactory<VerifyCodeBloc>(() => VerifyCodeBloc(getIt()));

  getIt.registerFactory<PinCreateBloc>(() => PinCreateBloc(getIt()));

  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(getIt(), getIt()));

  getIt.registerFactory<EditProfileBloc>(
    () => EditProfileBloc(getIt(), getIt()),
  );

  getIt.registerFactory<MapBloc>(() => MapBloc(getIt(), getIt(), getIt()));

  getIt.registerFactory<ScooterDetailBloc>(() => ScooterDetailBloc(getIt()));

  getIt.registerFactory<MapSettingsModalBloc>(() => MapSettingsModalBloc(getIt(), getIt()));

  getIt.registerFactory<AddCardBloc>(() => AddCardBloc(getIt()));
}
