## KWANTA Print Organizer


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

* The KWANTA P.O. a.k.a Print Organizer app directly replaces a KOT printer. It receives KOTs via ESC/POS print commands, stores them in it’s internal SQLite DB and displays the received KOTs on the screen.
* It stores the ESC/POS sequence and forwards it to a physical printer whenever the user triggers the print. In a second phase it parses the received KOTs for quantity, item name, table, user etc. and stores this data in it’s DB. This data is then used to organise preparation of the items of the KOT.The main target is to have a plug-and-play solution to replace any ESC/POS compatible KOT printer connected to any POS system that sends KOTs.
* The KOT organizer app only exists as a local app on the device. It requires no serverside part.
* The main screen of the app is the KOT view screen. On this screen all incoming KOTs are displayed in the order of their receipt. The number of simultaneously displayed KOTs can be configured through app settings. By swiping the screen horizontally more KOTs can be displayed.
* KOTs are displayed with time of receipt and time passed since KOT receipt. By swiping a KOT up, the KOT is marked as done in the DB and the original ESC/POS sequence is sent to the physical printer if configured through settings. Once a KOT is done it disappears from the screen.

### Built With

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* [Floor Database](https://pub.dev/packages/floor)
* [GetX](https://pub.dev/packages/get)

This app is made with MVVM architecture using GetX library.

<!-- GETTING STARTED -->
## Getting Started

Please follow the instructions to setup the project on your local machine

### Prerequisites

* [Android Studio](https://developer.android.com/studio)
* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [Flutter/Dart Plugin for Android Studio]()

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/kwanta-kassa/print-organizer.git
   ```
2. Install NPM packages
   ```sh
   flutter pub get
   flutter pub upgrade
   ```
3. Run build runner command
   ```js
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```
4. Connect your device

5. Click on `Run (Shift+F10)` icon to compile the app on your device

<!-- USAGE EXAMPLES -->

## Usage

1. Install app on the required terminal
2. Go to Settings -> Config
3. Here, we need to define the printer IP address and port where we need to send the KOT for printing. We can also toggle whether to print the KOT as well as number of KOTs simultaneously displayed on the screen.
4. We also have a logger in Settings which can log all the application errors, that can also be shared through Message, Whatsapp, Teams, etc.
5. On the Configuration activity, we can also see the IP for the P.O. device which needs to be entered in KWANTA Kassa app printer settings to send the KOT to this app.
6. Once KOT is received, it is stored into the database in the app. The KOTInterpreter class will then interpret ESC/POS print commands and display it on the screen.
7. Once the KOT is dismissed by swiping up, a print is sent if flag set and the entry in the database is updated for dismissed.

<!-- LICENSE -->
## License

Copyright© of KWANTA Software Solutions Pvt. Ltd.
