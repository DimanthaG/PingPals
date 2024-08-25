package com.pingpals.pingpals.Model;

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
public class Event {

    @Id
    private String id;

    // Creator's User Object ID
    private String creator;

    private String title;

    private String description;

    private LocationData location;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private Integer capacity;

    // To toggle ability to join
    private Boolean open;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LocationData {
        private String platform;
        private String link;
        private String details;

        public LocationData(String platform, String link) {
            this.platform = platform;
            this.link = link;
            this.details = null;  // Default to null if not provided
        }
    }
}