# Pextra Debian Repository

This repository contains all Debian packages for any of Pextra Inc.'s projects. It is available at [repo.pextra.cloud](http://repo.pextra.cloud/debian).

## Installation

### Supported Debian versions

Check if your system's Debian version is supported by the repository. The following Debian versions are supported:

| Debian Version | Supported |
|----------------|-----------|
| Bookworm (12)  | ✅        |

### Example: Adding the repository for Pextra CloudEnvironment

```bash
# Add the GPG key for the repository (signed by the master key)
curl -O /usr/share/keyrings/pextra-ce.gpg http://repo.pextra.cloud/debian/cloudenvironment/key.gpg

# Add the repository to the sources list
echo "deb [signed-by=/usr/share/keyrings/pextra-ce.gpg] http://repo.pextra.cloud/debian/cloudenvironment bookworm common meta" > /etc/apt/sources.list.d/pextra-ce.list

# Update the package list
apt update
```

From there, you can install any package from the repository using `apt install <package>`.

## Development

This repository is managed with [reprepro](https://deb.moep.com/manual.html/).

After building the packages, place them in the `incoming/<component>` directory, where `<component>` is the component of the package (e.g. `common`, `meta`, etc.). Run the following command to add the packages to the repository:

```bash
reprepro -b debian/cloudenvironment -C <component> includedeb bookworm incoming/<component>/*.deb
```
Replace `<component>` with the component of the package you want to add.