# Pextra Debian Repository

This repository contains all Debian packages for any of Pextra Inc.'s projects. It is available at [repo.pextra.cloud](http://repo.pextra.cloud/debian).

## Installation

### Supported Debian versions

Check if your system's Debian version is supported by the repository. The following Debian versions are supported:

| Debian Version | Supported |
|----------------|-----------|
| Bookworm (12)  | ✅        |
| Trixie (13)    | ✅        |

### Example: Adding the repository for Pextra CloudEnvironment

```bash
# Add the GPG key for the repository (signed by the master key)
curl -fSsLo /usr/share/keyrings/pextra-ce.gpg https://repo.pextra.cloud/debian/cloudenvironment/key.gpg

# Add the repository to the sources list (deb822 format).
cat > /etc/apt/sources.list.d/pextra-ce.sources <<EOF
Types: deb
URIs: https://repo.pextra.cloud/debian/cloudenvironment
Suites: trixie
Components: common meta
Signed-By: /usr/share/keyrings/pextra-ce.gpg
EOF

# Update the package list
apt update
```

From there, you can install any package from the repository using `apt install <package>`.

## Development

This repository is managed with [reprepro](https://deb.moep.com/manual.html/).

After building the packages, place them in the `incoming/<component>` directory, where `<component>` is the component of the package (e.g. `common`, `meta`, etc.). Run the following command to add the packages to the repository:

```bash
reprepro -b debian/cloudenvironment -C <component> includedeb <distribution> incoming/<component>/*.deb
```

### Adding a new Debian distribution

Supported distributions are declared in `debian/cloudenvironment/conf/distributions`. Add a new group using the existing groups as a template, substituting `<codename>` with the codename of the new distribution:
```
Codename: <codename>
Suite: stable
Version: 1.0
Components: common meta
Architectures: amd64 arm64
Origin: Pextra Inc.
Label: Pextra Inc.
Description: Pextra Inc. Debian repository
SignWith: F6C824A95B510F49ED4B0D640B4F9057C7DBDC41
```

Afterwards, create and populate the `dists` directory for the new distribution:
```bash
# Create new dists directory
reprepro -b debian/cloudenvironment export <codename>
# Copy matching packages from bookworm (existing distribution)
reprepro -b debian/cloudenvironment copymatched <codename> bookworm '*'
```
