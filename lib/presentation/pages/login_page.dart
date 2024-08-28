// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:to_do/presentation/bloc/auth/auth_bloc.dart';
// import 'package:to_do/presentation/pages/register_page.dart';
// import 'package:to_do/presentation/pages/todo_list_page.dart';

// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         leading: null,
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Login Successful')),
//             );
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const TodoListPage()),
//             );
//           } else if (state is AuthFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error)),
//             );
//           }
//         },
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter an email';
//                           } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                               .hasMatch(value)) {
//                             return 'Please enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         obscureText: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a password';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           const SizedBox(width: 8),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState?.validate() ?? false) {
//                                 context.read<AuthBloc>().add(
//                                       LoginRequested(
//                                         _emailController.text,
//                                         _passwordController.text,
//                                       ),
//                                     );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Text(
//                               'Login',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => RegisterPage()),
//                           );
//                         },
//                         child: const Text(
//                           'Don\'t have an account? Register here',
//                           style: TextStyle(
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/presentation/bloc/auth/auth_bloc.dart';
import 'package:to_do/presentation/pages/register_page.dart';
import 'package:to_do/presentation/pages/todo_list_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Login Successful',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TodoListPage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4CAF50).withOpacity(0.7),
                    Color(0xFF2196F3).withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // SVG background elements
            Positioned(
              top: -100,
              left: -100,
              child: FadeInDown(
                duration: const Duration(seconds: 1),
                child: SvgPicture.string(
                  '''
                  <svg width="300" height="300" viewBox="0 0 300 300" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="150" cy="150" r="150" fill="white" fill-opacity="0.1"/>
                    <circle cx="150" cy="150" r="100" fill="white" fill-opacity="0.1"/>
                    <circle cx="150" cy="150" r="50" fill="white" fill-opacity="0.1"/>
                  </svg>
                  ''',
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: FadeInUp(
                duration: const Duration(seconds: 1),
                delay: const Duration(milliseconds: 300),
                child: SvgPicture.string(
                  '''
                  <svg width="300" height="300" viewBox="0 0 300 300" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="150" cy="150" r="150" fill="white" fill-opacity="0.1"/>
                    <circle cx="150" cy="150" r="100" fill="white" fill-opacity="0.1"/>
                    <circle cx="150" cy="150" r="50" fill="white" fill-opacity="0.1"/>
                  </svg>
                  ''',
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            // Main content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: const Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  icon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email';
                                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  icon: Icons.lock,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context.read<AuthBloc>().add(
                                            LoginRequested(
                                              _emailController.text,
                                              _passwordController.text,
                                            ),
                                          );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 400),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          child: const Text(
                            'Don\'t have an account? Register here',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
