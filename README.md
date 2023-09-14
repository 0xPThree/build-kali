# A simple build script for new Kali pentest VM

The script will: 
- [x] Update the host machine
- [x] Install apt packages from `packages/apt_packages.txt`
- [x] Install pip3 packages from `packages/pip3_packages.txt`
- [x] Install go packages from `packages/go_packages.txt`
- [x] Install nim packages from `packages/nim_packages.txt`
- [x] Clone github repositories from `packages/git_repos.txt`
- [x] Download scripts/applications from `packages/wget_urls.txt`
- [x] Install Burp Suite Pro

The script is prepared to set up virtual environments with `venv` and `poetry` - to use this uncomment relevant section of the code.

## Usage
Run the script as a non-root user.
```bash
┌──(void㉿kali-script)-[~/build]
└─$ ./build-kali.sh

  __ )         _)  |      |       ___|              _)         |   
  __ \   |   |  |  |   _' |     \___ \    __|   __|  |  __ \   __| 
  |   |  |   |  |  |  (   |           |  (     |     |  |   |  |   
 ____/  \__,_| _| _| \__,_|     _____/  \___| _|    _|  .__/  \__| 
                                                       _|          

Root privileges required to update and install some packages.

[i] Updating Host: kali-script 6.4.0-kali3-amd64 
[✔] Host updated successfully

...
```

## TODO
- [ ] Update packages
- [ ] Add "Look and Feel" section
- [ ] Migrate to Ansible (?)
