execute store result score next dah.sch.ram run data get storage dah.sch:new new.time
execute store result score current dah.sch.ram run scoreboard players get @s dah.sch.player
scoreboard players operation current dah.sch.ram += next dah.sch.ram

data modify storage dah.sch:task this set value {on:1,run:'return 1',pos_x:"~",pos_y:"~",pos_z:"~",rot_x:"~",rot_y:"~"}
data modify storage dah.sch:task this.run set from storage dah.sch:new new.run

execute unless data storage dah.sch:new new{flags:["location_less"]} summon marker run function dah.sch:z_private/parse/location

execute unless data storage dah.sch:new new{flags:["location_less"]} run function dah.sch:z_private/parse/dimension/get
execute if data storage dah.sch:new new.in run data modify storage dah.sch:task this.in set from storage dah.sch:new new.in
execute if data storage dah.sch:new new.flags run function dah.sch:z_private/parse/flags_handler

execute store result storage dah.sch:task this.on int 1 run scoreboard players get current dah.sch.ram

function dah.sch:z_private/uid/get
data modify storage dah.sch:task this.by set from storage dah.sch:task player[0].uuid
data modify storage dah.sch:task que set from storage dah.sch:task player[0].pause
function dah.sch:z_private/parse/player/save/this
data modify storage dah.sch:task player[0].pause set from storage dah.sch:task que
data remove storage dah.sch:task que

data remove storage dah.sch:task this
return run scoreboard players get current dah.sch.ram