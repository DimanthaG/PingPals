package com.pingpals.pingpals.Service;

import com.pingpals.pingpals.Model.Enum.Role;
import com.pingpals.pingpals.Model.Enum.Status;
import com.pingpals.pingpals.Model.Event;
import com.pingpals.pingpals.Model.EventUser;
import com.pingpals.pingpals.Repository.EventRepository;
import com.pingpals.pingpals.Repository.EventUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class EventService {

    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private EventUserRepository eventUserRepository;

    @Autowired
    private EventUserService eventUserService;

    // Fetch an event by its ID
    public Event getEventById(String eventId) {
        return eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));
    }

    // Create a new event
    public Event createEvent(Event event) {
        // Save the event in the repository
        eventRepository.save(event);

        // Create an EventUser entry for the event creator
        EventUser eventUser = new EventUser(null, event.getId(), event.getCreator(), Role.CREATOR, Status.ACCEPTED, LocalDateTime.now());
        eventUserService.createEventUser(eventUser);

        return event;
    }

    // Update an existing event
    public Event updateEventById(String eventId, Event updatedEventData) {
        // Retrieve the existing event from the database
        Event existingEvent = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));

        // Update only the fields that are provided in the request
        if (updatedEventData.getTitle() != null) existingEvent.setTitle(updatedEventData.getTitle());
        if (updatedEventData.getDescription() != null) existingEvent.setDescription(updatedEventData.getDescription());
        if (updatedEventData.getStartTime() != null) existingEvent.setStartTime(updatedEventData.getStartTime());
        if (updatedEventData.getEndTime() != null) existingEvent.setEndTime(updatedEventData.getEndTime());
        if (updatedEventData.getLocation() != null) existingEvent.setLocation(updatedEventData.getLocation());

        // Save the updated event back to the repository
        return eventRepository.save(existingEvent);
    }

    // Delete an event by its ID
    public Event deleteEventById(String eventId) {
        // Fetch the event to be deleted
        Event existingEvent = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));

        // Delete the event
        eventRepository.delete(existingEvent);
        return existingEvent;
    }
}
