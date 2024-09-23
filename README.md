# Traffic Control Script - `ejj_trafficcontrol`

This standalone resource provides traffic control functionality and works with **any framework** (ESX, QBCore, etc.) because it relies on **ox_lib** and FiveM natives. The script includes a command to trigger the traffic control function and also provides a client export that can be called from other scripts.

## Requirements

- **ox_lib**: This script requires the `ox_lib` resource. Make sure to start `ox_lib` before this script in your `server.cfg`.

## Installation

1. Download or clone this repository into your `resources` folder.
2. Download and install `ox_lib` from [ox_lib GitHub](https://github.com/overextended/ox_lib) and add it to your `resources` folder.
3. Add the following lines to your `server.cfg` in this order:


## Usage

### Command

By default, you can trigger the `OpenTrafficMenu` function using an in-game command. The command is configurable through `Config.TrafficControlCommand.CommandName`.

- If `Config.UseJob` is set to `true`, only players with the specified job (like police) can use the command.
- If `Config.UseJob` is set to `false`, any player can use the command without a job check.

### Export

You can also trigger the `OpenTrafficMenu` function from another script using the following export:

```lua
exports.ejj_trafficcontrol:OpenTrafficMenu