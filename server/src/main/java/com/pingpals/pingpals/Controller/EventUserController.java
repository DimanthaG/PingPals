package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.Event;
import com.pingpals.pingpals.Model.EventUser;
import com.pingpals.pingpals.Repository.EventUserRepository;
import com.pingpals.pingpals.Service.EventService;
import com.pingpals.pingpals.Service.EventUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class EventUserController {

    @Autowired
    EventUserRepository eventUserRepository;
    @Autowired
    EventUserService eventUserService;

    @PostMapping("/addEventUser")
    public void addEventUser(@RequestBody EventUser eventUser) {
        // To let Mongo auto-generate an objectId
        eventUser.setId(null);
        eventUserRepository.save(eventUser);
    }

    @GetMapping("/getEventUserById/{eventUserId}")
    public EventUser getEventUserById(@PathVariable String eventUserId) {
        return eventUserService.getEventUserById(eventUserId);
    }

    @PutMapping("/updateEventUserById/{eventId}")
    public EventUser updateEventUserById(@PathVariable String eventUserId, @RequestBody EventUser updatedEventUserData) {
        return eventUserService.updateEventUserById(eventUserId, updatedEventUserData);
    }

    @DeleteMapping("/deleteEventUserById/{eventId}")
    public EventUser deleteEventUserById(@PathVariable String eventUserId) {
        return eventUserService.deleteEventUserById(eventUserId);
    }

    @PostMapping("/joinEvent/{eventUserId}")
    public EventUser joinEvent(@PathVariable String eventId) {
        return eventUserService.joinEvent(eventId);
    }

    @PostMapping("/cancelEvent/{eventId}")
    public EventUser cancelEventUserByEventId(@PathVariable String eventId) {
        return eventUserService.cancelEvent(eventId);
    }

    @GetMapping("/getEventUsersForEvent/{eventId}")
    public List<EventUser> getEventUsersForEvent(@PathVariable String eventId) {
        return eventUserService.getEventUsersForEvent(eventId);
    }

    @GetMapping("/getEventUsersForUser/{userId}")
    public List<EventUser> getEventUsersForUser(@PathVariable String userId) {
        return eventUserService.getEventUsersForUser(userId);
    }

}
