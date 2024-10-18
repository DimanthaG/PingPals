package com.pingpals.pingpals.Service;

import com.pingpals.pingpals.Model.Enum.FriendRequestStatus;
import com.pingpals.pingpals.Model.FriendRequest;
import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.FriendRequestRepository;
import com.pingpals.pingpals.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import java.time.LocalDateTime;
import java.util.ArrayList;

@Service
public class FriendRequestService {

    @Autowired
    private FriendRequestRepository friendRequestRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private View error;

    public void createFriendRequest(String email) {
        if (email == null || email.isEmpty()) {
            throw new IllegalArgumentException("Email cannot be null or empty");
        }
        try {
            User receiver = userRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("Receiver not found"));

            // Get the authenticated user's ID
            String authenticatedUserId = getAuthenticatedUserId();

            friendRequestRepository.save(
                    new FriendRequest(
                            null,
                            authenticatedUserId,
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

    private String getAuthenticatedUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("User is not authenticated");
        }
        String userId = authentication.getName(); // The user ID is set as the principal
        return userId;
    }

}