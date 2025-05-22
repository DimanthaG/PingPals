package com.pingpals.pingpals.Config;

import com.pingpals.pingpals.Controller.WebSocketController;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

@Component
@RequiredArgsConstructor
@Slf4j
public class WebSocketEventListener {

    @Autowired
    private WebSocketController webSocketController;

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        SimpMessageHeaderAccessor headerAccessor = SimpMessageHeaderAccessor.wrap(event.getMessage());
        String userId = (String) headerAccessor.getSessionAttributes().get("userId");
        String eventId = (String) headerAccessor.getSessionAttributes().get("eventId");

        if (userId != null && eventId != null) {
            log.info("User Disconnected: " + userId);
            webSocketController.handleWebSocketDisconnect(eventId, userId);
        }
    }
}
