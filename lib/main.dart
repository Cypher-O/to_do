import 'package:to_do/core/utils/imports/general_import.dart';
import 'package:to_do/injection_container.dart' as di;
import 'package:to_do/presentation/bloc/auth/auth_bloc.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => di.sl<AuthBloc>()..add(CheckAuthentication()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>.value(value: context.read<AuthBloc>()),
                BlocProvider<TodoBloc>(
                  create: (context) => di.sl<TodoBloc>(param1: state.user.token)..add(LoadTodos()),
                ),
              ],
              child: MaterialApp(
                title: 'To-Do App',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.green,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: const TodoListPage(),
              ),
            );
          }
          return MaterialApp(
            title: 'To-Do App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}