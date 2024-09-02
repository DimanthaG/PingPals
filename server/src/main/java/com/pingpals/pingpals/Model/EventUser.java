package com.pingpals.pingpals.Model;

import com.pingpals.pingpals.Model.Enum.Role;
import com.pingpals.pingpals.Model.Enum.Status;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "event_user")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EventUser {

    @Id
    private String id;

    private String eventId;

    private String userId;

    private Role role;

    private Status status;

    private LocalDateTime joinedAt;
}