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
curl -O /usr/share/keyrings/pextra-ce.gpg http://repo.pextra.cloud/debian/cloudenvironment/Release.gpg

# Add the repository to the sources list
echo "deb [signed-by=/usr/share/keyrings/pextra-ce.gpg] http://repo.pextra.cloud/debian/cloudenvironment bookworm common ose" > /etc/apt/sources.list.d/pextra-ce.list

# Update the package list
apt update
```

From there, you can install any package from the repository using `apt install <package>`.