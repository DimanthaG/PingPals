package com.pingpals.pingpals.Model;

import lombok.Data;

import java.util.List;

@Data
public class ChatMessage {
    private String content;
    private String senderId;
    private MessageType type;
    private List<String> participants;

    public enum MessageType {
        CHAT,
        JOIN,
        LEAVE
    }

    // Add getters and setters for all fields
}
