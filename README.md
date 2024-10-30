# Car Guessing Game 🚗

This Flutter-based game lets players guess a car model within 10 attempts, using hints and clues to narrow down the options. Each attempt brings the player closer to the answer, creating an engaging guessing game.

## 🚙 Key Features

- **Search & Filter**: Use a search bar to filter car models and brands.
- **Hints & Feedback**: Each guess provides color-coded hints, along with directional arrows for numeric values.
- **Win & Game Over States**: The player wins if they guess correctly within 10 tries or loses if all attempts are used up.

## 📂 Project Structure

- `GamePage`: Manages the game interface, search bar, and gameplay logic.
- `GameService`: Handles the loading and initialization of car data.
- `Car`: A data model representing car details, including brand, model, seats, doors, and acceleration.

> **Note**: Currently, `GameService` and `GamePage` need to be reimplemented to use the `Car` model directly.

## 🚀 Getting Started

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/username/repo-name.git
    cd repo-name
    ```
   
2. **Install Dependencies**:
    Ensure Flutter is installed, then run:
    ```bash
    flutter pub get
    ```

3. **Run the App**:
    ```bash
    flutter run
    ```

## 🎮 How to Play

1. **Start the Game**: The app loads car data and begins a new game.
2. **Search & Guess**: Type part of a car brand or model into the search bar, then select a car from the list to make a guess.
3. **Use Hints**: Each guess provides hints (color-coded) and directional arrows to guide your next move.
4. **Win or Lose**: Guess the correct car within 10 attempts to win, or use all attempts to lose.

## 📘 Documentation

For details on the code, refer to the comments in each function and class.

## 🚀 Future Improvements

Potential enhancements:

- **Detailed Hints**: Include hints based on more car attributes.
- **Difficulty Levels**: Adjust the number of attempts based on difficulty.
- **Score History**: Track previous games or implement a leaderboard.

## 🤲 Contributing

Contributions are welcome! Fork the project, create a branch, and submit a pull request.

---
