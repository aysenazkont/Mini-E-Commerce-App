# Mini E-Commerce App

This project is a mobile e-commerce application developed using Flutter as part of an internship program. The aim of the project is not only to develop a working application, but also to experience a real software development process, make correct technical decisions, and establish a sustainable architecture.

## Features

- **Product Discovery & Filtering:** Search bar, category chips, and responsive product grid.
- **Search & Debouncing:** 500ms reactive debouncing to prevent redundant network requests while typing.
- **Product Detail Screen:** Dynamic discount calculation, stock status indicators, detailed descriptions, and responsive media presentation.
- **Favorites Management & Persistence:** Persistent storage via `SharedPreferences` with immediate reactive state synchronization across screens.
- **Cart Management & Persistence:** Quantity adjustments (+ / -), automatic order total calculation, cart persistence across app restarts via `SharedPreferences`, and a dynamic counter badge on the AppBar.
- **Responsive & Adaptive Layout:** Automatic layout adjustments across mobile, tablet, and desktop viewports using adaptive grid counts and dual-pane views.
- **Resilient UI States:** Dedicated Loading, Error (with retry mechanism), and EmptyState components.

---

## Packages & Dependencies

| Package | Version | Purpose |
| :--- | :--- | :--- |
| `flutter_riverpod` | `^2.5.1` | Reactive state management and dependency injection (DI) |
| `dio` | `^5.4.3+1` | HTTP client, base configuration, and network error handling |
| `shared_preferences` | `^2.2.3` | Local key-value persistence for cart and favorites using JSON serialization |
| `go_router` | `^14.0.0` | Declarative routing and deep-linking with route parameters |
| `cached_network_image` | `^3.3.1` | Network image caching, memory optimization, and placeholder rendering |

---

## API Endpoints Used

The project uses the **DummyJSON API** as its primary remote data source:

* **All Products:** `GET https://dummyjson.com/products`
* **Search Products:** `GET https://dummyjson.com/products/search?q={query}`
* **Category List:** `GET https://dummyjson.com/products/categories`
* **Products by Category:** `GET https://dummyjson.com/products/category/{category}`
* **Product Detail:** `GET https://dummyjson.com/products/{id}`

---

## Architecture & Project Structure

The project follows a **Feature-First** modular architecture:

```text
lib/
├── core/                      
│   ├── constants/             
│   ├── network/                
│   ├── routing/                
│   └── theme/                  
├── features/                   
│   ├── products/               
│   │   ├── data/               
│   │   └── presentation/       
│   ├── favorites/              
│   │   ├── data/              
│   │   └── presentation/      
│   └── cart/                  
│       ├── data/               
│       └── presentation/       
└── main.dart         

---

## Technologies Used & Technical Decisions

* **Architectural Structure:** To ensure modularity and sustainability in the project, Feature-First approach was preferred.
* **State Management & DI:** Riverpod was chosen for state management and dependency injection needs.
* **API Client:** The Dio package, which provides advanced error handling and interceptor support for server requests, was integrated.
* **Routing:** GoRouter was used for page transitions and deep linking