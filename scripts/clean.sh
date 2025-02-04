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

echo "Cleaning up..."

find ./debian -type f -name "Release" -exec rm {} \;
find ./debian -type f -name "Release.gpg" -exec rm {} \;
find ./debian -type f -name "InRelease" -exec rm {} \;
find ./debian -type f -name "Packages" -exec rm {} \;
find ./debian -type f -name "Packages.gz" -exec rm {} \;
find ./debian -type f -name "Packages.xz" -exec rm {} \;
find ./debian -type f -name "Contents*" -exec rm {} \;
find ./debian -type f -name "Contents*.gz" -exec rm {} \;

echo "Cleaned up."