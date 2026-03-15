import 'dart:async';

import 'package:by_happy/di/service_locator.dart';
import 'package:by_happy/domain/entities/user_profile.dart';
import 'package:by_happy/presentation/screens/block_screen.dart';
import 'package:by_happy/presentation/screens/documents_screen.dart';
import 'package:by_happy/presentation/screens/edit_profile_screen.dart';
import 'package:by_happy/presentation/screens/map_screen.dart';
import 'package:by_happy/presentation/screens/news_screen.dart';
import 'package:by_happy/presentation/screens/onboarding_screen.dart';
import 'package:by_happy/presentation/screens/profile_screen.dart';
import 'package:by_happy/presentation/screens/promo_code_screen.dart';
import 'package:by_happy/presentation/screens/scooter_detail_screen.dart';
import 'package:by_happy/presentation/screens/support_screen.dart';
import 'package:by_happy/presentation/viewmodel/splash_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';

import '../screens/add_card_screen.dart'; // ← новый импорт
import '../screens/phone_login_screen.dart';
import '../screens/phone_screen.dart';
import '../screens/pin_login_screen.dart';
import '../screens/qr_scan_screen.dart';
import '../screens/splash_screen.dart';
import '../state/splash_state.dart';
import '../viewmodel/add_card_bloc.dart'; // ← новый импорт

class AppRouter {
  final SplashBloc splashBloc;

  AppRouter(this.splashBloc);

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/splash',

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const PhoneScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'];
          if (phone != null) {
            return PhoneLoginScreen(phoneNumber: phone, tempToken: '');
          }
          throw Exception("Incorrect phone");
        },
      ),
      GoRoute(
        path: '/block',
        builder: (context, state) => const BlockedScreen(),
      ),
      GoRoute(
        path: '/pin',
        builder: (context, state) => const PinLoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MapScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => EditProfileScreen(
                  profile: UserProfile(
                    name: '',
                    birthDate: '',
                    phone: '',
                    email: '',
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'scooter/:id',
            builder: (context, state) => const ScooterDetailScreen(),
          ),
          GoRoute(
            path: 'support',
            builder: (context, state) => const SupportScreen(),
          ),
          GoRoute(
            path: 'documents',
            builder: (context, state) => const DocumentsScreen(),
          ),
          GoRoute(
            path: 'promo',
            builder: (context, state) => const PromoCodeScreen(),
          ),
          GoRoute(
            path: 'rules',
            builder: (context, state) => const OnboardingScreen(),
          ),
          GoRoute(
            path: 'news',
            builder: (context, state) => const NewsScreen(),
          ),
          GoRoute(
            path: 'qr',
            builder: (context, state) => const QrScanScreen(),
          ),

          GoRoute(
            path: 'add-card',
            builder: (context, state) => BlocProvider(
              create: (context) => getIt<AddCardBloc>(),
              child: const AddCardScreen(),
            ),
          ),
        ],
      ),
    ],

    redirect: (BuildContext context, GoRouterState state) {
      final authState = splashBloc.state;
      final currentLocation = state.uri.toString();

      print("inside redirect");
      print(splashBloc.state);
      print(state.uri.toString());

      if (authState is AuthInitial && currentLocation != '/splash') {
        print("splash");
        return '/splash';
      }

      if (authState is AuthFirstLaunch && currentLocation != '/login') {
        print("login");
        return '/login';
      }

      if (authState is AuthUnauthenticated && currentLocation != '/login') {
        print("login2");
        return '/login';
      }

      if (authState is AuthAuthenticated &&
          (currentLocation == '/splash' ||
              currentLocation == '/login' ||
              currentLocation == '/phone')) {
        print("home");
        return '/home';
      }

      return null;
    },

    refreshListenable: GoRouterRefreshStream(splashBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      print("Stream updated");
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}