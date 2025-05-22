package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.FriendRequest;
import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.UserRepository;
import com.pingpals.pingpals.Service.FriendRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/friendRequests")
public class FriendRequestController {

    @Autowired
    private FriendRequestService friendRequestService;

    @Autowired
    private UserRepository userRepository; // Inject UserRepository here

    @GetMapping("/pending")
    public List<Map<String, Object>> getPendingFriendRequestsForUser() {
        List<FriendRequest> friendRequests = friendRequestService.getPendingRequestsForUser();

        return friendRequests.stream().map(request -> {
            Map<String, Object> response = new HashMap<>();
            response.put("id", request.getId());
            response.put("status", request.getStatus());
            response.put("issuedTime", request.getIssuedTime());

            // Fetch sender details
            User sender = userRepository.findById(request.getSender())
                    .orElseThrow(() -> new RuntimeException("Sender not found for ID: " + request.getSender()));

            // Ensure name is added
            response.put("senderName", sender.getName());
            response.put("senderId", sender.getId()); // Optional but included for reference
            return response;
        }).collect(Collectors.toList());
    }


    @PostMapping("/create/{emailOrUsername}")
    public void createFriendRequest(@PathVariable String emailOrUsername) {
        try {
            System.out.println("Creating friend request for: " + emailOrUsername);
            friendRequestService.createFriendRequest(emailOrUsername);
            System.out.println("Friend request created successfully for: " + emailOrUsername);
        } catch (Exception e) {
            System.err.println("Error creating friend request: " + e.getMessage());
            throw e;
        }
    }

    @PostMapping("/accept/{friendRequestId}")
    public void acceptFriendRequest(@PathVariable String friendRequestId) {
        try {
            System.out.println("Processing friend request acceptance for ID: " + friendRequestId);
            friendRequestService.acceptFriendRequest(friendRequestId);
            System.out.println("Friend request successfully accepted: " + friendRequestId);
        } catch (Exception e) {
            System.err.println("Error accepting friend request: " + e.getMessage());
            throw new RuntimeException("Error accepting friend request: " + e.getMessage());
        }
    }

    @PostMapping("/decline/{friendRequestId}")
    public void declineFriendRequest(@PathVariable String friendRequestId) {
        friendRequestService.declineFriendRequest(friendRequestId);
        System.out.println("Friend request declined: " + friendRequestId);
    }
}
