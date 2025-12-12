import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2D5F3F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              children: [
                Text(
                  'Chats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF9BB8A3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Search Conversations...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Chat List
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                ChatTile(
                  name: 'Kebun Nenas Johor',
                  message: 'Hello, your parcel will last hong chap...',
                  time: 'Monday',
                  icon: Icons.person,
                  iconColor: Colors.orange,
                ),
                SizedBox(height: 10),
                ChatTile(
                  name: 'Ahmad_99',
                  message: 'You has received an image',
                  time: 'Monday',
                  icon: Icons.person,
                  iconColor: Colors.red,
                ),
                SizedBox(height: 10),
                ChatTile(
                  name: 'Chee Hua Wholesaler Perlis',
                  message: 'Hi this is an automated message...',
                  time: '10:02',
                  icon: Icons.person,
                  iconColor: Colors.purple,
                ),
                SizedBox(height: 10),
                ChatTile(
                  name: 'Maria_TartNenas',
                  message: 'Parcel delivered! Enjoy your tarte',
                  time: '09:01',
                  icon: Icons.person,
                  iconColor: Colors.pink,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to message details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetailScreen(
              name: name,
              icon: icon,
              iconColor: iconColor,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF9BB8A3),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            // Profile Icon
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
            ),
            SizedBox(width: 15),
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Color(0xFF2D5F3F),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    message,
                    style: TextStyle(
                      color: Color(0xFF2D5F3F),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Time
            Text(
              time,
              style: TextStyle(
                color: Color(0xFF2D5F3F),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Message Detail Screen
class MessageDetailScreen extends StatefulWidget {
  final String name;
  final IconData icon;
  final Color iconColor;

  const MessageDetailScreen({
    super.key,
    required this.name,
    required this.icon,
    required this.iconColor,
  });

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! How can I help you today?',
      'isSender': false,
      'time': '10:00 AM',
    },
    {
      'text': 'Hi! I would like to know about your pineapple products.',
      'isSender': true,
      'time': '10:02 AM',
    },
    {
      'text': 'Sure! We have fresh pineapples, pineapple juice, and canned pineapples available.',
      'isSender': false,
      'time': '10:03 AM',
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isSender': true,
          'time': TimeOfDay.now().format(context),
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D5F3F),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: 22,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.name,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  message['text'],
                  message['isSender'],
                  message['time'],
                );
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF2D5F3F),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isSender, String time) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender)
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: 18,
              ),
            ),
          if (!isSender) SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSender ? Color(0xFF2D5F3F) : Color(0xFF9BB8A3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isSender ? Colors.white : Color(0xFF2D5F3F),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: isSender ? Colors.white70 : Color(0xFF2D5F3F),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isSender) SizedBox(width: 8),
          if (isSender)
            CircleAvatar(
              backgroundColor: Color(0xFF2D5F3F),
              radius: 16,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}