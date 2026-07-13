**Technical Decisions**

**1. Project Summary**
This project is a Mini E-Commerce mobile app developed using Flutter that has features such as server integration and local storage.

**2. Architecture Approach**
Feature-First architecture is chosen for this project.
Layer-First approach was also considered. However in Layer-First structure, it gets difficult to track the code as the project gets bigger.
Feature-First was chosen since it makes developing seperate modules for the app such as product and cart possible. Therefore a developer can focus on individual folders without affecting the other features. 

**3. State Management Solution**
Riverpod is chosen for this project.
Additionally, Flutter's setState structure and BLoC were examined.
Riverpod was chosen because it allows state management without being dependent on the Flutter context and it has high testability.

**4. Needed Basic Packs**
Dio is preferred over the standard http package due to its error handling and advanced settings in REST API integration.
GoRouter is chosen for being easy to use with declarative routing and deep linking support.
Shared Preferences / Hive is chosen for quickly storing favorite products locally.

**5. Technical Issues Identified as Risks**
Slow Network Connections: Delays that may occur while receiving data from the API risk disrupting the user experience. This will be optimized with Loading and Error states.
Image Loading Failures: Cached network image packages will be used to prevent interface corruption when product images are broken or load slowly.