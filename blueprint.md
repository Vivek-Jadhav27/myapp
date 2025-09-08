# Finance Tracker App Blueprint

## Overview

This document outlines the plan and progress of the Finance Tracker mobile application. The app will allow users to track their income and expenses, manage their budget, and view financial reports.

## Features

- **User Authentication:** Users can sign up and log in to their accounts securely.
- **Transaction Management:** Users can add, edit, and delete their income and expense transactions.
- **Budgeting:** Users can set monthly budgets for different spending categories.
- **Reporting:** Users can view reports and charts to visualize their financial habits.

## Tech Stack

- **Frontend:** Flutter
- **Backend:** Firebase (Authentication, Firestore)
- **State Management:** Provider

## Current State

- Firebase project is created and connected to the Flutter app.
- Basic app structure with `provider` for state management and an `AuthService` is in place.

## Plan

1. **Create a Home Screen:** Build a simple home screen to be displayed after the user logs in.
2. **Implement Authentication Flow:** Create login and signup screens and connect them to the `AuthService`.
3. **Implement Firestore:** Set up Firestore to store user transactions and budget data.
4. **Build Transaction Management UI:** Create UI for adding, editing, and viewing transactions.
5. **Build Budgeting UI:** Create UI for setting and tracking budgets.
6. **Build Reporting UI:** Create UI for displaying financial reports and charts.
