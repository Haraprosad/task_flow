# TaskFlow: Efficient Time Tracking and Task Management

![TaskFlow App Demo](/assets/gif/screenrecord.gif)

TaskFlow is a powerful, user-friendly time tracking and task management application built with Flutter. It combines a sleek interface with robust features to help you organize, track, and complete your tasks efficiently.

## 🌟 Key Features

- **Kanban Board**: Intuitive task management with drag-and-drop functionality
- **Time Tracking**: Built-in timer for accurate task duration measurement
- **Task History**: Comprehensive view of completed tasks with time spent
- **Comments**: Add and manage comments for each task
- **Multiple Themes**: Personalize your app experience
- **Offline Support**: Work seamlessly, even without an internet connection
- **Multi-language Support**: Global accessibility

## 🛠 Technology Stack

- **Framework**: Flutter (SDK version: >=3.4.3 <4.0.0)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (^8.1.6)
- **Dependency Injection**: [injectable](https://pub.dev/packages/injectable) (^2.4.2) and [get_it](https://pub.dev/packages/get_it) (^7.7.0)
- **Routing**: [go_router](https://pub.dev/packages/go_router) (^14.2.0)
- **Localization**: [easy_localization](https://pub.dev/packages/easy_localization) (^3.0.7)
- **Local Data Storage**: [Hive](https://pub.dev/packages/hive) (^2.2.3) and [hive_flutter](https://pub.dev/packages/hive_flutter) (^1.1.0)
- **Network**: [dio](https://pub.dev/packages/dio) (^5.4.3+1)
- **Environment Configuration**: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) (^5.1.0)
- **Logging**: [logger](https://pub.dev/packages/logger) (^2.3.0)
- **Remote Data Source**: [Todoist API](https://developer.todoist.com/rest/v2)

## 🏗 Architecture and Development Practices

- **Clean Architecture**: Ensures separation of concerns and maintainability
- **SOLID Principles**: Adheres to best practices in software engineering
- **Comprehensive Testing**: Unit tests implemented using [bloc_test](https://pub.dev/packages/bloc_test) and [mockito](https://pub.dev/packages/mockito)
- **Global Error Handling**: Robust error management for a smooth user experience
- **Multiple Theme Support**: Customizable app appearance
- **Responsive Design**: Utilizing [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) for adaptable UI

## 🚀 Getting Started

### Prerequisites

- Flutter (version >=3.4.3 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/YourUsername/TaskFlow.git
   ```

2. Navigate to the project directory:
   ```sh
   cd TaskFlow
   ```

3. Install dependencies:
   ```sh
   flutter pub get
   ```

4. Set up your environment variables:
   - The project uses three environment files: `.env.production`, `.env.development`, and `.env.staging`
   - Add your Todoist API authorization token to the appropriate file:
     ```
     TOKEN=your_todoist_api_token_here
     BASE_URL=https://api.todoist.com/rest/v2
     ```

5. Run the app:
   ```sh
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── loggers/
│   │   └── observers/
│   ├── constants/
│   ├── di/
│   ├── extensions/
│   ├── i10n/
│   ├── network/
│   ├── router/
│   ├── theme/
│   ├── usecases/
│   ├── utils/
│   └── widgets/
├── features/
│   └── kanban_board/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── main.dart
```
### Key Structure Points

#### Core
Contains application-wide utilities, configurations, and shared components.

| Directory | Description |
|-----------|-------------|
| `config`  | Includes loggers and observers for app-wide monitoring |
| `di`      | Dependency injection setup |
| `i10n`    | Internationalization configurations |
| `router`  | Navigation setup using go_router |
| `theme`   | App-wide theming configurations |

#### Features
Organizes code by feature (e.g., kanban_board), each following clean architecture principles.

| Layer | Description |
|-------|-------------|
| `data` | Data layer with API interfaces, models, and repository implementations |
| `domain` | Business logic layer with entities, repository interfaces, and use cases |
| `presentation` | UI layer with BLoC (Business Logic Component), pages, and widgets |

### 🧭 Navigation

TaskFlow leverages [go_router](https://pub.dev/packages/go_router) for navigation, offering a clean and declarative approach to routing. This powerful setup provides:

- ✅ Deep linking support
- ✅ Easy nested navigation
- ✅ Efficient route management for complex app structures

> 📁 The router configuration can be found in `lib/core/router/`

## 🎨 Assets and Styling

- **Custom Font**: JosefinSans (Regular, Medium, SemiBold, Bold, Italic)
- **Images**: Stored in `assets/images/`
- **Translations**: Located in `assets/translations/`

<!-- ## 📚 Documentation

For more detailed information about the app's architecture, coding standards, and contribution guidelines, please refer to our [Wiki](link-to-your-wiki). -->

<!-- ## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](link-to-contributing-guide) for more details. -->

<!-- ## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. -->

## 🙏 Acknowledgements

- [Flutter](https://flutter.dev/)
- [Todoist API](https://developer.todoist.com/rest/v2)
- [Bloc Library](https://bloclibrary.dev/)
- [injectable](https://pub.dev/packages/injectable)
- [get_it](https://pub.dev/packages/get_it)
- [easy_localization](https://pub.dev/packages/easy_localization)
- [Hive](https://pub.dev/packages/hive)
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- [go_router](https://pub.dev/packages/go_router)
- [dio](https://pub.dev/packages/dio)
- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- [logger](https://pub.dev/packages/logger)

---

❤️ Developed by [Haraprosad Biswas](https://www.linkedin.com/in/haraprosadbiswas/)