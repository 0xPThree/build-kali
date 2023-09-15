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
- [x] Customize window environment

The script is prepared to set up virtual environments with `venv` and `poetry` - to use this uncomment relevant section of the code.

## Usage
Run the script as a __non-root user__. It will take ~20 minutes to complete.
```bash
┌──(void㉿kali-script)-[~/build]
└─$ ./build-kali.sh

  __ )         _)  |      |       ___|              _)         |   
  __ \   |   |  |  |   _' |     \___ \    __|   __|  |  __ \   __| 
  |   |  |   |  |  |  (   |           |  (     |     |  |   |  |   
 ____/  \__,_| _| _| \__,_|     _____/  \___| _|    _|  .__/  \__| 
                                                       _|          

Root privileges required to update and install some packages.

[i] Update/Upgrade Host: kali-script 6.4.0-kali3-amd64 
[✔] Host updated successfully

...
```

## Appearance
![no-apps](https://github.com/0xPThree/build-kali/assets/108757172/01c40b7a-e133-4b29-81a6-d51678eaff2e)

![terminals](https://github.com/0xPThree/build-kali/assets/108757172/3ea1d5db-4329-42d2-a759-04559b083782)


## TODO
- [ ] Update packages
- [ ] Migrate to Ansible (?)
