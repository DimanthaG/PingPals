package com.pingpals.pingpals.Model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Document(collection = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    private String id;

    private String name;
    private String email;
    private String googleId;
    private String pictureUrl;

    // Ensure friends list is initialized
    private List<String> friends = new ArrayList<>();
}
