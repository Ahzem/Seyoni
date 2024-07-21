# Contributing to Seyoni

We appreciate your interest in contributing to Seyoni! Here are some guidelines to help you get started.

## Getting Started

1. **Fork the repository:**
   - Click the "Fork" button at the top right of the repository page.

2. **Clone your forked repository:**
   ```bash
   git clone https://github.com/<your-username>/Seyoni.git
   ```

3. **Create a new branch:**
   - Make sure to create a new branch for each feature or bugfix you work on.
   ```bash
   git checkout -b feature-name
   ```

## Folder Organization

To maintain a consistent structure, please follow the folder organization shown below:

```
lib
│───main.dart    
└───src
    │───pages
    |    │──SignInPage.dart
    |    │──SignUpPage.dart
    │───widgets
```

All images and icons should be saved in the `assets` folder at the root of the project:

```
assets
│───images
│───icons
```

## Making Changes

1. **Check Issues:**
   - Look at the issues in the main repository to find tasks that need to be addressed.

2. **Commit your changes:**
   - Write clear and concise commit messages.
   ```bash
   git commit -m "Description of changes"
   ```

3. **Push to your fork:**
   ```bash
   git push origin feature-name
   ```

4. **Create a Pull Request:**
   - Navigate to the main repository and create a pull request from your forked repository.
   - Ensure your pull request references the issue it addresses. Once your pull request is reviewed and merged, it will be assigned to that issue, and the issue will be closed.

## Development Workflow

1. **Run the application:**
   - Go to the `Rront-End` folder and run the Flutter command:
   ```bash
   flutter run
   ```

2. **Sync with the main repository:**
   - Use the "Sync fork" button in the GitHub UI to keep your fork in sync.
   - Alternatively, fetch and pull the changes using the command line:
   ```bash
   git fetch upstream
   git pull upstream main
   ```

3. **Use GitHub Discussions:**
   - Ensure all team members stay updated by using GitHub Discussions for any changes or updates.

## Code of Conduct

Please read and adhere to our [Code of Conduct](CODE_OF_CONDUCT.md) to ensure a welcoming and inclusive community.

Thank you for contributing to Seyoni!