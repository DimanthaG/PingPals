package com.pingpals.pingpals.Repository;

import com.pingpals.pingpals.Model.EventUser;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface EventUserRepository extends MongoRepository<EventUser, String> {
    List<EventUser> findByEventId(String eventId);
    List<EventUser> findByUserId(String userId);
    Optional<EventUser> findByEventIdAndUserId(String eventId, String userId);
}
