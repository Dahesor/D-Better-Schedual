[中文](/readme/zh_cn.md)

# Introduction

D's Better Schedule is a library that provides a scheduler that keeps the context.
It will record the executor, location, rotation, and in some cases, dimension(see below) of the current context.
It also focuses on the behavior when the executor entity is offline, dead, or unloaded at the time of execution.

## Version Info

| Minecraft | D's Better Schedule |
| -------- | -------- |
| 1.21.5 ~ 26.2 | [v1.3](https://github.com/Dahesor/D-Better-Schedule/releases/tag/v1.3.0) |
| 26.3+ | [v1.4](https://github.com/Dahesor/D-Better-Schedule/releases/tag/v1.4) |

## How to Use

**To use the scheduler, first put the required data in storage `dah.sch:new new`.** Fields:

`run`: `#[command] string` The command to run as a string. No slash. ***REQUIRED***

`time`: `int` The number of ticks to wait before running the command. ***REQUIRED***

`offline`: `string`
What to do if the target entity is not found at the time of execution (offline, dead, or unloaded). Defaults to `discard`:
 * `discard`: Do nothing and remove the task.
 * `delay`: **PLAYER ONLY** The timer ticks when the player is offline, but only executes until the player go back online
 * `pause`: **PLAYER ONLY** Timer freezes when the player is offline.
 * `by_server`: The command will be executed by the server instead.

`max_retry`: `int`  If `offline` is set to `discard` or `by_server`, then if entity is not found at execution time, the task will be re-attempted on the next tick, up to `max_retry` number of times. If all retries failed then it proceeds to be discarded or executed by server accroding to `offline`. Defaults to `0`.

`flags`: `[string]` Defines extra behaviors for the task. May includes:

 * `no_executer`: The executor will not be included in the context; the command will be run by server.
 * `location_less`: The Location and Rotation will not be included in the context; command will be run at world spawn
 * `debug`: Output debug information to chat.
 * `try_dimension`: It will try to find the current dimension. The library will read it from entity data if the executor is a player, or it trys if it is `overworld`, `the_nether` or `the_end`. Otherwise it assumes `overworld`. You may add other custom dimensions into the function tag `#dah.sch:known_dimensions`, running `execute at @s if predicate {condition:"location_check",predicate:{dimension:"foo:bar"}} run data modify storage dah.sch:task this.in set value "foo:bar"` to extend the trial and error list.

`in`: `#[id="dimension"] string` Specifies a dimension to run the command in. This will be overwritten by the `try_dimension` flag.

**Then execute `function dah.sch:new` in the desired context to schdule the command.**

Example:
```mcfunction
# teleport the executor back to the current loction after 1s.
data modify storage dah.sch:new new set value {run:"tp ~ ~ ~",time:20}
function dah.sch:new

# setblock stone at current location after 1s, try to find the current dimension and spit out debug info.
data modify storage dah.sch:new new set value {run:"setblock ~ ~ ~ stone",time:20,flags:["debug","try_dimension"]}
function dah.sch:new

# Remove this player's attribute modifier after 10s. If the player goes offline in 10s then remove it after they log back in.
data modify storage dah.sch:new new set value {run:"attribute @s attack_damage modifier remove foo:bar",time:200,offline:"delay"}
function dah.sch:new
```

A simple macro version of the schduler is also provided as `function dah.sch:set`. It can only take in the `time` and `run` parameter:
```mcfunction
function dah.sch:set {run:'say 1', time: 20}
```

## Dependency File

A `DBS-Dependency.zip` is included in the release. Put this file anywhere on your computer, then by creating a `spyglass.json` file at the root of your workspace, the Spyglass extension will provides you the completion and error checking of all the functions, storages, and tags you need to write to use this library.

Example content of the `spyglass.json` file. See [Spyglass Documentation](https://spyglassmc.com/user/config.html) for more.
```json
{
	"env": {
		"dependencies": [
			"file:///C:/path/to/DBS-Dependency.zip",
			"@vanilla-mcdoc",
			"@vanilla-resourcepack",
			"@vanilla-mcdoc"
		],
		"gameVersion": "1.21.5"
	}
}
```
Remeber to Reload Vscode. If something about this somehow goes wrong, make Vs Code run the `Spyglass: Reset Project Cahce` command.

## Compatibility

This library, by itself, overrides no vanilla namespaces, does not modify/create/remove any world elements (blocks, entities, etc.), and all ids have the `dah.sch` prefix or namespace. Yes, this makes it follows the [Smithed](https://docs.smithed.dev/conventions/) and [essential MC Datapacks Discord Server Conventions](https://mc-datapacks.github.io/en/index.html). There should be zero worries about its compatibility.

## Uninstall

Because of how this library is implemented, it is not possible to unload the datapack data while it is enabled.

Thus, first remove the datapack, reload, then you may execute the commands listed in the `unload.mcfunction` file provided in the root folder to delete the remaining data. Follow the instructions in that file.

## Links

A [gu](https://github.com/gibbsly/gu) library is included to convert UUIDs

Repository: [https://github.com/Dahesor/D-Better-Schedule](https://github.com/Dahesor/D-Better-Schedule)

Modrinth: [https://modrinth.com/project/d-better-schedule](https://modrinth.com/project/d-better-schedule)
