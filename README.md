# Travel Explor ✈️

Travel Explor is a Flutter travel application that helps users explore tourist destinations, search for places, save their favorite destinations, and search for hotels.

The project was built using Flutter with a focus on clean code, feature-based structure, state management, local storage, API integration, authentication, localization, and reusable components.

## Features

### Authentication

* User Registration
* User Login
* Forgot Password
* Firebase Authentication
* User profile information
* Logout

### Destinations

* Explore tourist destinations
* Retrieve destinations using REST APIs
* Search destinations
* Display destination information
* View destination details
* Favorite destinations
* Store favorites locally

### Hotels

* Search for hotels
* Enter destination
* Select check-in and check-out dates
* Select number of adults
* Select number of children
* Display hotel results
* Display hotel information

### Localization

* English language
* Arabic language
* Change language from the Profile screen
* Save selected language locally
* RTL support for Arabic

### Theme

* Light Mode
* Dark Mode
* Change theme from the Profile screen
* Save theme preference locally

### Notifications

* Local notifications
* Trip reminder notifications
* Firebase Cloud Messaging integration

### User Profile

* Display user information
* Change application language
* Change application theme
* Logout

---

## Technologies & Packages

### Flutter & Dart

* Flutter
* Dart

### State Management

* Flutter Bloc
* Cubit

Cubit is used to manage application state and separate business logic from the UI.

### Dependency Injection

* GetIt

GetIt is used to manage dependencies and provide services and Cubits throughout the application.

### Networking

* Dio
* REST APIs
* Pretty Dio Logger

Dio is used for making HTTP requests and communicating with external APIs.

### Authentication & Backend

* Firebase Authentication
* Firebase
* Cloud Firestore

Firebase Authentication is used for user registration, login, password reset, and logout.

### Local Storage

* Hive
* Hive Flutter

Hive is used for storing local application data such as:

* Favorite destinations
* Selected language
* Theme preference

### Localization

* Flutter Localization
* ARB files
* `flutter_localizations`
* `AppLocalizations`

Supported languages:

* English 🇬🇧
* Arabic 🇪🇬

### Environment Variables

* Flutter Dotenv

Environment variables are used to keep API keys and sensitive configuration outside the source code.

### Notifications

* Firebase Cloud Messaging (FCM)
* Local Notifications

### UI & Navigation

* Flutter Material
* IndexedStack
* BottomNavigationBar
* Reusable widgets
* Named routes

---

## APIs & External Services

The application integrates with external services and APIs to retrieve travel-related data.

### Geoapify

Used to retrieve tourist attractions and places around different cities.

### Unsplash

Used to retrieve destination images.

### Hotel API

Used to search and retrieve hotel information based on:

* Destination
* Check-in date
* Check-out date
* Adults
* Children

## Architecture

The project follows a feature-based structure with Clean Architecture concepts.

The application is divided into:

* Core
* Features
* Data Layer
* Presentation Layer

Each feature is separated into its own module.

### Project Structure

lib/
│
├── core/
│   ├── di/
│   │   └── service_locaor.dart
│   │
│   ├── localization/
│   │   ├── app_en.arb
│   │   └── app_ar.arb
│   │
│   ├── networking/
│   │
│   ├── notifications/
│   │
│   ├── routes/
│   │
│   └── widget/
│
└── feature/
    │
    ├── auth/
    │   ├── data/
    │   └── presentation/
    │
    ├── fav/
    │   ├── data/
    │   └── presentation/
    │
    ├── home/
    │   ├── data/
    │   └── presentation/
    │
    ├── hotels/
    │   ├── data/
    │   └── presentation/
    │
    ├── profile/
    │   ├── data/
    │   └── presentation/
    │
    └── settings/
        └── presentation/


## Feature Structure

Each feature is organized into:

```text
feature/
└── feature_name/
    ├── data/
    │   ├── datasource/
    │   ├── models/
    │   └── repositories/
    │
    └── presentation/
        ├── cubit/
        ├── state/
        ├── ui/
        └── widgets/


This structure helps separate:

* API and database operations
* Models
* Business logic
* UI
* Reusable widgets



## State Management

The application uses **Cubit** from Flutter Bloc.
AuthCubit
HomeCubit
FavoritesCubit
HotelCubit
ProfileCubit
ThemeCubit
LocaleCubit
```

Each Cubit is responsible for managing the state of its related feature.



## Dependency Injection

The project uses **GetIt** for dependency injection.

Dependencies such as:

* Cubits
* Data sources
* Repositories
* Network clients
* Local storage services

are registered and accessed through GetIt.

---

## Local Storage

Hive is used for local data persistence.

The application stores:

```text
Favorite Destinations
Selected Language
Theme Mode
```

This allows user preferences and favorites to remain available after restarting the application.

---

## Localization

The project uses Flutter's localization system with ARB files.

```text
lib/
└── core/
    └── localization/
        ├── app_en.arb
        └── app_ar.arb
```

The application supports:

```text
English
Arabic
```

The selected language is stored locally using Hive.

---

## Theme Management

The application supports both:

```text
Light Mode
Dark Mode
```

Theme changes are handled using `ThemeCubit` and the selected theme is stored locally.

---

## Navigation

The main application navigation contains:

```text
Home
Hotels
Favorites
Profile
```

The project uses:

* `BottomNavigationBar`
* `IndexedStack`
* Named Routes

`IndexedStack` allows the main screens to maintain their state while navigating between tabs.

---

## Security

Sensitive configuration such as API keys is stored using environment variables instead of hardcoding them directly in the source code.

Example:

```text
.env
```

The `.env` file should not be committed to GitHub.

---

## Main Packages

Some of the main packages used in the project include:


flutter_bloc
dio
get_it
hive
hive_flutter
firebase_core
firebase_auth
cloud_firestore
flutter_localizations
flutter_dotenv
firebase_messaging
flutter_local_notifications




## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Sara2127365/travel_explorer.git
```

### 2. Open the project

```bash
cd travel_explorer
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Configure environment variables

Create a `.env` file and add the required API keys and configuration.

### 5. Configure Firebase

Connect the project to your Firebase project and configure the required Firebase files.

### 6. Generate localization files

```bash
flutter gen-l10n
```

### 7. Run the application

```bash
flutter run
```

---

## Future Improvements

Possible future improvements include:

* Destination map integration
* Improved hotel booking flow
* Hotel details screen
* Booking functionality
* Payment integration
* More travel destinations
* Improved recommendation system
* Unit and widget testing
* CI/CD
* Improved caching strategy

## Project Management

The project development and task management are organized using Trello.

**Trello Board:** [Travel Explor - Trello](https://trello.com/invite/b/6ab12dad54db1e538dcd2c9a/ATTIe5e878e002e970492fc5d58dda14db75DA6C49F1/my-trello-board)


## Author

**Sara Farag**

Flutter Developer | Dart

GitHub: Sara2127365

License:

This project is created for learning and portfolio purposes.
