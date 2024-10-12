import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import '../../../constants/constants_color.dart'; // Ensure this import is correct
import '../../../constants/constants_font.dart'; // Import the constants_font.dart file

// Color definitions
const Color black = Color(0xFF191919);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController msgInputController = TextEditingController();
  List<Message> messages = []; // List to hold chat messages
  int _selectedIndex = 0;

  // Simulated user for incoming messages
  final String otherUserProfilePic = 'assets/images/profile-7.jpg';

  void sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      setState(() {
        messages.add(Message(
          content: message,
          sentByMe: true,
          timestamp:
              DateTime.now(), // Capture current time when sending the message
          profilePic:
              'assets/images/profile-6.jpg', // Path to the sender's profile picture
        ));
      });
    }
  }

  // Simulate receiving a message from another user
  void receiveMessage(String message) {
    setState(() {
      messages.add(Message(
        content: message,
        sentByMe: false,
        timestamp: DateTime.now(),
        profilePic:
            otherUserProfilePic, // Path to the other user's profile picture
      ));
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              children: messages.map((message) {
                return MessageItem(
                  message: message, // Pass the message object
                );
              }).toList(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor:
                          kPrimaryColor, // Change cursor color to kPrimaryColor
                      controller: msgInputController,
                      decoration: InputDecoration(
                        hintText: "Type your message...", // Placeholder text
                        hintStyle: kBodyTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kPrimaryColor),
                          borderRadius:
                              BorderRadius.circular(30), // Round corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(
                              30), // Round corners on focus
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(
                          30), // Edge round for the input area
                    ),
                    child: IconButton(
                      onPressed: () {
                        sendMessage(msgInputController.text);
                        msgInputController
                            .clear(); // Clears the text input after sending

                        // Simulate receiving a message after sending
                        Future.delayed(const Duration(seconds: 2), () {
                          receiveMessage("Hello! This is an incoming message.");
                        });
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Message class to hold message content, sender info, and timestamp
class Message {
  final String content;
  final bool sentByMe;
  final DateTime timestamp;
  final String profilePic; // New field for the profile picture

  Message({
    required this.content,
    required this.sentByMe,
    required this.timestamp,
    required this.profilePic, // Include profilePic in the constructor
  });
}

// MessageItem widget to display each message
class MessageItem extends StatelessWidget {
  final Message message; // Accepting Message object

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        DateFormat.jm().format(message.timestamp); // Format the time

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            message.sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message
              .sentByMe) // Display profile picture for received messages
            CircleAvatar(
              backgroundImage: AssetImage(message.profilePic),
              radius: 15,
            ),
          if (!message.sentByMe)
            const SizedBox(width: 8), // Space between avatar and message bubble
          Expanded(
            child: Column(
              crossAxisAlignment: message.sentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: message.sentByMe
                        ? kPrimaryColor
                        : Colors.grey[
                            800], // kPrimaryColor for sent messages, dark grey for received
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.content, // Display the message
                    style: const TextStyle(
                        color: Colors
                            .white), // Black text for contrast on kPrimaryColor
                  ),
                ),
                const SizedBox(
                    height: 4), // Space between message and timestamp
                Text(
                  formattedTime, // Display the formatted time
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          if (message.sentByMe)
            const SizedBox(width: 8), // Space between message bubble and avatar
          if (message.sentByMe) // Display profile picture for sent messages
            CircleAvatar(
              backgroundImage: AssetImage(message.profilePic),
              radius: 15,
            ),
        ],
      ),
    );
  }
}
