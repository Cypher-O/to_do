# Flutter Todo App

A feature-rich todo application built with Flutter. This app allows users to register, login, and manage their tasks efficiently with a clean and intuitive interface.

## Features

- User Authentication (Login and Registration)
- Add, edit, and delete todos
- Mark todos as complete or incomplete
- Clean and modern UI design
- Responsive layout for various screen sizes
- Secure token-based authentication
- Efficient state management
- Error handling for API calls and user inputs

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK (version 2.0 or higher)
- Dart SDK (version 2.12 or higher)
- Android Studio / VS Code with Flutter extensions
- An Android or iOS device/emulator for testing

## Tools used in building

- Flutter `v3.24.0` - mobile SDK
- flutter_bloc `^8.1.6` - state management
- equatable `^2.0.5` - value equality
- get_it `^7.6.2` - dependency injection
- flutter_secure_storage `^9.1.0` - secure local storage
- http `^1.1.1` - making HTTP requests
- dartz `^0.10.1` - functional programming
- flutter_svg `^1.0.0` - SVG rendering
- animate_do `^2.1.0` - animations
- mockito `unit testing`
- build_runner `code generation`

## Installation

1. Clone the repository:
   git clone <https://github.com/Cypher-O/todo_app.git>

2. Navigate to the project directory:
   cd todo_app

3. Get the dependencies:
   flutter pub get

4. Run the app:
   flutter run

## Usage

1. **Login/Register**: When you first open the app, you'll be prompted to login or register. Enter your credentials to access your todos.

2. **View Todos**: Once logged in, you'll see your list of todos.

3. **Add Todo**: Tap the '+' button to add a new todo. Enter the title and description, then save.

4. **Edit Todo**: Tap on an existing todo to edit its details.

5. **Delete Todo**: Swipe a todo to delete it, or use the delete option in the edit screen.

6. **Mark as Complete**: Swipe a todo to the left or tap the checkbox next to a todo to mark it as complete or incomplete.

## Running Tests

To run the unit and widget tests for this project:

1. Ensure you're in the project root directory.

2. Run the following command:
   flutter test

This will execute all the tests in the `test/` directory.

## Contributing

Contributions are welcome! Here's how you can contribute:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch-name`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature-branch-name`.
5. Create a pull request.

Please make sure to update tests as appropriate and adhere to the existing coding style.

## Acknowledgments

- Flutter and Dart teams for providing an excellent framework and language.
- Contributors and open-source projects that inspired this app.

## App Screenshots

| ![Login Screen](/assets/screenshots/login.png) | ![Registration Screen](/assets/screenshots/register.png) | ![Todo List](/assets/screenshots/todo_list.png) |
|:--:|:--:|:--:|
| Login Screen | Registration Screen | Todo List |

| ![Add Todo](/assets/screenshots/add_todo.png) | ![Edit Todo](/assets/screenshots/edit_todo.png) |
|:--:|:--:|
| Add Todo | Edit Todo |

## Contact

If you have any questions, feel free to reach out to [Olumide Awodeji] at [olumide.awodeji@hotmail.com].

## APK Download URL

[Todo App Download](https://jvec-todo-app.s3.us-east-2.amazonaws.com/todo.apk)
