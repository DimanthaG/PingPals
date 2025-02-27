package com.pingpals.pingpals.Repository;

import com.pingpals.pingpals.Model.Enum.FriendRequestStatus;
import com.pingpals.pingpals.Model.FriendRequest;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface FriendRequestRepository extends MongoRepository<FriendRequest, String> {

    List<FriendRequest> findByReceiverAndStatus(String receiverId, FriendRequestStatus status);

    boolean existsBySenderAndReceiver(String senderId, String receiverId);

    Optional<FriendRequest> findBySenderAndReceiver(String senderId, String receiverId);

}
