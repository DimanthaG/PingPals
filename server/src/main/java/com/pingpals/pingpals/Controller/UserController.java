package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.UserRepository;
import com.pingpals.pingpals.Service.FriendRequestService;
import com.pingpals.pingpals.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
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

    @GetMapping("/removeFriend/{friendUsername}")
    public void removeFriend(@PathVariable String friendUsername) {
        //TODO: Replace User with Authenticated Current User
        userService.removeFriend("userId", friendUsername);
    }

}
