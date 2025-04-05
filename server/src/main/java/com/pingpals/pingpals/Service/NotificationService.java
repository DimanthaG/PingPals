package com.pingpals.pingpals.Service;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {
    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    @Autowired
    private FirebaseMessaging firebaseMessaging;

    @Autowired
    private UserRepository userRepository;

    // Changed from private to public so it can be called from NotificationController
    public void sendNotification(String userId, String title, String body, String type, String entityId) {
        logger.info("Attempting to send notification to user: {}", userId);
        logger.info("Notification details - Title: {}, Body: {}, Type: {}, EntityId: {}", title, body, type, entityId);
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));

        if (user.getFcmToken() == null) {
            logger.warn("User {} has no FCM token registered", userId);
            return;
        }

        logger.info("Found FCM token for user {}: {}", userId, user.getFcmToken());

        Message message = Message.builder()
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .build())
                .putData("type", type)
                .putData("entityId", entityId)
                .setToken(user.getFcmToken())
                .build();

        try {
            String response = firebaseMessaging.send(message);
            logger.info("Successfully sent notification to user {}, Firebase response: {}", userId, response);
        } catch (Exception e) {
            logger.error("Failed to send notification to user {}: {}", userId, e.getMessage());
            logger.error("Notification error details:", e);
        }
    }

    public void sendFriendRequestNotification(String receiverId, String senderName) {
        logger.info("Sending friend request notification - Receiver: {}, Sender: {}", receiverId, senderName);
        sendNotification(
            receiverId,
            "New Friend Request",
            senderName + " sent you a friend request",
            "FRIEND_REQUEST",
            senderName
        );
    }

    public void sendFriendRequestAcceptedNotification(String senderId, String receiverName) {
        logger.info("Sending friend request accepted notification - Sender: {}, Receiver: {}", senderId, receiverName);
        sendNotification(
            senderId,
            "Friend Request Accepted",
            receiverName + " accepted your friend request",
            "FRIEND_ACCEPT",
            receiverName
        );
    }

    public void sendEventInviteNotification(String userId, String inviterName, String eventId, String eventTitle) {
        logger.info("Sending event invite notification - User: {}, Inviter: {}, Event: {}", userId, inviterName, eventId);
        sendNotification(
            userId,
            "Event Invitation",
            inviterName + " invited you to " + eventTitle,
            "EVENT_INVITE",
            eventId
        );
    }

    public void sendEventUpdateNotification(String userId, String eventId, String eventTitle) {
        logger.info("Sending event update notification - User: {}, Event: {}", userId, eventId);
        sendNotification(
            userId,
            "Event Updated",
            eventTitle + " has been updated",
            "EVENT_UPDATE",
            eventId
        );
    }
}