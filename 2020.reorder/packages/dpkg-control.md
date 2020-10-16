
How to prevent updating of a specific package on Debian
If you want to make a dist-upgrade and avoid to upgrade a specific package, here you have some options:

Using dpkg
Displaying the status of your packages
dpkg --get-selections

Displaying the status of a single package
dpkg --get-selections | grep "package"

Put a package on hold
echo "package hold" | sudo dpkg --set-selections

Remove the hold
echo "package install" | sudo dpkg --set-selections


Using apt

Hold a package using:
apt-mark hold package_name

Remove the hold with:
apt-mark unhold package_name

URL: http://ximunix.blogspot.com/2016/02/how-to-prevent-updating-of-specific.html


HOWTO Fix error: dpkg-query: failed to open package info file `/var/lib/dpkg/status' for reading: No such file or directory
After an Electrical Outage in our Datacenter, one of our Servers got corrupted and I was getting the following error when running "dpkg -l":
dpkg-query: failed to open package info file `/var/lib/dpkg/status' for reading: No such file or directory

After my almost Panic attack, I searched a bit and found an easy solution:

If /var/lib/dpkg/status becomes broken for any reason, the Debian system loses package selection data and suffers severely. Look for the old /var/lib/dpkg/status file at /var/lib/dpkg/status-old or /var/backups/dpkg.stat us.*.

If the old /var/lib/dpkg/status file is not available, you can still recover information from directories in /usr/share/doc/.

    # ls /usr/share/doc | \
      grep -v [A-Z] | \
      grep -v '^texmf$' | \
      grep -v '^debian$' | \
      awk '{print $1 " install"}' | \
      dpkg --set-selections

    # dselect --expert # reinstall system, de-select as needed

So... no need to panic and always bring your towel :)

URL: http://ximunix.blogspot.com/2015/02/howto-fix-error-dpkg-query-failed-to.html

