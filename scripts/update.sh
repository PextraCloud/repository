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
	override_file=$(find $BASEDIR -type f -name "release-override" | head -n 1)
	apt-ftparchive -c $override_file release . > Release
	gpg --yes --armor --local-user $CE_GPG_KEY_FINGERPRINT -o Release.gpg --sign Release > /dev/null
	gpg --yes --local-user $CE_GPG_KEY_FINGERPRINT -o InRelease --clearsign Release	> /dev/null
}

echo "Updating Debian repository..."
for directory in $(find ./debian -maxdepth 1 -type d | sed '1d'); do
	cd $directory

	for dist in dists/*; do
		for component in $dist/*; do
			if [ ! -d $component ]; then
				continue
			fi

			pushd $component
			for deb_file in $(find . -type f -name "*.deb"); do
				package_name=$(basename $deb_file)
				package_name=$(echo $package_name | cut -d'_' -f1)

				pool_dir=../../../pool/$(basename $component)
				mkdir -p $pool_dir/$package_name && cp $deb_file $pool_dir/$package_name

				parent_dir=$(dirname $deb_file)
				dpkg-scanpackages $pool_dir | sed "s|../../../pool|pool|g" > $parent_dir/Packages
				xz -9c $parent_dir/Packages > $parent_dir/Packages.xz
				gzip -9c $parent_dir/Packages > $parent_dir/Packages.gz

				arch=$(echo $parent_dir | cut -d'-' -f2)

				contents_dir=$(dirname $parent_dir)
				apt-ftparchive contents $pool_dir > $contents_dir/Contents-$arch
				gzip -9c $contents_dir/Contents-$arch > $contents_dir/Contents-$arch.gz

				# TODO: redo this
				override_file=$(find $BASEDIR -type f -name "release-override" | head -n 1)
				apt-ftparchive -c $override_file release /dev/null | sed '/:$/d' > $parent_dir/Release
cat <<EOF >> $parent_dir/Release
Archive: stable
Architecture: $arch
Component: $(basename $component)
Acquire-By-Hash: no
EOF

				sed -i '/^Components:/d' $parent_dir/Release
			done

			for deb_file in $(find . -type f -name "*.deb"); do
				rm $deb_file
			done
			popd
		done

		pushd $dist && make_release && popd
	done

	cd $BASEDIR
done

echo "Debian repository updated."