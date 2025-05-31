# Kib Sales Force

A Flutter-based Visits Tracker for RTM Sales Force Automation that helps sales teams manage and track customer visits efficiently.

## Overview

Kib Sales Force is a mobile application designed to streamline the process of tracking and managing customer visits for sales teams. The app provides features for creating, managing, and analyzing customer visits, with robust offline support and real-time synchronization.

### Key Features

- User Authentication (Firebase Auth)
- Customer Visit Management
- Offline Data Support
- Visit Statistics and Analytics
- Search and Filter Capabilities
- Dark/Light Theme Support

## Screenshots

### Visit Management
![Create Visit Flow](assets/screenshots/create-visit-one_dev.kib.kib_sales_force.jpg)
![Visit Details](assets/screenshots/create-visit-two_dev.kib.kib_sales_force.jpg)
![Visit Creation](assets/screenshots/create-visit-three_dev.kib.kib_sales_force.jpg)

### Search and Analytics
![Search and Filter](assets/screenshots/search-filter-one_dev.kib.kib_sales_force.jpg)
![Visit List](assets/screenshots/search-visits-two_dev.kib.kib_sales_force.jpg)
![Statistics View](assets/screenshots/view-basic-statistics_dev.kib.kib_sales_force.jpg)
![Customer Visits](assets/screenshots/view-list-of-customer-visits_dev.kib.kib_sales_force.jpg)

## Architecture

The application follows a clean architecture pattern with the following key components:

### 1. Presentation Layer
- Screens and widgets organized by feature
- Provider pattern for state management
- Reusable components in `presentation/reusable_widgets`

### 2. Data Layer
- Models utilizing JsonSerializable and Equatable
- Services for business logic
- ObjectBox for local database
- Firebase for authentication and cloud storage

### 3. Core Layer
- Constants and utilities
- Error handling
- Preferences management

### 4. Configuration
- Environment configuration
- Theme configuration
- Route management using GoRouter

## Key Architectural Choices

1. **ObjectBox Database**
   - Chosen for its high performance and offline-first capabilities
   - Provides robust local storage
   - Efficient querying and data management

2. **Provider Pattern**
   - Simple and effective state management
   - Easy to test and maintain
   - Good balance between complexity and functionality

3. **GoRouter**
   - Type-safe routing
   - Deep linking support
   - Clean navigation management

4. **Firebase Integration**
   - Authentication for secure user management
   - Cloud Firestore for real-time data sync
   - Scalable backend infrastructure

## Setup Instructions

1. **Prerequisites**
   - Flutter SDK (>=3.0.0)
   - Dart SDK (>=3.0.0)
   - Firebase project setup

