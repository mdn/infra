When initializing a new MDN deployment, there are several items that may need
to be configured.

# Set Deployment Environment

The environment settings for a deployment may need to be customized for the
desired domain name and use cases. See the existing environments for ideas
on what may need to be changed.

* [ ] Customize the deployment settings

# Load a Database

A database is needed for an MDN deployment. We support MySQL RDS as the
database engine. There are three options for the database backup:

* Sample Database - located at
  https://mdn-downloads.s3-us-west-2.amazonaws.com/mdn_sample_db.sql.gz.
  It is loaded with content from production, and is periodically updated.
  It is customized for local development.
* Anonymous Database - This is a copy of the production database, with some
  sensitive data purged, and other user data such as emails anonymoized.
  It is used to test code changes that need the entire data set.
* Production Backup - This is a copy of the production database. It contains
  user data such as email addresses, and should be handled securely. One
  option is to load a recent backup and then anonymize it.

* [ ] Load the desired database
* [ ] (Optional) Run anonymization script
* [ ] (Optional) Run anonymization confirmation script

# Configure the Database

* [ ] Set the site name:
  ```
  ./manage.py set_default_site --name=site-name.moz.works --domain=site-name.moz.works
  ```
* [ ] Add a password-backed admin account:
  ```
  ./manage.py ihavepower username --password 'P@ssW0rd'
  ```
* [ ] (Optional) Configure GitHub Auth.
   A domain-specific GitHub OAuth application must be created to use GitHub
   auth. This can be a MDN staff member for short-term deployments, but should
   be created by *TKTKTK* for long-term production services. This will allow
   you to login and access the admin using your GitHub account.
   See [Enable GitHub Auth](https://kuma.readthedocs.io/en/latest/installation.html#enable-github-auth-optional))
* [ ] (Optional) Disable the password-backed admin account, or give it an
  unused password

# Generate files

Some files served by Django must be generated first:

* [ ] Generate ``humans.txt``:
  ```
  ./manange.py make_humans
  ```
