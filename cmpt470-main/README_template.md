This is the template for CMPT 470 projects, providing some basics for Vagrant and Virtualbox setups, with configuration by Chef.

After running vagrant up, the project can be accessed through: localhost:8080

Features:
Polls:
Create polls, Add tags to polls, Add answers to polls, vote on poll answers
Sort polls, search polls via key words, filter polls via tags
Commenting on polls, Pagination on polls index page 
Accounts:
Create account, login, logout, commenting, display user comments on profile page, display notifications, 
Display user answers to polls on their profile page
Set permission levels for who can see a user or their responses via account options


Account level features:
In addition to regular user features, the following account levels have additional permissions:
Moderator: delete polls, delete comments
Admin: delete polls, delete comments, change user levels

Test accounts:
Admin:
email: kstory@sfu.ca
password: cmpt470pw

Moderator:
email: kenstoryx@gmail.com
password: cmpt470pw

Regular User:
email: test@gmail.com
password: cmpt470pw
