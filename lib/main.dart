import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/scheme_list/data/scheme_list_repository.dart';
import 'features/scheme_list/presentation/bloc/scheme_list_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MutualFundApp());
}

class MutualFundApp extends StatelessWidget {
  const MutualFundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        Provider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        Provider<SchemeListRepository>(
          create: (context) => SchemeListRepository(
            apiClient: context.read<ApiClient>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              repository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SchemeListBloc>(
            create: (context) => SchemeListBloc(
              repository: context.read<SchemeListRepository>(),
            ),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'Mutual Funds',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
