data modify storage dah.sch:task this.in set value "dah.sch:null"

#> First check for vanilla dimensions
execute if predicate {type:"location_check",predicate:{dimension:"overworld"}} run return run data modify storage dah.sch:task this.in set value "minecraft:overworld"
execute if predicate {type:"location_check",predicate:{dimension:"the_nether"}} run return run data modify storage dah.sch:task this.in set value "minecraft:the_nether"
execute if predicate {type:"location_check",predicate:{dimension:"the_end"}} run return run data modify storage dah.sch:task this.in set value "minecraft:the_end"

#> Call user defined dimensions for faster testing
function #dah.sch:known_dimensions
execute unless data storage dah.sch:task this{in:"dah.sch:null"} run return 1

#> Fallback to getting dimension from piglin brutes
# if difficulty peaceful, set it to easy temporarily
execute store result score #temp dah.sch.ram run difficulty
execute if score #temp dah.sch.ram matches 0 run difficulty easy
execute positioned ~ 9999 ~ summon piglin_brute run function dah.sch:z_private/parse/dimension/read_from_piglin_brute

execute if score #temp dah.sch.ram matches 0 run difficulty peaceful

#> If it did not work, just assume home dimension
execute unless data storage dah.sch:task this{in:"dah.sch:null"} run data remove storage dah.sch:task this.in