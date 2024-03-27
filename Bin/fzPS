# 1. ps:   Feed the list of processes to fzf
# 2. fzf:  Interactively select a process using fuzzy matching algorithm
# 3. awk:  Take the PID from the selected line
# 3. kill: Kill the process with the PID
ps -ef | fzf | awk '{print $2}' | xargs kill -9
