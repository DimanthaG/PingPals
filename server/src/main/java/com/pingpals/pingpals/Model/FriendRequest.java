package com.pingpals.pingpals.Model;

import com.pingpals.pingpals.Model.Enum.FriendRequestStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "friend_requests")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FriendRequest {

    @Id
    private String id;

    private String sender;  // User ID of the sender
    private String receiver;  // User ID of the receiver

    private LocalDateTime issuedTime;
    private FriendRequestStatus status;


}
