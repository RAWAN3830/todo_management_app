# Todo Management App

A **Flutter** application built in **48 hours**, following the **MVVM architecture** with **Sqflite** for local database storage and **Riverpod** for state management. This project marks my first experience using **Riverpod**, having previously worked with **Provider** and **BLoC**.

## Features

- **Add, update, delete, and mark tasks as complete**
- **Persistent local storage using Sqflite**
- **Clean architecture following MVVM principles**
- **State management with Riverpod**
- **Smooth and intuitive UI/UX**

## Screenshots

(Add screenshots here if available)

## Installation & Setup

### Prerequisites
- Flutter SDK installed ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Android Studio or VS Code
- Emulator or real device for testing

### Steps to Run the Project

1. **Clone the repository:**
   ```sh
   git clone https://github.com/RAWAN3830/todo_management_app.git
   cd todo_management_app
   ```

2. **Get dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the project:**
   ```sh
   flutter run
   ```

## Folder Structure (MVVM Pattern)
```
lib/
│── main.dart
│── core/
│   ├── db/
│   │   ├── database_helper.dart
│── models/
│   ├── todo_model.dart
│── repository/
│   ├── todo_repository.dart
│── viewmodel/
│   ├── todo_viewmodel.dart
│── views/
│   ├── home_screen.dart
│   ├── add_todo_screen.dart
│── widgets/
│   ├── todo_tile.dart
```

## Dependencies Used
- **flutter_riverpod** - State management
- **sqflite** - Local database
- **path_provider** - Database file storage
- **intl** - Date formatting

## Future Improvements
- Implement notifications for due tasks
- Add Firebase sync support
- Improve UI with animations

## License
This project is licensed under the **MIT License**.

---

Feel free to update the repository link, add screenshots, or tweak the details to better fit your project!
