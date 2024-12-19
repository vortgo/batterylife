# Battery Life Application

This Connect IQ application tracks the battery status of a Garmin device, calculates the time since the last charge, and provides status updates in both the foreground and background. It includes a toggle to activate or deactivate the background process.

## Table of Contents

- [Overview](#overview)
- [Application Structure](#application-structure)
  - [Foreground Components](#foreground-components)
  - [Background Components](#background-components)
- [Key Features](#key-features)
- [How It Works](#how-it-works)
  - [Background Service](#background-service)
  - [Foreground View](#foreground-view)
  - [Behavior Delegate](#behavior-delegate)
- [Important Notes](#important-notes)

## Overview
The application tracks the following metrics:
- **Battery percentage**: Monitors the battery percentage and detects when the device is charging.
- **Time since last charge**: Calculates and displays the time elapsed since the last full charge.
- **Status toggle**: Allows users to enable or disable the background tracking functionality.

## Application Structure

- **Entry Point**: The `batterylifeApp` class serves as the entry point, marked with the `(:background)` annotation to enable background service functionality.
- **Background Service**: The `batterylifeBackground` class runs periodically every 5 minutes.
- **View Delegate**: The `batterylifeDelegate` class handles the `select` button presses and manages interactions.
- **View**: The `batterylifeView` class represents the sole screen of the application.

### Foreground Components

1. **`batterylifeView`** (UI Layer):
   - Manages the user interface, showing the following details:
     - Current status: `ACTIVE` or `INACTIVE`
     - Last time the service was started
     - Time elapsed since the last charge
   - Uses a timer to update the view every second.

2. **`batterylifeDelegate`** (Behavior Layer):
   - Handles interactions, such as toggling the background process.
   - Tracks the background task's status and manages storage values for the battery state and timestamps.

3. **`batterylifeApp`** (Application Layer):
   - The main application class that initializes the view and delegates.
   - Provides access to the background service.

### Background Components

1. **`batterylifeBackground`** (Service Delegate):
   - Monitors battery status in the background.
   - Saves the timestamp when the battery percentage increases (indicating charging).
   - Stops the background process when requested.

## Key Features

1. **Background Battery Monitoring**:
   - Tracks battery percentage and records the timestamp when the battery starts charging.

2. **Elapsed Time Calculation**:
   - Displays the time since the last charge in the format: `13 day(s) 04:05:06`.

3. **Status Toggle**:
   - Allows users to start or stop the background process via a toggle.

4. **Periodic Updates**:
   - The view is updated every second to reflect real-time information.

## How It Works

### Background Service
- **Class**: `batterylifeBackground`
- **Responsibilities**:
  1. Detects changes in battery percentage using `System.getSystemStats().battery`.
  2. Saves the timestamp of the charge start using `Storage.setValue()`.
  3. Registers periodic events with `registerForTemporalEvent()` to run every 5 minutes.
  4. Compares the current battery percentage with the last recorded percentage. If the current percentage is higher, it records the new charge time.
- **Key Methods**:
  - `onTemporalEvent`: Checks battery status and updates storage.

### Foreground View
- **Class**: `batterylifeView`
- **Responsibilities**:
  1. Displays the application's status, time since last charge, and last start timestamp.
  2. Periodically updates the view every second using a timer (`Timer.Timer`).
  3. Calculates the time difference between the last recorded charge time and the current time.
- **Key Methods**:
  - `onUpdate`: Updates the displayed data based on values in storage.
  - `updateStatus`: Changes the `ACTIVE` or `INACTIVE` status on the UI.

### Behavior Delegate
- **Class**: `batterylifeDelegate`
- **Responsibilities**:
  1. Toggles the background process when the user interacts with the app.
  2. Manages storage values for timestamps and status.
  3. Starts the watcher (background service) when the application is opened.
- **Key Methods**:
  - `onSelect`: Starts or stops the background process.
  - `getCurrentTimestamp`: Formats the current time into a human-readable string.

### Application Layer
- **Class**: `batterylifeApp`
- **Responsibilities**:
  - Initializes the view and background delegate.
  - Provides access to the background service.

## Important Notes

1. **Storage Management**:
   - The application uses `Storage.setValue()` and `Storage.getValue()` to persist data between the foreground and background components.
   - Keys used:
     - `"status"`: Indicates whether the background process is active.
     - `"charge_time"`: Timestamp of the last charge.
     - `"last_start_at"`: Timestamp of the last service start.

2. **Temporal Event Handling**:
   - Background tasks are registered using `Background.registerForTemporalEvent()` with a 5-minute interval.
   - The temporal event is unregistered when the process is stopped.

3. **Timer for UI Updates**:
   - The view refreshes every second using a `Timer.Timer`. The timer is stopped when the view is hidden.

4. **Date and Time Formatting**:
   - Dates and times are formatted using `Lang.format()` and `Time.Gregorian` to ensure a consistent format across the app.

## Example Output

- **Status**: ACTIVE
- **Last Started At**: `2024-12-19 12:00:00`
- **Since Last Charge**: `2 day(s) 03:45:23`

