package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.Event;
import com.pingpals.pingpals.Repository.EventRepository;
import com.pingpals.pingpals.Service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class EventController {

    @Autowired
    EventRepository eventRepository;
    @Autowired
    EventService eventService;

    @PostMapping("/addEvent")
    public void addUser(@RequestBody Event event) {
        event.setId(null);
        eventRepository.save(event);
    }

    @GetMapping("/getEventById/{eventId}")
    public Event getEventById(@PathVariable String eventId) {
        return eventService.getEventById(eventId);
    }

    @PutMapping("/updateEventById/{eventId}")
    public Event updateEventById(@PathVariable String eventId, @RequestBody Event updatedEventData) {
        return eventService.updateEventById(eventId, updatedEventData);
    }

    @DeleteMapping("/deleteEventById/{eventId}")
    public Event deleteEventById(@PathVariable String eventId) {
        return eventService.deleteEventById(eventId);
    }

}
