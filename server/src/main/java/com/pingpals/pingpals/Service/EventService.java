package com.pingpals.pingpals.Service;

import com.pingpals.pingpals.Model.Event;
import com.pingpals.pingpals.Repository.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EventService {

    @Autowired
    private EventRepository eventRepository;

    public Event getEventById(String eventId) {
        return eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));
    }

    public Event createEvent(Event event) {
        return eventRepository.save(event);
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