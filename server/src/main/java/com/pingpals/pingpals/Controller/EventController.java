package com.pingpals.pingpals.Controller;

import com.pingpals.pingpals.Model.Event;
import com.pingpals.pingpals.Repository.EventRepository;
import com.pingpals.pingpals.Service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class EventController {

    @Autowired
    EventRepository eventRepository;
    @Autowired
    EventService eventService;

    @PostMapping("/addEvent")
    public ResponseEntity<Event> addEvent(@RequestBody Event event) {
        // Set the event creator as part of the Event object itself
        if (event.getCreator() == null || event.getCreator().isEmpty()) {
            return ResponseEntity.badRequest().body(null);  // Ensure the creator is provided
        }

        event.setId(null); // MongoDB will generate the ID

        Event savedEvent = eventRepository.save(event);
        return ResponseEntity.ok(savedEvent);
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
