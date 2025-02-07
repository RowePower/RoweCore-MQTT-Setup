**Start with New or freshly formatted 32gb or Larger SD card 

**using Raspberry Pi Imager 

**First Select the device (Raspberry Pi3, Pi4, Pi5,...etc)

**Operating system 

**Select Raspberry Pi OS (Other)

**Select Raspberry Pi OS Lite (64-bit)

**Select your Storage Device 

**Click Next 

**(OPTIONAL)click Edit Settings if you want to change the following settings while writing the new image

	- HostName
	- Username and Pass
	- Wifi connection Ifo 
	- Local TimeZone 
	- **Enable SSH	

**You can choose to change host name, setup Wifi Credentials 

**Once Raspi image is Written to the Sd card. 

**Power on the Device and connect to the internet. 

**open a terminal or from the terminal if no desktop run this command. **Putty can be used if SSH is enabled

**Login as 	
	admin
	pass = Test1234

**then run the following command to update and install the os and git
	sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y git

**then run the following git Command to pull the latest repository.
 
	git clone https://github.com/RowePower/RoweCore-MQTT-Setup.git

** Change into that directory with 

	cd RoweCore-MQTT-Setup

**Make the setup.sh file pulled from git an Executable

	chmod +x setup.sh

**Run the Script with 

	./setup.sh

**once the script is complete the pi will reboot

**navigate to "Hostname":1880 for example raspberrypi:1880

**from the Top right corner click the 3 bars then select import

**Select File from import and Navigate to the saved Json flow you might have to show all file types

**Click deploy once finished 

**Check MQTT status by checking for data at "Hostname"/Status/Details







