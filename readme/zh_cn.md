DBS(D-Better-Schedule)库提供了一个可以保留命令上下文的schedule命令。它可以记录当前的执行者，执行位置，执行朝向，执行维度。在一段时间后还原这些上下文并执行任意命令。若执行时，目标执行者不再存在（死亡，卸载，或是下线），本库也可灵活处理。

## 版本信息

| Minecraft | DBS |
| -------- | -------- |
| 1.21.5 ~ 26.2 | [v1.3](https://github.com/Dahesor/D-Better-Schedule/releases/tag/v1.3.0) |
| 26.3+ | [v1.4](https://github.com/Dahesor/D-Better-Schedule/releases/tag/v1.4) |

## 使用说明

**首先在storage `dah.sch:new new`中写入需要的参数**：

`run`: `#[command] string` 要执行的命令，不要加斜线。***必要***

`time`: `int` 等待的游戏刻。***必要***

`offline`: `string`
若执行时无法找到原实体，该如何处理：
 * `discard`: 移除任务，不执行任何东西。
 * `delay`: **仅玩家** 玩家下线时正常计时，但会延后至玩家再次上线时执行。
 * `pause`: **仅玩家** 玩家下线时暂停计时。
 * `by_server`: 该命令会由服务器尝试执行。

`max_retry`: `int`  若`offline`为`discard`或`by_server`，则若执行时实体不存在，则会在下一刻再次尝试，最多尝试`max_retry`次。若均失败则根据`offline`放弃任务或交给服务器执行。默认为`0`。

`flags`: `[string]` 规定额外功能：

 * `no_executer`: 不在上下文中记录执行实体。命令总是由服务器执行。
 * `debug`: 向聊天栏输出日志，用于debug。
 * `location_less`: 不在上下文中保存位置与旋转；命令将会在世界出生点执行。

`in`: `#[id="dimension"] string` 若指定，使用提供的维度覆盖上下文中的维度。

**输入参数后，在目标上下文中执行`function dah.sch:new`以计划本任务。**

示例:
```mcfunction
# 1秒后将执行者传送回当前位置。
data modify storage dah.sch:new new set value {run:"tp ~ ~ ~",time:20}
function dah.sch:new

# 1秒后将当前位置设置为石头，且输出日志。
data modify storage dah.sch:new new set value {run:"setblock ~ ~ ~ stone",time:20,flags:["debug"]}
function dah.sch:new

# 在10秒或移除该玩家的属性修饰器。若玩家在10秒内下线，则等到玩家上线后再移除。
data modify storage dah.sch:new new set value {run:"attribute @s attack_damage modifier remove foo:bar",time:200,offline:"delay"}
function dah.sch:new
```

库也提供一个简易的宏函数版本，只能接受`time`和`run`参数:
```mcfunction
function dah.sch:set {run:'say 1', time: 20}
```

## 添加已知维度

若上下文中的维度并非原版的三个维度之一，库会生成猪灵蛮兵实体并从其NBT中获得维度。该过程会需要额外的性能开销。

若想要在其他维度中也直接穷举判断出维度，可以在`#dah.sch:known_dimensions`函数标签中添加维度，执行`execute if predicate {type:"location_check",predicate:{dimension:"foo:bar"}} run data modify storage dah.sch:task this.in set value "foo:bar"`。

## 依赖库文件

库提供了一个`DBS-Dependency.zip`文件。将其放置于工作环境中，并在vs code根文件件创建一个`spyglass.json`文件，Spyglass插件就可以读取该文件的内容，并向你提供使用本库所需的函数，storage等补全信息:

示例`spyglass.json`。详见其官方文档[Spyglass Documentation](https://spyglassmc.com/user/config.html)。
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
需要重载Vs Code以生效。

## 卸载

本库无法在加载时卸载。请先移除数据包，reload，然后依次手动执行`unload.mcfunction`文件中的命令。

## 链接

本库使用了[gu](https://github.com/gibbsly/gu)库以转换UUID。

GitHub: [https://github.com/Dahesor/D-Better-Schedule](https://github.com/Dahesor/D-Better-Schedule)

Modrinth: [https://modrinth.com/project/d-better-schedule](https://modrinth.com/project/d-better-schedule)
