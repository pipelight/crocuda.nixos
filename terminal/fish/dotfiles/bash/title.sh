## From molly-guard

# Walk up the process tree until PID 1 is reached or a process with 'sshd' in
# its /proc/<pid>/cmdline is met. Return success if such a process is found.
is_child_of_sshd() {
  pid=$$
  ppid=$PPID
  # Be a bit paranoid with the guard, should some horribly broken system
  # provide a strange process hierarchy. '[ $pid -ne 1 ]' should be enough for
  # sane systems.
  [ -z "$pid" ] || [ -z "$ppid" ] && return 2
  while [ $pid -gt 1 ] && [ $pid -ne $ppid ]; do
    if egrep -q 'sshd|mosh-server|etterminal' /proc/$ppid/cmdline; then
      return 0
    fi
    pid=$ppid
    ppid=$(grep ^PPid: /proc/$pid/status | tr -dc 0-9)
  done
  return 1
}
