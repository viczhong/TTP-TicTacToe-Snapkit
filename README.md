# TTP-TicTacToe Code Challenge in iOS
## Setup

To run this app:
1. Clone or download the files in this repo.
2. Run `pod install` in terminal in the local `TTP-TicTacToe` directory to download and install Snapkit.
3. After `TTP-TicTacToe.xcworkspace` is generated, open it in Xcode and build/run it.

## The App

Each player takes a turn placing their mark onto a square in the grid. Match 3 in a row, column, or diagonal to win.

Initial View | Playing | Winning
--- | --- | ---
![Initial View](https://github.com/viczhong/TTP-TicTacToe/blob/master/screenshots/screen1.png "Initial View") | ![Playing](https://github.com/viczhong/TTP-TicTacToe/blob/master/screenshots/screen2.png "Playing") | ![Winning](https://github.com/viczhong/TTP-TicTacToe/blob/master/screenshots/screen31.png "Winning")

## The Method

After every player move, the code sets the coordinates of the mark into a matrix array to keep track of the grid state. It then checks every row, column, and diagonal to see if there is a three-way match. If there is, it announces the winner.
