execute if entity @s[type=player] if data storage dah.sch:new new{offline:"pause"} unless data storage dah.sch:new new{flags:["no_executer"]} run return run function dah.sch:z_private/parse/player/pause
execute if entity @s[type=player] if data storage dah.sch:new new{offline:"delay"} unless data storage dah.sch:new new{flags:["no_executer"]} run return run function dah.sch:z_private/parse/player/delay

execute store result score next dah.sch.ram run data get storage dah.sch:new new.time
execute store result score current dah.sch.ram run function dah.sch:get_time
scoreboard players operation current dah.sch.ram += next dah.sch.ram

data modify storage dah.sch:task this set value {on:1,run:'return 1',pos_x:"~",pos_y:"~",pos_z:"~",rot_x:"~",rot_y:"~"}
execute if entity @s run function dah.sch:z_private/parse/get_entity
data modify storage dah.sch:task this.run set from storage dah.sch:new new.run

execute unless data storage dah.sch:new new{flags:["location_less"]} summon marker run function dah.sch:z_private/parse/location

scoreboard players set #retry dah.sch.ram 0
execute if data storage dah.sch:new new.max_retry store result score #retry dah.sch.ram run data get storage dah.sch:new new.max_retry
execute if score #retry dah.sch.ram matches 1.. run data modify storage dah.sch:task this.retry set value 1
execute if score #retry dah.sch.ram matches 1.. store result storage dah.sch:task this.retry int 1 run scoreboard players get #retry dah.sch.ram

execute unless data storage dah.sch:new new{flags:["location_less"]} run function dah.sch:z_private/parse/dimension/get
execute if data storage dah.sch:new new{offline:"by_server"} run data modify storage dah.sch:task this.force set value 1b

execute if data storage dah.sch:new new.in run data modify storage dah.sch:task this.in set from storage dah.sch:new new.in
execute if data storage dah.sch:new new.flags run function dah.sch:z_private/parse/flags_handler

execute store result storage dah.sch:task this.on int 1 run scoreboard players get current dah.sch.ram
data modify storage dah.sch:task stash append from storage dah.sch:task this
data remove storage dah.sch:task this

return run scoreboard players get current dah.sch.ram