2. **Installation**
   ```bash
   # Clone the repository
   git clone [repository-url]
   cd kib_sales_force

   # Install dependencies
   flutter pub get

   # Run the app
   flutter run
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Add your `google-services.json` to the android/app directory
   - Configure Firebase in the app using the provided configuration

## Offline Support

The application implements robust offline support through:

- ObjectBox local database for data persistence

## Testing

The project includes:

- Integration tests for database operations

Run tests using:
```bash
flutter test
```

## Assumptions and Limitations

1. **Assumptions**
   - Stable internet connection for initial setup
   - Firebase project properly configured
   - Device has sufficient storage for local database
   - Backend server working as expected.

## Trade-offs

1. **Local Database**
   - Pros: Fast access, offline support
   - Cons: Increased app size, storage management

2. **Provider Pattern**
   - Pros: Simple, easy to understand
   - Cons: May need additional setup for more complex state

3. **Firebase Integration**
   - Pros: Quick setup, scalable
   - Cons: Vendor lock-in, potential costs at scale

## Project Structure

```
kib_sales_force/
├── assets/
│   ├── images/
│   └── screenshots/
│       ├── create-visit-one_dev.kib.kib_sales_force.jpg
│       ├── create-visit-three_dev.kib.kib_sales_force.jpg
│       ├── create-visit-two_dev.kib.kib_sales_force.jpg
│       ├── search-filter-one_dev.kib.kib_sales_force.jpg
│       ├── search-visits-two_dev.kib.kib_sales_force.jpg
│       ├── view-basic-statistics_dev.kib.kib_sales_force.jpg
│       └── view-list-of-customer-visits_dev.kib.kib_sales_force.jpg
│
├── integration_test/
│   └── app_database_dao_tests/
│       ├── customer_entity_dao_test.dart
│       └── theme_mode_dao_test.dart
│
├── lib/
│   ├── app.dart
│   ├── config/
│   │   ├── env/
│   │   │   ├── env.dart
│   │   │   └── env.g.dart
│   │   ├── firebase_config/
│   │   │   └── config.dart
│   │   ├── routes/
│   │   │   ├── navigation_helpers.dart
│   │   │   └── router_config.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── errors/
│   │   │   └── exceptions.dart
│   │   ├── preferences/
│   │   │   ├── base.dart
│   │   │   └── shared_preferences_manager.dart
│   │   └── utils/
│   │       ├── common_enum.dart
│   │       ├── data_generators.dart
│   │       ├── export.dart
│   │       ├── global_keys.dart
│   │       └── logout_utils.dart
│   │
│   ├── data/
│   │   └── models/
│   │       ├── activity.dart
│   │       ├── activity.g.dart
│   │       ├── customer.dart
│   │       ├── customer.g.dart
│   │       ├── export.dart
│   │       ├── visit.dart
│   │       └── visit.g.dart
│   │
│   ├── di/
│   │   └── setup.dart
│   │
│   ├── firebase_options.dart
│   ├── firebase_services/
│   │   └── firebase_auth_service.dart
│   │
│   ├── main.dart
│   ├── main_ext.dart
│   │
│   ├── presentation/
│   │   ├── reusable_widgets/
│   │   │   ├── create_visit_bottomsheet.dart
│   │   │   ├── data_card.dart
│   │   │   ├── exit_confirmation_dialog.dart
│   │   │   ├── export.dart
│   │   │   ├── visit_details_bottomsheet.dart
│   │   │   └── visits_statistics_card.dart
│   │   └── screens/
│   │       ├── auth/
│   │       │   ├── sign_in/
│   │       │   │   └── sign_in_screen.dart
│   │       │   └── sign_up/
│   │       │       └── sign_up_screen.dart
│   │       ├── home/
│   │       │   └── home_screen.dart
│   │       └── initial_my_home_page.dart
│   │
│   ├── providers/
│   │   ├── create_visit_provider.dart
│   │   ├── export.dart
│   │   └── home_screen_provider.dart
│   │
│   └── services/
│       ├── activities_service.dart
│       ├── customers_service.dart
│       ├── export.dart
│       └── visits_service.dart
│
└── packages/
    ├── app_database/
    │   ├── lib/
    │   │   ├── app_database.dart
    │   │   ├── dao/
    │   │   │   ├── activity_entity_dao.dart
    │   │   │   ├── base.dart
    │   │   │   ├── customer_entity_dao.dart
    │   │   │   ├── export.dart
    │   │   │   ├── queryManager/
    │   │   │   │   ├── base.dart
    │   │   │   │   ├── enums.dart
    │   │   │   │   ├── export.dart
    │   │   │   │   └── theme_mode_dao_querymanager.dart
    │   │   │   ├── theme_mode_dao.dart
    │   │   │   └── visit_entity_dao.dart
    │   │   ├── database_service.dart
    │   │   ├── models/
    │   │   │   ├── activity_entity.dart
    │   │   │   ├── customer_entity.dart
    │   │   │   ├── export.dart
    │   │   │   ├── model_ids.dart
    │   │   │   ├── theme_mode_model.dart
    │   │   │   └── visit_entity.dart
    │   │   ├── objectbox-model.json
    │   │   └── objectbox.g.dart
    │   └── test/
    │       └── app_database_test.dart
    │
    └── app_http/
        ├── lib/
        │   ├── app_http.dart
        │   ├── config/
        │   │   ├── env.dart
        │   │   └── env.g.dart
        │   ├── server_service.dart
        │   └── utils/
        │       ├── api_error.dart
        │       ├── api_paths.dart
        │       ├── api_response.dart
        │       ├── constants.dart
        │       ├── export.dart
        │       ├── http_validator.dart
        │       └── retry_options.dart
        └── test/
            └── app_http_test.dart
```

### Directory Structure Overview

1. **Root Level**
   - `assets/`: Contains images and screenshots
   - `integration_test/`: Integration tests for database operations
   - `lib/`: Main application code
   - `packages/`: Local packages for database and HTTP functionality

2. **Main Application (`lib/`)**
   - `config/`: Application configuration (env, routes, theme)
   - `core/`: Core utilities and constants
   - `data/`: Data models and repositories
   - `di/`: Dependency injection setup
   - `firebase_services/`: Firebase integration
   - `presentation/`: UI components and screens
   - `providers/`: State management
   - `services/`: Business logic services

3. **Local Packages**
   - `app_database/`: ObjectBox database implementation
   - `app_http/`: HTTP client and API utilities
