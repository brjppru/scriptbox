#!/bin/bash
#
# sh-get-packages
#
# Downloads all currently installed packages into the current folder.
#
# This  program  is free software: you can redistribute it and/or modify  it
# under the terms of the GNU General Public License as published by the Free
# Software  Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This  program  is  distributed  in the hope that it will  be  useful,  but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public  License
# for more details.
#
# You  should  have received a copy of the GNU General Public License  along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#
# 29 Jan 18   0.1   - Initial version - MEJT
# 30 Jan 18   0.2   - If the download fails try to download the package from
#                     the security repository instead - MEJT
#
# To Do:            -
#
#
#_source="http://ftp.us.debian.org/debian/" # Stable (stretch) - US mirror
_source="http://ftp.uk.debian.org/debian/" # Debian (current) - UK mirror
_security="http://security.debian.org/" # Security updates
 
_filter=""
_count=0
 
#-- Scan command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
  --help)
    echo "syntax: $0 [OPTION]... [PACKAGE] [PACKAGE....]"
    echo "  -y, --confirm               Continue without intervention."
    exit 0 ;;
  -y|--confirm) # An example of an option with a parameter
    _confirm=true;;
  -*) # Unrecognized qualifier!
    echo "$0: unrecognized option '$1'"
    echo "Try '$0 --help' for more information."
    exit 0 ;;
  *) # Append each argument to args[] (preserving quoted strings).
    _pattern='^'$(echo "$1" | sed 's/*/.*/g')'$' # Bit of a 'fudge' to allow '*' to be used as a wildcard.
    _selection=$(dpkg-query --show --showformat='${package}\t${status}\n'|grep installed|cut -f 1|grep -e $_pattern)
    if [ ${#_selection} -gt 0 ]; then
      _args[$_count]=$1
      _count=$((_count + 1))
      _packages="$_packages $_selection"
    else
      echo "$0: '$1' is not installed."
      exit 1
    fi ;;
 esac
  shift
done
 
if [ ${#_packages} -eq 0 ]; then
  _packages=$(dpkg-query --show --showformat='${package}\t${status}\n'|grep installed|cut -f 1)
fi
 
_count=0
_errors=0
if (type wget >/dev/null 2>&1); then # Check to see if wget is available.
  for _package in $_packages; do
    for _path in $(apt-cache show $_package | grep "Filename:" | cut -f 2 -d " "); do
      wget -q -x -nH "$_source$_path"
      _status=$?
      if [ ! $_status -eq 0 ]; then
        if [ $_status -eq 8 ]; then
          wget -q -x -nH "$_security$_path"
          _status=$?
          if [ ! $_status -eq 0 ]; then
            _errors=$(($_errors + 1))
            echo "$(basename $0): Failed to download $(basename $_path)"
            _missing="$_missing $_package"
           else
            echo "$(basename $_path)"
            _count=$(($_count + 1))
          fi
        else
          echo "$(basename $0): Failed to download $(basename $_path)"
          _errors=$(($_errors + 1))
          _missing="$_missing $_package"
        fi
      else
        echo "$(basename $_path)"
        _count=$(($_count + 1))
      fi
    done
  done
  echo "Downloaded: $_count packages  Errors: $_errors"
  if [ ! $_errors -eq 0 ]; then
    echo "Try updating the installed packages using 'apt-get update;apt-get upgrade'"
    echo "then try to download the missing packages using:"
    echo "'$(basename $0)$_missing'"
    _status=1
  fi
else
  echo
  echo "$(basename $0): wget is not installed."
  _status=1
fi
exit $_status 
