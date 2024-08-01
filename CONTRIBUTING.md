# Contributing to SEYONI - Home Services Management System

Thank you for considering contributing to our project! Please follow the guidelines below to ensure a smooth and effective collaboration.

## How to Contribute

### 1. Fork the Repository
First, fork the repository to your own GitHub account:
1. Go to the repository [SEYONI - Home Services Management System](https://github.com/Ahzem/Seyoni.git).
2. Click the **Fork** button at the top right of the page or start contributing now by clicking the button below:

[![start-course](https://md-buttons.francoisvoron.com/button.svg?text=Fork%20Now)](https://github.com/Ahzem/Seyoni/fork)


### 2. Clone the Forked Repository
Clone the forked repository to your local machine:
```bash
git clone https://github.com/<your-username>/Seyoni.git
cd Seyoni
```

### 3. Set Up the Front-End
Navigate to the Front-End directory and set up the Flutter project:
```bash
cd Front-End
flutter pub get
flutter run
```

### 4. Directory Structure
Follow the directory organization management:
```
lib
│───main.dart    
└───src
    │───config
    |    │──route.dart
    │───constants
    |    │──constants_color.dart
    |    │──constants_font.dart
    │───pages
    |    │──sign-pages
    |    |     │──components
    |    |     │──signin_page.dart
    |    |     │──signup_page.dart
    |    │──main
    |    |     │──components
    |    |     │──mainpage.dart
    |    │──entry-pages
    |    |     │──components
    |    |     │──instruction_page.dart
    |    |     │──launch_screen.dart
    │───widgets
    |    │──customNavBar
    |    │──background_widget.dart
    |    │──custom_app.dart
    |    │──route.dart
```

### 5. Make Changes
1. **Add New Pages**: Use the `pages` directory.
2. **Common Use Templates**: Use the `widgets` directory.
3. **Routing**: Set up routes in `src/config/route.dart`.
4. **Background Image**: Ensure every page uses `background_widget.dart`.
5. **Custom Buttons**: Use `custom_button` for adding any buttons.
6. **Styles**: Add any colors or text styles in the `constants` directory.
7. **Assets**: Use the `assets` directory for adding images or icons.

### 6. Sync with the Main Repository
1. **Watch the Repository**: Click the **Watch** button on the main repository to get updates.
2. **Sync Your Fork**: Fetch and pull updates from the main repository:
```bash
git fetch upstream
git pull upstream main
```

### 7. Commit and Push Changes
1. **Track Changes**:
```bash
git add .
```
2. **Commit Changes**:
```bash
git commit -m "Your detailed description of the changes."
```
3. **Push Changes**:
```bash
git push origin main
```

### 8. Create a Pull Request
1. Go to your forked repository on GitHub.
2. Click the **New pull request** button.
3. Provide a detailed description of the changes you made.
4. Submit the pull request for review.

### 9. Back-End Setup
1. **Navigate to Back-End Directory**:
```bash
cd Back-End
```
2. **Install Dependencies**:
```bash
npm install
```

---

Thank you for your contributions!
