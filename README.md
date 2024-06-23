# Time Tracking App (Task Flow)

This document outlines the functionalities implemented in the app and the rules and best practices followed during development.

## Functionalities Implemented

1. **Kanban Board for Tasks**
   - Users can create, edit, and move tasks between different columns ("To Do", "In Progress", "Done").
   - Tasks can be dragged and dropped between columns.

2. **Timer Function**
   - Users can start and stop tracking the time spent on each task.
   - Timer displays the total time spent on a task.

3. **History of Completed Tasks**
   - Displays the time spent on each task and the date it was completed.
   - Completed tasks are archived and can be viewed in a separate history section.

4. **Task Comments**
   - Users can add, edit, and view comments on each task.
   - Comments are displayed in a list under each task.

## Best Practices Followed

1. **DRY (Don't Repeat Yourself)**
   - Common functionality and UI components are reused across the app.
   - Helper functions and widgets are created to avoid code duplication.

2. **KISS (Keep It Simple, Stupid)**
   - The app design and functionality are kept simple and intuitive.
   - Complex logic is broken down into smaller, manageable pieces.

3. **SOLID Principles**
   - **Single Responsibility**: Each class and widget has a single responsibility.
   - **Open-Closed**: The app is designed to be easily extendable without modifying existing code.
   - **Liskov Substitution**: Subclasses and derived classes are used appropriately without altering the behavior of the base classes.
   - **Interface Segregation**: Interfaces are designed to be small and specific to avoid implementing unnecessary methods.
   - **Dependency Inversion**: High-level modules do not depend on low-level modules; both depend on abstractions.

4. **MVP (Minimum Viable Product) Principle**
   - The app includes essential features to meet the requirements and provides a foundation for future enhancements.
   - Features are iteratively added based on user feedback.

5. **User-Centered Design**
   - The app is designed with the user's needs, goals, and preferences in mind.
   - Ensures the app is easy to use, visually appealing, and accessible.

6. **Performance Optimization**
   - The app is optimized for performance, including fast loading times, smooth scrolling, and minimal memory and battery usage.
   - Asynchronous operations and efficient state management are utilized.

7. **Code Readability and Maintainability**
   - The code is well-organized, easy to read, and follows naming conventions.
   - Comprehensive comments and documentation are provided for better understanding and maintainability.

8. **Test-Driven Development (TDD)**
   - Tests are written before implementing features to catch and fix bugs early.
   - Unit tests and widget tests ensure the reliability and robustness of the code.

9. **Continuous Integration and Continuous Deployment (CI/CD)**
   - Automated building, testing, and deployment of code changes are implemented.
   - Ensures faster development cycles and more frequent updates.

## Anti-Patterns Avoided

1. **Not Following Best Practices**
   - Ensured adherence to DRY, KISS, and SOLID principles.

2. **Not Considering User Needs**
   - Focused on user-centered design to create an intuitive and user-friendly app.

3. **Insufficient Testing**
   - Implemented comprehensive testing to ensure the app is free from critical bugs and issues.

4. **Ignoring Performance Optimization**
   - Paid attention to performance optimization to ensure smooth user experience.

5. **Over-Engineering**
   - Avoided over-engineering by following the MVP principle and keeping the app simple and functional.

6. **Not Following Design Standards**
   - Ensured the app adheres to platform design standards for a consistent look and feel.

## Bonus Features

1. **Analytics**
   - Implemented basic analytics to track user interactions and identify areas for improvement.

2. **Notifications**
   - Added push notifications to remind users of upcoming tasks and task completions.

3. **Customizable Themes**
   - Users can choose from a selection of pre-defined color schemes to customize the app's look and feel.

4. **Integration with Third-Party Tools**
   - Integrated with other productivity tools such as calendars and task managers.

5. **Offline Functionality**
   - The app works offline and synchronizes data when reconnected.

6. **Multi-Language Support**
   - Added support for different languages to make the app accessible to a global audience.

## How to Run the App

1. **Clone the Repository**
   ```sh
   git clone https://github.com/Haraprosad/task_flow.git
  
