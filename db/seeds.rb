Enemy.destroy_all

enemy1 = Enemy.create({
    name: "Beholder",
    damage: 3,
    thunderbolt: "thunderbolt",
    earthquake: "earthquake",
    flamethrower: "flamethrower",
    counter: 1
})

enemy2 = Enemy.create({
    name: "The Stoned Giant", 
    damage: 5,
    thunderbolt: "thunderbolt",
    earthquake: "earthquake",
    flamethrower: "flamethrower",
    counter: 2
})

enemy3 = Enemy.create({
    name: "Mind Flayer",
    damage: 10, 
    thunderbolt: "thunderbolt",
    earthquake: "earthquake",
    flamethrower: "flamethrower",
    counter: 3
})