# BillLearn App

This directory contains the Flutter application for BillLearn.

The repository-level README contains the product overview, design direction, and implementation plan. This app package contains the runnable Flutter project.

## Commands

Run from this `app/` directory:

```powershell
..\.tools\flutter\bin\flutter.bat test
..\.tools\flutter\bin\flutter.bat analyze
..\.tools\flutter\bin\cache\dart-sdk\bin\dart.exe format lib test
```

## Current Entry Point

`lib/main.dart` launches `BillLearnApp`, which wires the app theme, router, and core navigation shell.
