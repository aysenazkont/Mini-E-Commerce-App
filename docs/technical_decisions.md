# Technical Decisions Report

This document outlines the architectural choices, library selections, and design patterns implemented throughout the development of the application.

---

## 1. Architectural Pattern: Feature-First Structure
* **Decision:** Adopted a Feature-First modular structure rather than a traditional Layer-First organization.
* **Reason:** Grouping code by business domain (`products`, `favorites`, `cart`) encapsulates models, presentation logic, and repositories within their respective boundaries. This maximizes code maintainability, reduces cognitive overhead, and minimizes version control merge conflicts in collaborative workflows.

---

## 2. State Management: Flutter Riverpod
* **Decision:** Selected Flutter Riverpod 2.x as the primary state management solution.
* **Reason:**
  - Provides compile-time safety and dependency injection independent of the `BuildContext` tree.
  - Simplifies asynchronous UI state handling via `AsyncValue.when`, eliminating manual flag checks for loading and error states.
  - Supports scoped and parameterized lookups via `.family`, allowing individual list items to watch their specific state (e.g., favorite status) without triggering costly full-list rebuilds.

---

## 3. Networking Client: Dio
* **Decision:** Utilized `Dio` over the standard `http` package.
* **Reason:** Offers superior out-of-the-box support for global configurations (base URLs, timeouts), structured interceptors for logging or token injection, and unified error handling across endpoints.

---

## 4. Local Persistence: SharedPreferences & Repository Pattern
* **Decision:** Stored favorites and shopping cart items locally using `SharedPreferences` abstracted behind concrete repository classes.
* **Reason:**
  - Provides a lightweight, reliable persistence mechanism without the operational overhead of a relational database (e.g., SQLite) or NoSQL engine (e.g., Hive) for simple serialized data.
  - Decoupling data operations into `FavoritesRepository` and `CartRepository` allows the underlying storage engine to be replaced in the future without modifying any presentation or business logic.

---

## 5. Performance Optimization: Search Debouncing
* **Decision:** Integrated a 500ms debounce timer on search inputs before dispatching remote queries.
* **Reason:** Mitigates the "rapid-fire" request problem where every keystroke sends an HTTP query to the server, drastically reducing bandwidth consumption and server load.

---

## 6. Responsive & Adaptive UI Strategy
* **Decision:** Leveraged `MediaQuery` breakpoints alongside flexible layout builders.
* **Reason:** Ensures cross-platform visual consistency. Single-column lists and sticky summary bars are used on mobile devices, while viewports wider than 700px dynamically adapt into multi-column product grids and dual-pane side-by-side cart layouts.