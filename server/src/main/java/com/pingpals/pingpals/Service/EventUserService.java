package com.pingpals.pingpals.Service;

import com.pingpals.pingpals.Model.Enum.Role;
import com.pingpals.pingpals.Model.Enum.Status;
import com.pingpals.pingpals.Model.EventUser;
import com.pingpals.pingpals.Repository.EventUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class EventUserService {

    @Autowired
    private EventUserRepository eventUserRepository;

    public EventUser getEventUserById(String eventUserId) {
        return eventUserRepository.findById(eventUserId)
                .orElseThrow(() -> new RuntimeException("EventUser not found with id: " + eventUserId));
    }

    public EventUser createEventUser(EventUser eventUser) {
        return eventUserRepository.save(eventUser);
    }

    public EventUser updateEventUserById(String eventId, EventUser updatedEventUserData) {
        EventUser existingEventUser = eventUserRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));

        // Allows partial updates
        if (updatedEventUserData.getEventId() != null) existingEventUser.setEventId(updatedEventUserData.getEventId());
        if (updatedEventUserData.getUserId() != null) existingEventUser.setUserId(updatedEventUserData.getUserId());
        if (updatedEventUserData.getRole() != null) existingEventUser.setRole(updatedEventUserData.getRole());
        if (updatedEventUserData.getStatus() != null) existingEventUser.setStatus(updatedEventUserData.getStatus());
        if (updatedEventUserData.getJoinedAt() != null)
            existingEventUser.setJoinedAt(updatedEventUserData.getJoinedAt());

        return eventUserRepository.save(existingEventUser);
    }

    public EventUser deleteEventUserById(String eventUserId) {
        EventUser existingEventUser = eventUserRepository.findById(eventUserId)
                .orElseThrow(() -> new RuntimeException("EventUser not found with id: " + eventUserId));
        eventUserRepository.delete(existingEventUser);
        return existingEventUser;
    }

    public EventUser joinEvent(String eventId) {
        return eventUserRepository.save(new EventUser(null, eventId, "memberUserId", Role.PARTICIPANT, Status.ACCEPTED, LocalDateTime.now()));
    }

    public EventUser cancelEvent(String eventId) {
        EventUser eventUser = eventUserRepository.findByEventIdAndUserId(eventId, "userId")
                .orElseThrow(() -> new RuntimeException("EventUser not found for eventId: " + eventId + " and userId: " + "userId"));

        eventUser.setStatus(Status.CANCELLED);
        return eventUserRepository.save(eventUser);
    }

    public List<EventUser> getEventUsersForEvent(String eventId) {
        return eventUserRepository.findByEventId(eventId);
    }

    public List<EventUser> getEventUsersForUser(String userId) {
        return eventUserRepository.findByUserId(userId);
    }

    public EventUser joinEvent(String eventId, String userId) {
        return eventUserRepository.save(new EventUser(null, eventId, userId, Role.PARTICIPANT, Status.ACCEPTED, LocalDateTime.now()));
    }

    public void leaveEvent(String eventId, String userId) {
        EventUser eventUser = eventUserRepository.findByEventIdAndUserId(eventId, userId)
                .orElseThrow(() -> new RuntimeException("EventUser not found for eventId: " + eventId + " and userId: " + userId));
        eventUserRepository.delete(eventUser);
    }
}