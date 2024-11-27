# daily_updates bash script</h>

A simple script to run common updates and maintanance tasks on FreeBSD stable or current, for those who like to live on the bleeding edge. Great for workstations of lazy devs/users/sysadmins. Requires ports-mgmt/portmaster, devel/git, and root rights.

- Git pulls your configurted src and ports trees.
- Updates FreeBSD binary pkg db.
- Cleans stale port distfiles, packages.
- Checks for stale entries in /var/db/ports.
- Checks for port updates via portmaster.

That's all folks.

# use

sudo daily_updates.sh

# planned updates

- Option for choice of using binary updates vs. compiling your own, some more error checking, makinging it more pretty, perhaps some ZFS snapshot integrations.
