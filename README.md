# Reminds - Flutter Conversation App

![App Logo](images/favicon.png)

Reminds is a Flutter-based mobile application that generates random conversations and provides a platform for users to engage in meaningful discussions. The app features email-based authentication, multimedia message support, and an intuitive user interface.

## Features

- **Secure Authentication**: Email-based token authentication system
- **Conversation Generation**: Randomly generated conversation threads
- **Multimedia Support**:
  - Text messages
  - Image sharing with preview
  - Audio messages with playback
- **Search & Filter**:
  - Search through conversation history
  - Sort messages by timestamp
- **User Profiles**:
  - Custom avatars
  - Participant information
- **Theming**:
  - Light, dark, and system theme modes
- **Responsive Design**: Optimized for mobile devices

## Installation

You can install Reminds either by building from source or downloading pre-built packages:

### Option 1: Build from Source

#### Prerequisites
- Flutter SDK (version 3.6.0 or higher)
- Dart SDK
- Android Studio/Xcode (for mobile development)

#### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/predator229/reminds.git
   ```
2. Navigate to project directory:
   ```bash
   cd reminds
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Option 2: Download Pre-built Packages
Visit our [download page](https://reminds.app) to get the latest stable builds for:
- Android (.apk)
- iOS (.ipa)
- Windows (.exe)
- macOS (.dmg)

## Configuration

### Environment Variables
Create a `.env` file in the root directory with the following variables:
```
API_BASE_URL=your_api_url_here
```

### Assets
Place your custom assets in the `images/` directory:
- `favicon.png` - App logo
- `default_user.png` - Default user avatar
- Custom profile pictures

## Usage

1. Launch the app
2. Enter your email to request an authentication token
3. Check your email for the token and enter it in the app
4. Start exploring random conversations
5. Use the search and sort features to navigate messages
6. Share images and audio messages

## Dependencies

- **http**: For API communication
- **just_audio**: Audio message playback
- **fluttertoast**: User notifications
- **path_provider**: File system access
- **flutter_launcher_icons**: App icon generation

## Project Structure

```
lib/
├── controllers/        # Business logic and API controllers
├── models/             # Data models and entities
├── views/              # UI components and screens
├── main.dart           # Application entry point
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Damien Padonou  
GitHub: [predator229](https://github.com/predator229)  
Email: plaisantin229@gmail.com
