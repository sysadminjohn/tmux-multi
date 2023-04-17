# tmux-multi

This script spawns a connection to a user provided list of multiple hosts (ssh or netcat, for instance).
All the connections will be added to a Tmux session.


## TODO

- TODO itself is yet to be written but the code surely has room for improvement

## Tmux cheat sheet: 
| Shortcut          |   Description |
| ------------------|---------------|
| CTRL+B N          | [N]ext window |
| CTRL+B P          | [P]revious window |
| ------------------|---------------|
| CTRL+B D          | [D]etach |
| tmux a            | Attach to last session |
| tmux ls           | List sessions |
| tmux a -t MY1     | Attach to tmux session named MY1 |
| ------------------|---------------|
| CTRL+B C          | New window | 
| CTRL+B "          | Split vertically | 
| CTRL+B %          | Split vertically | 

To interact with nested tmuxes on the hosts, use CTRL+B+B



