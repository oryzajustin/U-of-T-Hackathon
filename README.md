# U-of-T-Hackathon
Hack developed during the 2017 season U of T Hackathon

##Description
This hackathon project uses swift and Xcode to create an iPhone game, where the player is a stationary spaceship centered at the bottom 
of the screen and shoots lasers at incoming asteroids. However, to shoot the lasers, the player must blow into their
microphone, and use their finger to aim the lasers.

#todo
- [X] Created player sprite
- [X] Spawned meteors of varying sizes and speeds, infinitely
- [X] Rotated spaceship
- [X] Make laser point in direction of finger
- [X] Put hitboxes on laser, meteor and player
- [X] If a meteor goes past the bottom of the screen --> Game Over
- [ ] Replace touch (for activating the shooting), with audio detection
- [X] Track the player's score
- [ ] Create home screen
- [X] Create game over screen
- [ ] Add sound effects
- [ ] Add stars
- [ ] Design logo

#End of Hackathon notes:
Everything worked the way we intended, except we struggled with making the player shoot based off of audio detection for microphone blowing. We got very close, though. We were able to have the microphone detect blowing, but the challenge was having the player's shooting action activate off of the audio detection. A home screen, sound effects, stars and a logo would be much simpler to implement, and we might add in these features in the future.