#!/usr/bin/env bash
# Must run in  /vagrant (guest server)

echo "***********************************************"
echo "***************** install *********************"
echo "***********************************************"



echo "***********************************************"
echo "---apt update e upgrade---"
echo "***********************************************"
sudo apt-get -y update
# upgrade to sudo 14.04.2 LTS
# sudo python3.2 get-pip.py
echo "***********************************************"
echo "--- python/Flask Stuff  (notice version 3) ---"
echo "***********************************************"
sudo apt-get -y install python3-pip
# curl -O https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py # for ubuntu 12
# sudo python3.2 get-pip.py  # for ubuntu 12
sudo apt-get -y install python3-dev python3-setuptools
sudo apt-get -y install git
sudo apt-get -y install supervisor

echo "***********************************************"
echo "--- PIP requirements ---"
echo "***********************************************"
cd /vagrant
sudo pip3 install MarkupSafe
sudo pip3 install gunicorn
sudo pip3 install flask
sudo pip3 install Flask-DebugToolbar
sudo pip3 install flask-wtf
sudo pip3 install flask-babel
sudo pip3 install Flask-Testing
sudo pip3 install guess_language
sudo pip3 install flipflop
sudo pip3 install coverage
sudo pip3 install beautifulsoup4
sudo pip3 install nltk
sudo pip3 install numpy # for textrank
sudo pip3 install Networkx # for textrank

# echo "***********************************************"
# echo "--- firefox + selenium (for tests)          ---"
# echo "***********************************************"
# sudo add-apt-repository -y ppa:mozillateam/firefox-next
# sudo apt-get -y update
# sudo apt-get -y install firefox
# sudo pip3 install -U selenium # notice pip3
# sudo apt-get -y install xvfb

# echo "***********************************************"
# echo "--- starts firefox in headless mode         ---"
# echo "--- (used in tests)                         ---"
# echo "***********************************************"
# sudo Xvfb :10 -ac&

# the commands below must run on the same terminal
# session where the tests are run
# export DISPLAY=:10
# sudo firefox&  # this can take a while


echo "***********************************************"
echo "--- setting up NLTK for summarize ---"
echo "***********************************************"
# Note, the NLTK packages must have already been downloaded to
# the GUEST folder: "/home/vagrant/nltk_data/"
# I initially used "all-corpora"
# NOTICE: This is not reliable is the script sometimes stop without downloading
# all the language packages
# Also, we try to wait until nltk_setup.py is done downloading everything it
# needs (it takes a while)
cd /vagrant
python3 nltk_setup.py &
wait %1

# copy downloaded language files to "vagrant" user directory
# (They were downloaded to /root :( )
sudo cp -R /root/nltk_data /home/vagrant/nltk_data

echo "***********************************************"
echo "--- End of NLTK setup ---"
echo "***********************************************"


echo "***********************************************"
echo "--- setting up Supervisor ---"
echo "***********************************************"
sudo cp /vagrant/shell_commands/supervisor_configs /etc/supervisor/conf.d/app.conf
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start app
sudo service supervisor restart
echo " "
echo "--- Supervisor Setup executed ---"
echo " "
echo "***********************************************"
echo " If the Summarizer App does not run on port 5000 "
echo " You might have to manually run nltk_setup.py "
echo " on the GUEST server                           "
echo "***********************************************"


