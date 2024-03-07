# tdv2_showcase_mobile

A sample app for showcasing Flutter Trusted Device SDK.

## Project Structure
This project uses flutter_clean_architecture.

This architecture consist of 4 main layers, which is:
1. Domain: This is where you put your Business entities (objects), Use Cases and Base Repositories as your project foundation.
2. App: This is where you put your UI at work and design how your app would look.
3. Data: This is where you interact with your database. All database interactions (e.g. fetch, create, read, update etc.) should be here.
4. Device: This is where you interact with your external libraries (packages). So your app doesn't depend on external libraries.

![Clean Architecture by Uncle Bob](clean_architecture.jpg)

for more information, read: https://pub.dev/packages/flutter_clean_architecture
