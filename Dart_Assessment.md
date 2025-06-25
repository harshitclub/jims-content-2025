### Objective:

Build a **command-line Dart app** that fetches user data from an API and performs different operations based on user input using variables, lists, maps, conditionals, async/await, and switch-case.

### Problem Statement:

Create a Dart CLI app named: **UserManagerApp**

### Features to implement:

1. **Fetch users from API:**
    - Use this API: `https://jsonplaceholder.typicode.com/users`
    - Fetch all users using `http` package and store the result in a `List<Map<String, dynamic>>`.
2. **Show a Menu to User (Switch Case):**
    - Display the following options in the terminal:
        
        ```dart
        ==== User Manager Menu ====
        1. Show all usernames
        2. Show details of a user by ID
        3. Filter users by city
        4. Exit
        Enter your choice:
        ```
        
3. **Handle Options:**
    - **Option 1:** Show all usernames using a loop from the API data.
    - **Option 2:** Ask user to input an ID, and then show full details like name, username, email, city, company.
        - Use conditionals to check if the ID is valid.
    - **Option 3:** Ask for a city name and filter users from that city (use `.where` with map).
    - **Option 4:** Exit program with a goodbye message.
4. **Variables & Conditionals:**
    - Use meaningful variable names.
    - Use conditionals to check user input validity.
5. **Async/Await:**
    - Use `async/await` to fetch and process data from the API.
6. **List and Map Usage:**
    - Store and manipulate API data using Lists and Maps.

---

### Folder Structure (Recommended):

```dart
user_manager_app/
├── bin/
│   └── main.dart
├── pubspec.yaml
```

---

### 📦 Packages Required:

Add this in `pubspec.yaml`:

```yaml
dependencies:
  http: ^0.13.0
```

---

### Submission Instructions:

- Create a GitHub repository named `dart-user-manager`.
- Push your code to GitHub with proper README.
- README must include:
    - Features implemented.
    - How to run the project.
    - Sample screenshot of the terminal output (optional but good).
- Share the GitHub repository link.

---

### Bonus Points:

- Add error handling (try-catch for API).
- Allow the user to repeat the menu until they choose to exit.
- Format output nicely using padding or borders.