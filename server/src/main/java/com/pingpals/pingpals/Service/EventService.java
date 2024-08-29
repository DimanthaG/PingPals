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

    public Event getEventById(String eventId) {
        return eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));
    }

    public Event createEvent(Event event) {
        eventRepository.save(event);

        // Change the "creatorUserId" with the User that calls this endpoint.
        EventUser eventUser = new EventUser(null, event.getId(), "creatorUserId", Role.CREATOR, Status.ACCEPTED, LocalDateTime.now());
        eventUserService.createEventUser(eventUser);

        return event;
    }

    public Event updateEventById(String eventId, Event updatedEventData) {
        Event existingEvent = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));

        // Allows partial updates
        if (updatedEventData.getTitle() != null) existingEvent.setTitle(updatedEventData.getTitle());
        if (updatedEventData.getDescription() != null) existingEvent.setDescription(updatedEventData.getDescription());
        if (updatedEventData.getStartTime() != null) existingEvent.setStartTime(updatedEventData.getStartTime());
        if (updatedEventData.getEndTime() != null) existingEvent.setEndTime(updatedEventData.getEndTime());
        if (updatedEventData.getLocation() != null) existingEvent.setLocation(updatedEventData.getLocation());

        return eventRepository.save(existingEvent);
    }

    public Event deleteEventById(String eventId) {
        Event existingEvent = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));
        eventRepository.delete(existingEvent);
        return existingEvent;
    }
}