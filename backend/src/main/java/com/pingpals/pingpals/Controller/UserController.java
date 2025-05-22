package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.UserRepository;
import com.pingpals.pingpals.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class UserController {

    @Autowired
    UserRepository userRepository;
    @Autowired
    UserService userService;

    @PostMapping("/addUser")
    public void addUser(@RequestBody User user) {
        user.setId(null);
        userRepository.save(user);
    }

    @GetMapping("/getUserById/{userId}")
    public User getUserById(@PathVariable String userId) {
        System.out.println(userId);
        return userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));
    }

    @GetMapping("/getAllUsers")
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // Secure this endpoint to allow only authenticated requests
    @GetMapping("/searchUsers")
    public List<User> searchUsers(@RequestParam String query, @RequestHeader("Authorization") String token) {
        // Token validation and decoding logic should be in JwtAuthenticationFilter or a utility class
        System.out.println("Searching for users with query: " + query);
        return userService.searchUsers(query);
    }

    @GetMapping("/friends")
    public List<User> getFriendsForUser() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return userService.getFriendsForUser(userId);
    }

    @DeleteMapping("/removeFriend/{friendId}")
    public void removeFriend(@PathVariable String friendId) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        userService.removeFriend(userId, friendId);
    }


}
