package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Service.NotificationService;
import com.pingpals.pingpals.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private UserService userService;

    @PostMapping("/token")
    public ResponseEntity<Void> updateFcmToken(@RequestBody FcmTokenRequest request) {
        String userId = userService.getAuthenticatedUserId();
        User user = userService.getUserById(userId);
        user.setFcmToken(request.getToken());
        userService.updateUser(user);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/test/{userId}")
    public ResponseEntity<Void> sendTestNotification(@PathVariable String userId) {
        notificationService.sendNotification(
            userId,
            "Test Notification",
            "This is a test notification",
            "TEST",
            "test_id"
        );
        return ResponseEntity.ok().build();
    }

    public static class FcmTokenRequest {
        private String token;

        public String getToken() {
            return token;
        }

        public void setToken(String token) {
            this.token = token;
        }
    }
}