package com.pingpals.pingpals.Repository;

import com.pingpals.pingpals.Model.Event;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface EventRepository extends MongoRepository<Event, String> {
}
