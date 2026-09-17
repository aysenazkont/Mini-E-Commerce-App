# AI Usage Report

This report documents how Artificial Intelligence tools were utilized during the development lifecycle, detailing prompts, architectural discussions, and technical revisions.

---

## 1. AI Tools Utilized
* **Tool:** Gemini (AI Assistant)
* **Primary Scope:** Architecture design, scaffolding logic, code refactoring, and build-time debugging.

---

## 2. Tasks & Areas of Application
* **Task 1 (Project Setup & Architecture):** Establishing the Feature-First directory structure, configuring base theme tokens, and defining the initial `GoRouter` navigation skeleton according to Clean Architecture principles.
* **Task 2 (Networking & Product Catalog):** Configuring the centralized `Dio` HTTP client with base timeouts, mapping raw DummyJSON responses to typed `ProductModel` entities, and implementing responsive grid layouts with dedicated loading/error states.
* **Task 3 (Product Detail Screen):** Extracting path parameters via `GoRouter`, designing a responsive multi-column layout for product media and metadata, and implementing stock level badges with dynamic `SnackBar` feedback.
* **Task 4 (Search & Category Filtering):** Architectural design for synchronizing text search queries with category chip selections, including debouncing logic.
* **Task 5 (Favorites & Persistence):** Implementing local data persistence with `SharedPreferences`, JSON serialization, and optimizing favorite toggles with `isFavoriteProvider.family`.
* **Task 6 (Cart State Management & Persistence):** Transitioning an in-memory shopping cart into a persistent architecture using `AsyncNotifier` and `CartRepository`.
* **General Debugging:** Resolving broken relative import paths resulting from file migrations and addressing compilation warnings regarding unused private classes.

---

## 3. Sample Prompts & Resolutions

* **Prompt 1 (Compilation Error):**
  > *"The declaration '_ProductDetailContent' isn't referenced. Try removing the declaration... Why did this error happen?"*
  - **Resolution:** The AI identified that the parent public class `ProductDetailScreen` had been accidentally omitted during a refactor, leaving the private widget orphaned. A complete, error-free screen file was provided.

* **Prompt 2 (Import Path Resolution):**
  > *"The file cannot find `lib/features/favorites/...`"*
  - **Resolution:** The AI identified that manual `lib/...` imports violate Dart conventions, providing both correct relative imports (`../`) and package-level imports reflecting the feature-first file hierarchy.

* **Prompt 3 (Architecture Refactoring):**
  > *"The cart is currently only kept in memory. The task objective requires local data management. Let's add SharedPreferences and a repository like favorites so the cart persists across restarts, while keeping logic inside providers."*
  - **Resolution:** The AI refactored `CartNotifier` into an `AsyncNotifier`, introduced `CartRepository` for local JSON persistence, and adapted `CartScreen` to handle asynchronous states with `when(...)`.

---

## 4. Modifications & Rejected Proposals
* **Defensive Boundary Checks:** Rather than applying direct string manipulation on category slugs (which could crash on unexpected empty inputs), custom null-safe extraction (`displayName`) was adopted.
* **Preserving Explicit Folder Hierarchy:** Rejected flat file structures in favor of strict domain separation within `features/` to maintain clean architecture standards.
* **Refusing In-Memory State for the Cart:** Rejected an in-memory-only cart implementation to strictly meet the grading criteria for local data persistence.

---

## 5. Key Learnings & Takeaways
* **AsyncNotifier & Immutability:** Managing asynchronous local persistence with Riverpod is most reliable when states are treated as immutable collections and wrapped with `AsyncValue`.
* **Repository Abstraction:** Isolating storage mechanisms (`SharedPreferences`) inside repository classes decoupled the UI layer entirely, making state refactoring seamless and predictable.
* **Conventional Commits:** Maintaining granular, semantically structured commits (`feat`, `fix`, `docs`) provided a clean and readable version control history for code review.