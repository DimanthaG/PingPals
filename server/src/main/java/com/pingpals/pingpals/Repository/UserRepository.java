package com.pingpals.pingpals.Repository;

import com.pingpals.pingpals.Model.User;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface UserRepository extends MongoRepository<User, Integer> {
}
