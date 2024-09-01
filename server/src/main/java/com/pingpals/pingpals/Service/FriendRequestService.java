package com.pingpals.pingpals.Service;

import com.pingpals.pingpals.Model.Enum.FriendRequestStatus;
import com.pingpals.pingpals.Model.FriendRequest;
import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.FriendRequestRepository;
import com.pingpals.pingpals.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.ErrorResponseException;
import org.springframework.web.servlet.View;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class FriendRequestService {

    @Autowired
    private FriendRequestRepository friendRequestRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private View error;

    public void createFriendRequest(String username) {
        if (username == null || username.isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
        try {
            User receiver = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("Receiver not found"));
            friendRequestRepository.save(
                    new FriendRequest(
                            null,
                            "authenticated user",
                            receiver.getId(),
                            LocalDateTime.now(),
                            FriendRequestStatus.PENDING
                    )
            );
        } catch (Exception error) {
            throw error;
        }
    }

    public void acceptFriendRequest(String friendRequestId) {
        if (friendRequestId == null || friendRequestId.isEmpty()) {
            throw new IllegalArgumentException("FriendRequestId cannot be null or empty");
        }

        try {
            FriendRequest friendRequest = friendRequestRepository.findById(friendRequestId)
                    .orElseThrow(() -> new RuntimeException("Friend Request not found"));
            if (friendRequest.getStatus().equals(FriendRequestStatus.DECLINED)) {
                throw new Error("Friend Request Has Already Been Declined");
            }

            User sender = userRepository.findById(friendRequest.getSender())
                    .orElseThrow(() -> new RuntimeException("Sender not found"));
            User receiver = userRepository.findById(friendRequest.getReceiver())
                    .orElseThrow(() -> new RuntimeException("Receiver not found"));

            if (sender.getFriends() == null) sender.setFriends(new ArrayList<>());
            if (receiver.getFriends() == null) receiver.setFriends(new ArrayList<>());
            sender.getFriends().add(receiver.getId());
            receiver.getFriends().add(sender.getId());
            userRepository.save(sender);
            userRepository.save(receiver);

            friendRequest.setStatus(FriendRequestStatus.ACCEPTED);
            friendRequestRepository.save(friendRequest);

        } catch (Exception error) {
            throw error;
        }
    }

    public void declineFriendRequest(String friendRequestId) {
        if (friendRequestId == null || friendRequestId.isEmpty()) {
            throw new IllegalArgumentException("FriendRequestId cannot be null or empty");
        }

        try {
            FriendRequest friendRequest = friendRequestRepository.findById(friendRequestId).get();
            if (friendRequest.getStatus() != FriendRequestStatus.ACCEPTED) {
                friendRequest.setStatus(FriendRequestStatus.DECLINED);
                friendRequestRepository.save(friendRequest);
            } else throw new Error("Friend Request Has Already Been Accepted");
        } catch (Exception error) {
            throw error;
        }
    }

}