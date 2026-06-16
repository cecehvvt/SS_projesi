package com.dayanisma.backend.observer;

import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class FavoriteEventPublisher {
    private final List<FavoriteObserver> observers;

    public FavoriteEventPublisher(List<FavoriteObserver> observers) {
        this.observers = observers;
    }

    public void publish(FavoriteEvent event) {
        observers.forEach(observer -> observer.onFavoriteEvent(event));
    }
}
