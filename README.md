# dotfiles

This is intended for personal use only. Use at your own risk.

## Commands

### `runcached`

Cache long running commands

```shell
runcached -- a_long_running_command with some args # first time: long running
runcached -- a_long_running_command with some args # cached: fast

runcached -- a_long_running_command changing the arguments # counts as another command: long running
MY_ENVVAR="something" runcached -- a_long_running_command with some args # this counts as another command as well

# Cache stays for up to RUNCACHED_MAX_AGE seconds
runcached -- a_long_running_command with some args # cached: fast
runcached -- a_long_running_command changing the arguments # cached: fast

# Pipes are not counted
runcached -- a_long_running_command with some args | fast_running_pipe # it will use a_long_running_command cached response, but it will not cache fast_running_pipe
```
