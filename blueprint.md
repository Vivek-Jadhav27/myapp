# Project Blueprint

## Overview

This document outlines the architecture, features, and design of the Flutter application. It serves as a single source of truth for the project, providing a comprehensive guide for developers and stakeholders.

## Architecture

The application follows a clean architecture pattern, with a clear separation of concerns between the data, domain, and presentation layers. This ensures that the codebase is modular, scalable, and easy to maintain.

### Data Layer

The data layer is responsible for all communication with external data sources, such as APIs and databases. It includes repositories that abstract the data sources from the rest of the application, as well as models that represent the data.

### Domain Layer

The domain layer contains the business logic of the application. It includes use cases that orchestrate the flow of data between the data and presentation layers, as well as entities that represent the core business objects.

### Presentation Layer

The presentation layer is responsible for the user interface. It includes widgets that display the data and handle user input, as well as providers that manage the state of the UI.

## Implemented & In-Progress Features

### Authentication
- **Status**: Implemented
- **Details**: A complete authentication feature with email/password login and registration. State is managed via `AuthNotifier`.

### Transaction Management
- **Status**: Implemented
- **Details**: The `transactions` feature is now fully implemented, allowing users to view a list of their transactions. The feature is integrated with Firestore and follows a clean architecture. State is managed via `TransactionProvider`.
- **File Structure**:
  ```
  lib/features/
  └── transactions/
      ├── domain/
      │   ├── entities/
      │   │   └── transaction.dart
      │   ├── repositories/
      │   │   └── transaction_repo.dart
      │   └── usecases/
      │       ├── add_transaction_uc.dart
      │       ├── get_transactions_uc.dart
      │       ├── update_transaction_uc.dart
      │       └── delete_transaction_uc.dart
      ├── data/
      │   ├── models/
      │   │   ├── transaction_model.dart
      │   │   ├── income_model.dart
      │   │   └── expense_model.dart
      │   ├── datasources/
      │   │   └── transaction_ds.dart
      │   └── repositories/
      │       └── transaction_repo_impl.dart
      └── presentation/
          ├── screens/
          │   └── transactions_screen.dart
          └── provider/
              └── transaction_provider.dart
  ```

### Theming and UI
- **Status**: Implemented
- **Details**: The app supports both light and dark themes with a toggle. The initial `HomeScreen` has been replaced with the `TransactionsScreen` as the main screen after login.

## Dependencies

- `cloud_firestore`
- `dartz`
- `firebase_auth`
- `firebase_core`
- `get_it`
- `google_fonts`
- `provider`

## Planned Enhancements

### Advanced Transaction Features
- **Add/Edit Transactions**: Implement the UI and logic for adding and editing transactions.
- **Transaction Notes & Tags**: Allow users to add notes or tags to transactions for better context.
- **Attachment Support**: Users can attach receipts or invoices as images.

### Enhanced Analysis & Insights
- **Spending Analysis**: Implement UI for charts and category breakdowns.
- **Spending Alerts**: Notify users when they approach or exceed budget limits.
- **Comparison Charts**: Compare this month’s spending with previous months.
- **Trend Predictions**: (Future Goal) Use past data to suggest likely future spending patterns.

### Budget Management
- **Budget Feature**: Implement the UI and logic for setting and tracking budgets.

### Debt Payoff Tracker
- **Debt Feature**: Implement the UI and logic for tracking and managing debts.

### Financial Goals
- **Goals Feature**: Implement the UI and logic for defining and monitoring financial goals.

### Recurring Transactions
- **Recurring Transactions Feature**: Implement the UI and logic for managing automatic recurring transactions.
