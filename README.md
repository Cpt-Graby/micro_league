# Micro League

Micro league is a simple godot projet.  
The goal is to make a mini game where you can practice some mechanics  
for the game of league of legends.

## Creation of the maps

First things first for the prototype, we'll make a prototype maps.
Let's do a simple prototype of the [Howling Abyss of Butcher's Bridge](https://wiki.leagueoflegends.com/en-us/Murder_Bridge#:~:text=Murder%20Bridge%20is%20the%20collective%20term%20for,by%20Butcher's%20Bridge%20during%20the%20Bilgewater:%20Burning).

Here a some info i could generate with the IA for the scale of the prototype.
```
While Summoner's Rift is roughly 16,000 x 16,000 units, the Howling Abyss (ARAM) is significantly narrower and longer in a single direction. Use these estimates for your 2026 prototype: 
| Element | LoL Units | Godot Meters (1:100 Scale) |
| --- | --- | --- |
|Total Bridge Length (Fountain to Fountain)| ~14,000  | 140 m |
|Playable Lane Width |~1,400 | 14 m |
| Turret Attack Range |775 |7.75m|
|Turret Diameter|~300 |3.0m|
|Average Champion Hitbox| ~65 (radius) | 0.65m (radius)|
```

Since I don't want to reproduse the hole map for now, ill just do a surface of:
70m x 14m.

## Charactere motion

This part was pretty tricky for me. I had a lot of issue with the raycasting  
for making the click and move.  
HUGE shout out to: 
	- [Youtube channel Lukky](https://www.youtube.com/watch?v=0T-FMkSru64&list=PPSV)
	- [Gwizz tutorial](https://www.youtube.com/watch?v=mJRDyXsxT9g)  

For the path navigation we used the `navigation agent`, an implemented the 
algorithm of the [main documentation](docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html).
We had to add some aditional function so that charactere stop the motion right
in front of the destination and not just at reach.


## Base Minions

The basic implementation of the minion went easier then expected, since we used
a `navigation agent` as same as for the player.
Some parameter are necessary to avoid the player, like `Avoidance Enabled` and 
a toying a bit with the Radius of the Avoidance. 

## attack
https://www.youtube.com/watch?v=74XywaLGO5Q
https://www.youtube.com/watch?v=hyxJaUXpMyE

## Tasks:
	- Minions
	- Adding auto attacks
	- HUD

## Bugs:
	- Sliding charactere
	
### Note:
Here are some links that i dont want to loose:
https://github.com/abmarnie/godot-architecture-organization-advice

### Credits

[Youtube channel Lukky](https://www.youtube.com/watch?v=0T-FMkSru64&list=PPSV)
