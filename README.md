# Jewel Assist

A responsive Flutter application that displays click analytics with a beautiful UI. This project demonstrates:

- Responsive design using flutter_screenutil
- State management with Provider
- Custom UI components
- Chart visualization with Syncfusion Flutter Charts
- Clean architecture with separation of concerns

## Screenshots

The app replicates the design shown in the reference image, featuring:
- Click statistics cards
- Interactive weekly clicks chart with animations
- Top performing bitlinks list
- Search bar and bottom navigation

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Project Structure

- `lib/components/` - Reusable UI components
- `lib/constants/` - App constants like colors, text styles, and sizes
- `lib/models/` - Data models
- `lib/providers/` - State management using Provider
- `lib/screens/` - App screens
- `lib/utils/` - Utility functions

## Features

- Responsive UI that adapts to different screen sizes
- Interactive line chart with animations, tooltips, and zoom functionality
- List of top performing bitlinks with details
- Mock data provider that simulates API calls

## Dependencies

- flutter_screenutil: ^5.9.0
- provider: ^6.1.1
- syncfusion_flutter_charts: ^24.2.4
- intl: ^0.19.0

## License

This project is for demonstration purposes only.
