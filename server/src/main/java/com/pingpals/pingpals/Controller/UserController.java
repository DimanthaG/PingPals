package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    @Autowired
    UserRepository userRepository;

    @PostMapping("/addUser")
    public void addUser(@RequestBody User user) {
        userRepository.save(user);
    }

}
