package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.FriendRequest;
import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.FriendRequestRepository;
import com.pingpals.pingpals.Repository.UserRepository;
import com.pingpals.pingpals.Service.EventUserService;
import com.pingpals.pingpals.Service.FriendRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class FriendRequestController {

    @Autowired
    FriendRequestRepository friendRequestRepository;
    @Autowired
    FriendRequestService friendRequestService;

    @GetMapping("/getAllFriendRequests")
    public List<FriendRequest> getAllFriendRequests() {
        return friendRequestRepository.findAll();
    }

    @GetMapping("/getFriendRequestById/{id}")
    public FriendRequest getFriendRequestById(@PathVariable String id) {
        return friendRequestRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Friend Request with id " + id + " not found"));
    }

    @PostMapping("/createFriendRequest/{username}")
    public void createFriendRequest(@PathVariable String username) {
        friendRequestService.createFriendRequest(username);
    }

    @PostMapping("/acceptFriendRequest/{friendRequestId}")
    public void acceptFriendRequest(@PathVariable String friendRequestId) {
        friendRequestService.acceptFriendRequest(friendRequestId);
    }

    @PostMapping("/declineFriendRequest/{friendRequestId}")
    public void declineFriendRequest(@PathVariable String friendRequestId) {
        friendRequestService.declineFriendRequest(friendRequestId);
    }

}
