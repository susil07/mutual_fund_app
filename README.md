# Mutual Fund Browser App

A Flutter application for browsing mutual funds using the [mfapi.in](https://www.mfapi.in/) public API.

## Features
* **Authentication**: Dummy login flow using Flutter Secure Storage to persist user sessions.
* **Discover Funds**: Browse a comprehensive list of mutual funds with real-time, debounced client-side searching.
* **Fund Details**: View a detailed 30-day NAV history, complete with a dynamic, interactive line chart.
* **Dark Mode**: Fully supports iOS/Android system dark and light modes, with a custom manual toggle.

## How to Run Locally

### Prerequisites
1. [Install Flutter](https://docs.flutter.dev/get-started/install) (Ensure you are on the `stable` channel and have run `flutter doctor`).
2. Clone this repository.

### Running the App
1. Open a terminal and navigate to the project directory:
   ```bash
   cd mutual_fund_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## Login Credentials

This app uses a mock authentication flow. You do not need real credentials to log in. 

* **Email**: Any valid email format containing an `@` symbol (e.g., `test@test.com`)
* **Password**: Any non-empty password (e.g., `123456`)

## Technical Assumptions & Design Decisions

1. **Client-Side Search/Pagination**: The `GET /mf` API endpoint returns over 40,000 schemes at once and does not natively support pagination or search query parameters. To handle this efficiently without locking the UI, the JSON payload is parsed in a background isolate (`compute`), and the application implements its own client-side pagination and RxDart-debounced searching.
2. **Chart Rendering**: The NAV line chart renders a maximum of the most recent 30 data points. It dynamically calculates its Y-axis intervals and bounds to ensure smooth rendering regardless of the dataset's volatility.
3. **Mock Investment Flow**: The "Invest Now" action uses a bottom sheet with basic UI validation (minimum ₹100). The actual investment action is mocked and does not communicate with a payment gateway.
4. **Clean Architecture**: The app strictly adheres to Clean Architecture utilizing the Bloc pattern for robust state management.
