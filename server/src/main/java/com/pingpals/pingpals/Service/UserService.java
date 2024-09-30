package com.pingpals.pingpals.Service;

import com.pingpals.pingpals.Model.User;
import com.pingpals.pingpals.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public void removeFriend(String userId, String friendId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        User friend = userRepository.findById(friendId)
                .orElseThrow(() -> new RuntimeException("Friend not found with id: " + friendId));

        if (user.getFriends() != null) {
            user.getFriends().remove(friendId);
        }

        if (friend.getFriends() != null) {
            friend.getFriends().remove(userId);
        }

        userRepository.save(user);
        userRepository.save(friend);
    }

}
