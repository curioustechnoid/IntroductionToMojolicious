
# Mojolicious Website to create portal for registered users to enter testimonials



## Prerequisites

- Mojolicious Needs to be installed
- Mojo::mysql Perl module needs to be installed



## Installation


### Application Installation
Move the below parent directory to the server

myWebSite

### DB Installation

Run the below scripts as root database user in your server

`mysql -u root -p`

```sql
-- Create new database
CREATE database tct_mojo_db;

-- Create new user
CREATE USER 'demo'@'localhost' IDENTIFIED BY 'welcome123';

-- Grant Privileges to user
GRANT ALL PRIVILEGES ON tct_mojo_db.* TO 'demo'@'localhost';

-- Connect to new database
use tct_mojo_db;

-- Create the table
CREATE TABLE IF NOT EXISTS tct_mojo_testimonials (
id             INT(20)         NOT NULL AUTO_INCREMENT,
published_by   VARCHAR(560)    NOT NULL,
published_on   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
testimonial    VARCHAR(32000)  NOT NULL,
PRIMARY KEY (id)
) ENGINE=InnoDB;

```



## Usage


To run the web application use the below command:

- Development Environment

`morbo myWebSite/script/myWebSite`


- Production Environment

`hypnotoad myWebSite/script/myWebSite`


## Authors

* **Rakshith Chengappa** - *Initial work* - [The Curious Technoid](https://thecurioustechnoid.com/)


