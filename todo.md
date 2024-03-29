# RPG To-do List

## Multiplayer Refactor

- Server handles all map interactions, apart from:
  - Firing a projectile
    - May need some sort of event queue for this, which gets things removed from the received state, and added to the local state
  - Any player interactions like movement/animation changes
    - Progression through an animation can be client side, although may need to be synced depending on the animation
  - Have singleplayer/multiplayer options on the main menu, where you can connect to another server in multiplayer

## Procedural Textures

- Look into procedural texture generation so it's easier to make new textures
- Replace existing textures with the new procedural textures

## Classes

### New Classes

- Make classes including warrior, archer, etc.

### Weapons

- Think of weapons for every class

## Armour System

- Make generic (so every class can use them) tiered armour sets
- Each tier, the armour is better
- Potentially make armour grant abilities

## Currency

- Make a currency like gold coins or something that players can trade for goods/sell items

### Traders

- Make traders that sell goods to the player and also where the player can sell items for currency

## Items

- Potions, resources, enchantables - maybe to replace abilities on armour

## Inventory

- Every player has an inventory, maybe make a way to store items in the world e.g chest/crate

## Mob Drops

- Make loot tables for every mob with rare items and common ones

## skills

- Player overall level is the average of all skills
- Potentially have the skill's perks discovery based, so if you use items in a specific order/specific types of items/specific spells you can discover new things in the skill

### Types Of Skill

- Including: woodcutting, foraging, mining, blacksmithing, crafting, weapon mastery (potentially on the weapon item itself, and also on the player?), armour mastery (same with weapon mastery), traveller

### Experience

- Every time a player practices a skill, they gain experience
- Level 100 is max level
- Experience needed goes up per level

### Bonuses

- Higher levelled players get bonuses for the skills, e.g traveller could be walking faster

## Resource Gathering

- Progress bars for harvesting a resource
- Types of resources include: ore, trees, bushes, etc.
- Potentially make them biome specific

## Crafting System

- Make a crafting system for players to craft weapons/armour/other items

### Unique Attacks

- Mages can spin in a circle channelling a tornado in the centre of the circle which will damage mobs
- Archers can shoot arrows to each other, that will penetrate through any mobs that get in the way, where with multiple archers will
- Warriors will be able to charge in a row, with the more players, the wider it is - then any mobs that get in the way will be trapped in front of the charge and damaged
