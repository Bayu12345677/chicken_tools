package_1 = "ncurses-utils"
package_2 = "curl"
package_3 = "lynx"
package_4 = "figlet"
package_5 = "toilet"


setup:
	apt-get install $(package_1) -y
	apt-get install $(package_2) -y
	apt-get install $(package_3) -y
	apt-get install $(package_4) -y
	apt-get install $(package_5) -y
run:
	chmod 0775 app.main.bash
	./app.main.bash
update:
	cd ..
	rm -rf chicken_tools
	git clone https://github.com/Bayu12345677/chicken_tools
	cd chicken_tools
	@echo
	@echo "successfully in the update"
