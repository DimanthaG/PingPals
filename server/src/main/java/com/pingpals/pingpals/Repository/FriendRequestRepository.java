package com.pingpals.pingpals.Repository;

import com.pingpals.pingpals.Model.FriendRequest;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface FriendRequestRepository extends MongoRepository<FriendRequest, String> {
}
