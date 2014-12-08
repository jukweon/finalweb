Group album webapp! :)
http://web-group-album.herokuapp.com/

Gradebook
Gradebook is a tool for managing assignments submitted via a GitHub repo, using tags to differentiate between assignments. The bulk of it was written over the course of about 6 hours, after I got really fed up with trying to use Google Spreadsheets to input grades.

Features

Automatic submission tracking via the Github API
Supports assignment resubmission using version numbers
Secure private links for students to view their grades
Secure administrator login via Google OAuth
Nice admin UI (Bootstrap)
Use

Clone the repo
Edit config/initializers/admin_users.rb to reflect the admins' google account info.
Set the GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, GITHUB_CLIENT_ID, and GITHUB_CLIENT_SECRET environment variables with your GitHub and Google API credentials (if you're deploying to heroku, you'll need to set those on the server as well).
Install dependencies with bundle install
Create the database with rake db:create db:migrate (you will need to have postgres installed)
Run this app with rackup or shotgun
Screenshots

screen shot 2014-09-23 at 1 28 18 pm

screen shot 2014-10-25 at 10 44 24 am

screen shot 2014-09-23 at 12 54 04 pm

screen shot 2014-09-24 at 8 58 33 am
