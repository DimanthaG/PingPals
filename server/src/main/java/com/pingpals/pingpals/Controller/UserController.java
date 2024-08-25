package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {

    @Autowired
    UserRepository userRepository;

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

}
