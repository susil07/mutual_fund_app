# Mutual Fund Browser App

A Flutter application built with Clean Architecture, Bloc, and Dio, featuring a comprehensive mutual fund browser.

## Architecture

This project is built using **Clean Architecture** principles and **BLoC (Business Logic Component)** for state management. The app is divided into `core` and `features`:
- **Core:** Networking (Dio), Themes, and Error handling.
- **Features:** 
  - `auth` (Login, Auto-login, Token storage)
  - `scheme_list` (API fetching, Debounced Search, Pull-to-refresh, Client-side pagination)
  - `scheme_detail` (NAV history fetching, Investment Bottom Sheet)

## Assumptions
- **Pagination:** The `/mf` endpoint returns over 40,000 items in a single array without supporting offset/limit query parameters. To keep the UI performant, the app implements **client-side pagination**.
- **Dummy Token:** Any non-empty password combined with a valid email (containing `@`) triggers a successful login. The token is stored securely using `flutter_secure_storage`.
- **Search:** Filtering is performed locally on the fetched scheme list because the API does not offer a search parameter.

## How to run

1. **Clone the repository or navigate to the project directory:**
   ```bash
   cd mutual_fund_app
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App:**
   ```bash
   flutter run
   ```

## Dummy Credentials

You can use the following dummy credentials to log in:
- **Email:** test@test.com (must contain an `@` symbol)
- **Password:** 123456 (must not be empty)

## Key Features Completed
- **Auto Login:** Persists a dummy token securely.
- **Debounced Search:** Uses `rxdart` to debounce search inputs.
- **Client-Side Pagination:** Ensures `ListView` remains performant despite massive API payloads.
- **Pull-to-refresh:** Easily reload the mutual funds list.
- **Investment Validation:** Ensures users can only invest ₹100 or more via the Bottom Sheet.
