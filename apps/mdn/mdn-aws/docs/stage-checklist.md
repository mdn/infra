This checklist uses these URLs:

* Base: https://developer.allizom.org
* CDN: https://stage-cdn.mdn.moz.works
* Demo: https://stage-files.mdn.moz.works
* Interactive Examples: https://interactive-examples.mdn.moz.works

# Refreshing staging instance

The staging instance has separate services from the production instance. The
staging database is initialized from an anonymized production database
backup. This database persists between deployments, and is refreshed
infrequently.

*TODO:* Add instructions for refreshing the staging database.

# Manual Sanity Check

## Home page

Load https://developer.allizom.org/en-US

* [ ] Loads without errors
* [ ] Does not have banner "MDN is currently in read-only maintenance mode. Learn more."
* [ ] Has entries for the Hacks Blog

## Article page

Load https://developer.allizom.org/en-US/docs/Web/HTML

* [ ] Loads without errors
* [ ] No Maintenance Mode banner

# Full Manual Tests

## Content tests

*Note: Many of these are candidates for headless testing*

These URLs should have similar results for anonymous or logged-in users:

* [ ] https://stage-files.mdn.moz.works/files/12984/web-font-example.png - 200, PNG of some "Hipster ipsum" text
* [ ] https://developer.allizom.org/@api/deki/files/3613/=hut.jpg - 200, image of a hat
* [ ] https://developer.allizom.org/contribute.json - 200, project info
* [ ] https://developer.allizom.org/diagrams/workflow/workflow.svg - 200, SVG with images
* [ ] https://developer.allizom.org/en-US/Firefox/Releases - 200, Firefox logo, list of releases (zoned URL)
* [ ] https://developer.allizom.org/en-US/docs/Learn/CSS/Styling_text/Fundamentals#Color - 200, with sample as iframe
* [ ] https://developer.allizom.org/en-US/search - 200, Search results
* [ ] https://developer.allizom.org/files/12984/web-font-example.png - Redirects to https://stage-files.mdn.moz.works
* [ ] https://developer.allizom.org/humans.txt - 200, list of GitHub usernames
* [ ] https://developer.allizom.org/media/revision.txt - 200, git commit hash for kuma
* [ ] https://developer.allizom.org/presentations/microsummaries/index.html - 200, 2006 OSCON presentation
* [ ] https://developer.allizom.org/robots.txt - 200, robots disallow list
* [ ] https://developer.allizom.org/samples/webgl/sample3 - 200, Shows WebGL demo
* [ ] https://developer.allizom.org/sitemap.xml - 200, list of sitemaps
* [ ] https://developer.allizom.org/sitemaps/en-US/sitemap.xml - 200, list of en-US pages

## Anonymous tests

Test these URLs as an anonymous user:

* [ ] https://developer.allizom.org/admin/users/user/1/ - 302 redirect to the Admin login page, asking for a username and password.

## Regular Account Tests

Some things to try with a regular account, to exercise write functionality:

* [ ] Create a new MDN user account (may require deleting your ``SocialAccount``)
* [ ] Update the account settings
* [ ] Log out
