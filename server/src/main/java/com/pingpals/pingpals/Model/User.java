package com.pingpals.pingpals.Model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    private String id;

    // Unique identifier from Google
    @Indexed(unique = true)
    private String googleId;

    private String email;
    private String name;
    private String pictureUrl;

    private List<String> friends;
}
