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
    private NotificationService notificationService;

    // Get the authenticated user ID
    private String getAuthenticatedUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("User is not authenticated");
        }
        System.out.println("Authenticated user ID: " + authentication.getName());  // Log authenticated user ID
        return authentication.getName();  // Assumes the userId is the principal
    }

    // Get pending requests for the authenticated user
    public List<FriendRequest> getPendingRequestsForUser() {
        String userId = getAuthenticatedUserId();
        System.out.println("Fetching pending friend requests for user ID: " + userId);  // Log fetching process
        return friendRequestRepository.findByReceiverAndStatus(userId, FriendRequestStatus.PENDING);
    }

    public void createFriendRequest(String emailOrUsername) {
        User receiver = userRepository.findByEmail(emailOrUsername)
                .orElseThrow(() -> new RuntimeException("Receiver not found: " + emailOrUsername));
        String senderId = getAuthenticatedUserId();
        
        // Get sender details for notification
        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("Sender not found: " + senderId));

        Optional<FriendRequest> existingRequestOptional = friendRequestRepository.findBySenderAndReceiver(senderId, receiver.getId());
        if (((Optional<?>) existingRequestOptional).isPresent()) {
            FriendRequest existingRequest = existingRequestOptional.get();
            if (existingRequest.getStatus() == FriendRequestStatus.DECLINED) {
                // Update the declined request to PENDING
                existingRequest.setStatus(FriendRequestStatus.PENDING);
                existingRequest.setIssuedTime(LocalDateTime.now());
                friendRequestRepository.save(existingRequest);
                System.out.println("Friend request re-sent to user: " + receiver.getId());
                
                // Send notification for the re-sent request
                notificationService.sendFriendRequestNotification(receiver.getId(), sender.getName());
                return;
            } else {
                throw new RuntimeException("Friend request already sent to this user.");
            }
        }

        FriendRequest friendRequest = new FriendRequest(null, senderId, receiver.getId(), LocalDateTime.now(), FriendRequestStatus.PENDING);
        friendRequestRepository.save(friendRequest);
        System.out.println("Friend request created from sender ID: " + senderId + " to receiver ID: " + receiver.getId());
        
        // Send notification to receiver
        notificationService.sendFriendRequestNotification(receiver.getId(), sender.getName());
    }


    // Accept a friend request and add to both users' friend lists
    public List<User> acceptFriendRequest(String friendRequestId) {
        // Fetch the friend request
        FriendRequest friendRequest = friendRequestRepository.findById(friendRequestId)
                .orElseThrow(() -> new RuntimeException("Friend Request not found"));

        // Ensure the request hasn't been declined
        if (friendRequest.getStatus() == FriendRequestStatus.DECLINED) {
            throw new RuntimeException("Cannot accept a declined friend request.");
        }

        // Fetch sender and receiver users
        User sender = userRepository.findById(friendRequest.getSender())
                .orElseThrow(() -> new RuntimeException("Sender not found: " + friendRequest.getSender()));
        User receiver = userRepository.findById(friendRequest.getReceiver())
                .orElseThrow(() -> new RuntimeException("Receiver not found: " + friendRequest.getReceiver()));

        // Initialize friends list if null
        if (sender.getFriends() == null) {
            sender.setFriends(new ArrayList<>());
        }
        if (receiver.getFriends() == null) {
            receiver.setFriends(new ArrayList<>());
        }

        // Update friend lists
        if (!sender.getFriends().contains(receiver.getId())) {
            sender.getFriends().add(receiver.getId());
        }
        if (!receiver.getFriends().contains(sender.getId())) {
            receiver.getFriends().add(sender.getId());
        }

        userRepository.save(sender);
        userRepository.save(receiver);

        // Update friend request status
        friendRequest.setStatus(FriendRequestStatus.ACCEPTED);
        friendRequestRepository.delete(friendRequest); // Remove the friend request after acceptance

        System.out.println("Friend request accepted and removed: " + friendRequestId);
        
        // Send notification to the sender that their request was accepted
        notificationService.sendFriendRequestAcceptedNotification(sender.getId(), receiver.getName());

        // Return updated friend list for the receiver (authenticated user)
        return userRepository.findAllById(receiver.getFriends());
    }



    // Decline a friend request
    public void declineFriendRequest(String friendRequestId) {
        FriendRequest friendRequest = friendRequestRepository.findById(friendRequestId)
                .orElseThrow(() -> new RuntimeException("Friend Request not found"));

        if (friendRequest.getStatus() == FriendRequestStatus.ACCEPTED) {
            throw new RuntimeException("Friend request has already been accepted");
        }
        friendRequest.setStatus(FriendRequestStatus.DECLINED);
        friendRequestRepository.save(friendRequest);
        System.out.println("Friend request declined: " + friendRequestId);
    }
}
