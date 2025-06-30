# Task App

A Flutter-based task management application built with Provider state management and SQLite local storage.

## Features

- ✅ Create, read, update, and delete tasks
- 💾 Local SQLite database storage
- 🎨 Light/Dark theme switching
- 📱 Cross-platform Flutter app
- 🔄 Real-time UI updates with Provider

## Architecture

This app follows the **Provider pattern** for state management and uses a clean architecture approach:

### Core Components

- **TodoController**: Main state management class that handles all todo operations
- **TodoModel**: Data model representing a task/todo item
- **TodoDatabaseService**: SQLite database service for local data persistence
- **Provider**: State management solution for reactive UI updates

### State Management

The app uses the Provider package to manage application state. The `TodoController` class extends `ChangeNotifier` and provides:

- Todo CRUD operations (Create, Read, Update, Delete)
- Theme mode switching (Light/Dark)
- Automatic UI updates through `notifyListeners()`

## Key Functionality

### Todo Management
- **Add Todo**: Create new tasks and save to local database
- **Get Todos**: Retrieve all tasks from SQLite database
- **Update Todo**: Modify existing tasks with database sync
- **Delete Todo**: Remove tasks from both local list and database

### Theme Management
- Toggle between light and dark themes
- Persistent theme preference
- Automatic UI refresh when theme changes

## Database Integration

The app uses SQLite for local data persistence through the `TodoDatabaseService`:

- **Local Storage**: All todos are stored locally on the device
- **Offline First**: App works completely offline
- **Data Persistence**: Tasks survive app restarts and device reboots

## Error Handling

Robust error handling is implemented for database operations:
- Try-catch blocks for all database interactions
- Console logging for debugging
- Graceful fallbacks to prevent app crashes

## How to Run the App

### Prerequisites
- Flutter SDK (version 3.0 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Android device/emulator or iOS simulator

### Steps
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd taskapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   ```

4. **Build for release** (optional)
   ```bash
   # Android APK
   flutter build apk
   
   # iOS
   flutter build ios
   ```

### Troubleshooting
- Run `flutter doctor` to check for any setup issues
- Ensure your device is connected or emulator is running
- Use `flutter clean` if you encounter build issues

## Dependencies

- `flutter/material.dart` - UI framework
- `provider` - State management
- `shared_preferences` - Local preferences storage
- SQLite database service (custom implementation)

## Usage

1. **Adding Tasks**: Use the add functionality to create new todos
2. **Managing Tasks**: Update or delete existing tasks as needed
3. **Theme Switching**: Toggle between light and dark modes
4. **Data Persistence**: All changes are automatically saved locally

## Project Structure

```
lib/
├── using_shared/
│   ├── model/
│   │   └── todo_model.dart
│   └── service/
│       └── todo_service_api.dart
└── controllers/
    └── todo_controller.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Future Enhancements

- Cloud synchronization
- Task categories and tags
- Due date reminders
- Task priorities
- Search and filter functionality
- Export/import capabilities

---

Built with ❤️ using Flutter and Provider