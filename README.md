## Find hardware information
```bash
sudo dmidecode -t
sudo lspci
```

## TTY and killing processes
```bash
# switching between tty terminals
Ctrl + Alt + F3 to F6

# get top running processes 
top -n 1

# kill a process using a process id
pkill [xxxx]

# switch to graphical mode from ttyl
Ctrl + Alt + F7
```
## Installing Nvidia driver on Debian based distributions
Follow [Debian's wiki page](https://wiki.debian.org/NvidiaGraphicsDrivers) on how to properly install the correct Nvidia driver for your card. The following are the primary simple steps to achieve it for most modern cards.

Check for any Linux header updates first and update the system before proceeding
```bash
apt install linux-headers-amd64
```

Add `contrib`, `non-free` and `non-free-firmware` components to `/etc/apt/sources.list`. 
```bash
deb http://deb.debian.org/debian/ sid main contrib non-free non-free-firmware
```
Then run an update, install the necessary packages and reboot.
```
sudo apt update
sudo apt install nvidia-driver firmware-misc-nonfree
systemctrl reboot
```

After the installation is complete and the system reboots, check if the Nvidia driver is running.
```bash
nvidia-smi
```

## Loading modules at boot time
If there are any modules you need to run at boot time (for instnance sensor control modules for fans, etc), edit the following file and add them as needed.
```bash
sudo nano /etc/modules
```


## Local time issue with dual boot (Windows/Linux)
The local time seems to be inconsistent when switching between Windows and Linux. Running the following command on the Linux/GNU OS will fix the local time-sync issue.
```bash
sudo apt install ntpdate
sudo apt install ntp
sudo systemctl start ntpd
```

## Custom bash functions 
Sometimes you want to create and use custom functions globally in terminal. You can also reference (this "bash bible" on GitHub)[https://github.com/dylanaraps/pure-bash-bible] for more useful scripts.
* Edit the `~/.bashrc` file with your favourite text editor
    ```bash
    nano ~/.bashrc
    ```
* Add your custom functions at the end of the file
* Run the following command after updating your functions so it immediately takes effect
    ```bash
    source ~/.bashrc
    ```
<details>
    <summary>Example: custom_split_url()</summary>

    ```bash
    function custom_split_url() {
        printf "\n"
        printf "Splitting URL into query string param=value and URL decoding all values. Here are the results:"
        printf "\n\n"

        # Function to URL decode a string
        urldecode() {
            local url_encoded="${1//+/ }"
            printf '%b' "${url_encoded//%/\\x}"
        }

        # Function to add color to parameter names and subparameter names
        add_color() {
            local color_param="\033[0;33m"      # Yellow color for parameter names
            local color_subparam="\033[0;36m"   # Blue color for subparameter names
            local reset="\033[0m"               # Reset color

            if [[ $2 == "subparam" ]]; then
                printf "${color_subparam}%s${reset}" "$1"
            else
                printf "${color_param}%s${reset}" "$1"
            fi
        }

        # Input URL
        input_url="$1"

        # Extract parameters after "?" and decode them
        params=$(awk -F'[?&]' '{for(i=2;i<=NF;i++) {split($i, a, "="); printf("%s=%s\n", a[1], a[2])}}' <<< "$input_url")

        # Decode each parameter and print in a table format
        while read -r line; do
            param_name=$(cut -d'=' -f1 <<< "$line")
            param_value=$(cut -d'=' -f2- <<< "$line")
            
            # Split parameter value by commas and then decode individual values
            IFS=',' read -r -a values <<< "$(urldecode "$param_value")"
            for value in "${values[@]}"; do
                decoded_value=$(urldecode "$value")
                
                # Split subvalues by '&' sign and output each on a new line
                IFS='&' read -r -a subvalues <<< "$decoded_value"
                for subvalue in "${subvalues[@]}"; do
                    IFS='=' read -r subparam_name subparam_value <<< "$subvalue"
                    if [[ $subvalue == *"="* ]]; then
                        printf "%-35s %-35s\n" "$(add_color "$param_name" "param")" "$(add_color "$subparam_name" "subparam")=$subparam_value"
                    else
                        printf "%-35s %-35s\n" "$(add_color "$param_name" "param")" "$subvalue"
                    fi
                done
            done
        done <<< "$params"

        printf "\n"
    }
    ```
</details>


## Starting VirtualBox VM with a shortcut
Create an `.sh` file in your home `bin` folder with the following bash script, in this case the file will be called `autostartvm.sh`.
```bash
#!/bin/bash

# Include the name of the VM as well as which workspace you'd like it to open in
DESIRED_VMNAME="win11preview"
DESIRED_WORKSPACE=3

# Start the VirtualBox VM
VBoxManage startvm $DESIRED_VMNAME

# Wait for the VM window to appear (adjust sleep duration as needed)
sleep 1

# Find the window ID of the VM window
VM_WINDOW_ID=$(wmctrl -l | grep $DESIRED_VMNAME | awk '{print $1}')

# Move the VM window to the desired workspace
wmctrl -i -r $VM_WINDOW_ID -t $DESIRED_WORKSPACE
```

Make sure the file has execution permission:
```bash
chmod -x autostartvm.sh
```

Setup a keyboard shortcut in your OS environment that runs the following command:
```bash
bash /home/lin/bin/autostartvm.sh
```

## Docker management
After installing Docker engine using Docker's official wiki based on your OS/distro, add your user to the `docker` user group:
```bash
sudo usermod -aG docker $USER
```
For listing images and containers as well as removing them, reference the following commands:
```bash
# list containers (-a shows non-active containers)
docker ps -a

# list images
docker images -a

# remove container
docker rm [container_name]

# remove image (remove associated containers first)
docker rmi [image_name] # remove docker image
```

## Drive and disk management
There will be times when you need to format a mounted disk. The following commands will help in those cases.
```bash
# list all detected disks
sudo fdisk -l

# launch terminal disk/partition management tool
sudo cfdisk

# format disk (in this case, the mounted drive is "sda")
sudo mkfs.ext4 /dev/sda
```

## Mounting a secondary drive
You'll need to create a mounting point for the new drive. To do that, you need to create a directory for the drive and reference it as a mounting point to the drive's UUID in `fstab`.
```bash
# create a mounting point
sudo mkdir /mnt/backup_drive

# check if the drive is detected
sudo lsblk

# get the drive's UUID
sudo blkid

# add a mounting line in fstab. example line below: 
# UUID="6EE6F9AB2ADC4697"    /mnt/backup_drive    ntfs    default 0 0
sudo nano /etc/fstab

# reboot system
systemctrl reboot
```

## Mouse pointer acceleration
Some Linux/GNU distributions may default to enabling mouse pointer acceleration depending on your mouse/touchpad hardware. The following instructions will help disabling it as there is no graphical option to do it. 
* Edit the file `/usr/share/X11/xorg.conf.d/40-libinput.conf` as root using your favourite text editor.
    ```bash
    sudo nano /usr/share/X11/xorg.conf.d/40-libinput.conf
    ```
* Add the following line under any sections with the words "pointer" or "touchpad" in the "Identifier" field:
    ```
    Option "AccelProfile" "flat"
    ```
     The following is an example section with the line added:
    ```
    Section "InputClass"
            Identifier "libinput touchpad catchall"
            MatchIsTouchpad "on"
            MatchDevicePath "/dev/input/event*"
            Driver "libinput"
            Option "AccelProfile" "flat"
    EndSection
    ```
## Turning off wifi
The following commands will toggle wifi radio on/off if you want to simply rely  primarily on a wired ethernet connection.
```bash
# turning off wifi radio
nmcli radio widi off

# turning on wifi radio
nmcli radio wifi on
```
