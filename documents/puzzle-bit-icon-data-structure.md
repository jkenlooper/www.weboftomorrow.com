# Data structure for Bit Icons

Thinking out loud. This may not make any sense at all. Especially if you have no idea what a _bit icon_ is.

The bit icon as well as the player authentication is the last bit of code that
I need to transfer out my older system. This older system was built on top of
a custom CMS that ran on the tornado web framework. I now use the Flask web
framework and having to maintain this older code was not ideal.

## Problem

How to automatically recycle a bit icon when a player hasn't been active?

- currently just running a cleanup query on start of app

[chill route /snippet/puzzle-massive/remove-stale-bit-icons.sql/sql/]

quick, simple, does the job. Doesn't scale well. I could just run this process on a more regular basis.

## Proposal of a better solution

four tables involved: User, BitAuthor, BitIcon, BitExpiration
Create the new tables and drop the icon column from User.
One to one relationship of BitIcon to User:id. One to many on BitAuthor to BitIcon:id
Easy to just update the expiration in the BitExpiration table instead of the sub select for top 15 high scores.

BitIcon expiration updated each time a user increases their score. The extend time is based on the player's score.

drawback is this will happen often and the query may be too slow. Solution would be to push it to a job queue to be ran later.

Or can just run it for all players every day.

[chill route /snippet/puzzle-massive/expiration-setup.sql/sql/]

Create a migrate script to populate the new BitIcon table from what is in the file system. The users that have icons will also have expiration timestamp set based on m_date.

## Benefits

Now can show an _expired_ label on the icon. Expired icons are free for any
other player to claim, but will still be assigned to the original player until
then. This is better then just suddenly removing the assigned bit icon.

Going over the details in the SQL statements and tweaking them with various ideas of expiring bit icons quickly for players with less then 50 points.

## More tweaks

bit icon selection base on a time track

## Follow up after changes
