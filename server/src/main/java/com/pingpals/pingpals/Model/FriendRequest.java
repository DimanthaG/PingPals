package com.pingpals.pingpals.Model;

import com.pingpals.pingpals.Model.Enum.FriendRequestStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FriendRequest {

    @Id
    private String id;
    
    private String sender;

    private String receiver;

    private LocalDateTime issuedTime;

    private FriendRequestStatus status;

}