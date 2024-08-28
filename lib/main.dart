import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/injection_container.dart' as di;
import 'package:to_do/presentation/bloc/auth/auth_bloc.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';
import 'package:to_do/presentation/pages/login_page.dart';
import 'package:to_do/presentation/pages/todo_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<AuthState> _getAuthState() async {
    final authBloc = di.sl<AuthBloc>();
    // Dispatch an event to check authentication status
    authBloc.add(CheckAuthentication());
    // Await for the initial state to be emitted
    return authBloc.stream.firstWhere(
      (state) => state is AuthSuccess || state is AuthInitial,
      orElse: () => AuthInitial(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthState>(
      future: _getAuthState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final authState = snapshot.data;
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => di.sl<AuthBloc>(),
            ),
            BlocProvider<TodoBloc>(
              create: (context) => di.sl<TodoBloc>(),
            ),
          ],
          child: MaterialApp(
            title: 'To-Do App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: authState is AuthSuccess
                ? const TodoListPage()
                : LoginPage(),
          ),
        );
      },
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (context) => di.sl<AuthBloc>(),
//         ),
//         BlocProvider<TodoBloc>(
//           create: (context) => di.sl<TodoBloc>()..add(LoadTodos()),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'To-Do App',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         // home: LoginPage(),
//          home: BlocBuilder<AuthBloc, AuthState>(
//           builder: (context, state) {
//             if (state is AuthSuccess) {
//               // If authenticated, load todos and show TodoListPage
//               context.read<TodoBloc>().add(LoadTodos());
//               return const TodoListPage();
//             }
//             // If not authenticated, show LoginPage
//             return LoginPage();
//           },
//         ),
//       ),
//     );
//   }
// }
