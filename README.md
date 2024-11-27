# daily_updates bash script

A simple script to run common updates and maintanance tasks on FreeBSD stable/master for those who like to live on the bleeding edge. Great for workstations and lazy devs/users. Requires ports-mgmt/portmaster and sudo rights.

- Git pulls your configurted src and ports trees.
- Updates FreeBSD binary pkg db.
- Cleans stale port distfiles, packages.
- Checks for stale entries in /var/db/ports.
- Checks for port updates via portmaster.

That's all folks.

# use

sudo daily_updates.sh
