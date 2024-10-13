#!/bin/bash
# Copyright (C) 2024 Pextra Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
set -e

if ! command -v apt-ftparchive &> /dev/null; then
	echo "apt-ftparchive is not installed"
	exit 1
fi

if ! command -v dpkg-scanpackages &> /dev/null; then
	echo "dpkg-scanpackages is not installed"
	exit 1
fi

readonly CE_GPG_KEY_FINGERPRINT="F6C824A95B510F49ED4B0D640B4F9057C7DBDC41"

readonly BASEDIR=$(pwd)
readonly DEB_DIRECTORIES=$(find ./debian -type f -name "*.deb" -exec dirname {} \; | sort -u)

make_release() {
	apt-ftparchive release . > Release
	gpg --yes --armor --local-user $CE_GPG_KEY_FINGERPRINT -o Release.gpg --sign Release
	gpg --yes --local-user $CE_GPG_KEY_FINGERPRINT -o InRelease --clearsign Release	
}

for directory in $DEB_DIRECTORIES; do
	echo "Updating $directory"

	cd $directory
	dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
	cd ../.. && make_release
	cd $BASEDIR
done

echo "Debian repository updated"