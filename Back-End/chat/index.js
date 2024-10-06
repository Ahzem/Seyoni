const express = require('express');
const http = require('http');
const cors = require('cors');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);

app.use(cors()); // Allows Flutter to connect to the server

// Initialize socket.io for real-time communication
const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

// Store messages temporarily in memory
const messages = [];

// When a user connects to the server
io.on('connection', (socket) => {
  console.log('A user connected: ', socket.id);

  // Send existing messages to the newly connected user
  socket.emit('loadMessages', messages);

  // When a new message is sent from the Flutter app
  socket.on('sendMessage', (data) => {
    const message = {
      content: data.content,
      sentByMe: data.sentByMe,
      timestamp: new Date(),
      profilePic: data.profilePic,
    };

    messages.push(message); // Add message to the list
    io.emit('receiveMessage', message); // Send message to all connected users
  });

  // When a user disconnects
  socket.on('disconnect', () => {
    console.log('A user disconnected');
  });
});

const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
