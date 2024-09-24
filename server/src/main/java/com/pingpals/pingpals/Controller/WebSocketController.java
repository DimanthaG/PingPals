package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.EventUser;
import com.pingpals.pingpals.Model.ChatMessage;
import com.pingpals.pingpals.Service.EventService;
import com.pingpals.pingpals.Service.EventUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class WebSocketController {

    @Autowired
    private EventService eventService;
    @Autowired
    private EventUserService eventUserService;
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/joinEvent/{eventId}")
    @SendTo("/topic/joinEvent/{eventId}")
    public List<String> joinEvent(@PathVariable String eventId) {
        eventUserService.joinEvent(eventId);
        List<EventUser> participants = eventUserService.getEventUsersForEvent(eventId);
        List<String> userIds = participants.stream()
                .map(EventUser::getUserId)
                .collect(Collectors.toList());

        return userIds;
    }

    @MessageMapping("/joinEvent/{eventId}")
    @SendTo("/topic/event/{eventId}")
    public ChatMessage joinEvent(@DestinationVariable String eventId, @Payload ChatMessage chatMessage,
                                 SimpMessageHeaderAccessor headerAccessor) {
        String userId = chatMessage.getSenderId();
        headerAccessor.getSessionAttributes().put("userId", userId);
        headerAccessor.getSessionAttributes().put("eventId", eventId);

        eventUserService.joinEvent(eventId, userId);
        List<EventUser> participants = eventUserService.getEventUsersForEvent(eventId);
        List<String> userIds = participants.stream()
                .map(EventUser::getUserId)
                .collect(Collectors.toList());

        chatMessage.setContent(userId + " joined the event");
        chatMessage.setType(ChatMessage.MessageType.JOIN);
        chatMessage.setParticipants(userIds);

        return chatMessage;
    }

    @MessageMapping("/leaveEvent/{eventId}")
    @SendTo("/topic/event/{eventId}")
    public ChatMessage leaveEvent(@DestinationVariable String eventId, @Payload ChatMessage chatMessage,
                                  SimpMessageHeaderAccessor headerAccessor) {
        String userId = chatMessage.getSenderId();
        headerAccessor.getSessionAttributes().remove("userId");
        headerAccessor.getSessionAttributes().remove("eventId");

        eventUserService.leaveEvent(eventId, userId);
        List<EventUser> participants = eventUserService.getEventUsersForEvent(eventId);
        List<String> userIds = participants.stream()
                .map(EventUser::getUserId)
                .collect(Collectors.toList());

        chatMessage.setContent(userId + " left the event");
        chatMessage.setType(ChatMessage.MessageType.LEAVE);
        chatMessage.setParticipants(userIds);

        return chatMessage;
    }

    @MessageMapping("/sendMessage/{eventId}")
    @SendTo("/topic/event/{eventId}")
    public ChatMessage sendMessage(@DestinationVariable String eventId, @Payload ChatMessage chatMessage) {
        chatMessage.setType(ChatMessage.MessageType.CHAT);
        return chatMessage;
    }

    public void handleWebSocketDisconnect(String eventId, String userId) {
        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSenderId(userId);
        chatMessage.setContent(userId + " left the event");
        chatMessage.setType(ChatMessage.MessageType.LEAVE);

        eventUserService.leaveEvent(eventId, userId);
        List<EventUser> participants = eventUserService.getEventUsersForEvent(eventId);
        List<String> userIds = participants.stream()
                .map(EventUser::getUserId)
                .collect(Collectors.toList());
        chatMessage.setParticipants(userIds);

        messagingTemplate.convertAndSend("/topic/event/" + eventId, chatMessage);
    }
    
}