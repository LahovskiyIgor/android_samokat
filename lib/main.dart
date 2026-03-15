import 'package:by_happy/presentation/event/edit_profile_event.dart';
import 'package:by_happy/presentation/event/profile_event.dart';
import 'package:by_happy/presentation/event/scooter_detail_event.dart';
import 'package:by_happy/presentation/navigation/app_router.dart';
import 'package:by_happy/presentation/screens/splash_screen.dart';
import 'package:by_happy/presentation/state/splash_state.dart';
import 'package:by_happy/presentation/viewmodel/auth_bloc.dart';
import 'package:by_happy/presentation/viewmodel/edit_profile_bloc.dart';
import 'package:by_happy/presentation/viewmodel/map_bloc.dart';
import 'package:by_happy/presentation/viewmodel/pin_bloc.dart';
import 'package:by_happy/presentation/viewmodel/profile_bloc.dart';
import 'package:by_happy/presentation/viewmodel/scooter_detail_bloc.dart';
import 'package:by_happy/presentation/viewmodel/splash_bloc.dart';
import 'package:by_happy/presentation/viewmodel/verify_code_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(getIt<SplashBloc>());

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<SplashBloc>()),

        BlocProvider(create: (context) => getIt<PhoneAuthBloc>()),
        BlocProvider(create: (context) => getIt<VerifyCodeBloc>()),
        BlocProvider(create: (context) => getIt<PinCreateBloc>()),
        BlocProvider(
          create: (context) => getIt<ProfileBloc>()..add(ProfileStarted()),
        ),
        BlocProvider(create: (context) => getIt<EditProfileBloc>()..add(EditProfileStarted())),
        BlocProvider(create: (context) => getIt<MapBloc>()),
        BlocProvider(create: (context) => getIt<ScooterDetailBloc>()),
      ],
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          print(
            '!!! Состояние AuthBloc изменилось на: ${state.runtimeType} !!!',
          );
        },
        child: MaterialApp.router(
          title: 'BeHappy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          routerConfig: appRouter.router,
        ),
      ),
    );
  }
}
