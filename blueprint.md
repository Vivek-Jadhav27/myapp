# Blueprint

## Overview

This document outlines the architecture, features, and design of the Finance Tracker app. It is intended to be a living document that will be updated as the app evolves.

## Features

### Authentication

*   Users can create an account with their email and password.
*   Users can log in and out of the app.
*   The app uses Firebase Authentication to manage user accounts.

### Expense & Income Tracking

*   Users can add new expenses and income.
*   Users can view their expenses and income in a calendar view.
*   Each expense is assigned to a category.
*   Users can add notes to each expense.

### Spending Analysis

*   The app provides a pie chart that shows a breakdown of spending by category for the selected month.
*   Users can navigate between months to view their spending history.

### Custom Categories

*   Users can create, delete, and reorder their own expense categories.
*   The "Add Expense" form uses a dropdown menu with the user's custom categories.
*   The "Spending Analysis" chart updates to reflect the user's custom categories.

### User Profile

*   Users can view and update their profile information, including their name and email address.

### Financial Goals

*   Users can set and track their financial goals.
*   Each goal has a target amount and a deadline.
*   The app displays the user's progress toward each goal.

### Debt Payoff Tracker

*   Users can track their progress in paying off their debts.
*   Each debt has a total amount, interest rate, and minimum monthly payment.
*   The app shows how much of each debt has been paid off.

### AI-Powered Financial Assistant

*   Users can ask financial questions and get personalized advice from an AI-powered chatbot.
*   The chatbot is powered by Firebase Vertex AI.

## Design

### Theme

*   The app uses a pastel and friendly color scheme.
*   It supports both light and dark modes.
*   The `google_fonts` package is used for a clean and modern typography.

### Components

*   The app is built with Material Design components.
*   Custom styling is applied to create a unique and visually appealing user interface.

## Architecture

### State Management

*   The app uses the `provider` package for state management.
*   `ChangeNotifierProvider` is used to manage the theme and authentication state.
*   A custom `CategoryProvider` is used to manage the user's expense categories.

### Services

*   `AuthService`: Manages user authentication with Firebase.
*   `FirestoreService`: Interacts with the Firestore database to store and retrieve user data, expenses, income, financial goals, and debts.

### Models

*   `AppUser`: Represents a user of the app.
*   `Expense`: Represents a single expense.
*   `Income`: Represents a single income entry.
*   `Category`: Represents an expense category.
*   `FinancialGoal`: Represents a financial goal.
*   `Debt`: Represents a debt.

### Screens

*   `Wrapper`: A top-level widget that determines whether to show the login screen or the home screen based on the user's authentication state.
*   `LoginScreen`: Allows users to sign in or create an account.
*   `Home`: The main screen of the app, which includes a bottom navigation bar to switch between the calendar and analysis views.
*   `CalendarScreen`: Displays the user's expenses and income in a calendar format.
*   `AnalysisScreen`: Shows a pie chart of the user's spending by category.
*   `SettingsScreen`: Provides access to the "Manage Categories," "Profile," "Financial Goals," "Debt Payoff Tracker," and "Financial Assistant" screens.
*   `ManageCategoriesScreen`: Allows users to manage their expense categories.
*   `ProfileScreen`: Allows users to view and update their profile information.
*   `FinancialGoalsScreen`: Allows users to set, track, and manage their financial goals.
*   `DebtPayoffTrackerScreen`: Allows users to add, view, and manage their debts.
*   `ChatScreen`: Provides a user interface for the AI-powered financial assistant.
