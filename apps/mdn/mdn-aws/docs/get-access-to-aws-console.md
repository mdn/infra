# Getting access MDN AWS console

The MDN AWS account is not integrated with Mozilla AWS SSO (maws) so if you are looking to just access the console you can
visit the [https://aws.sso.mozilla.com][aws-sso] to gain access

## CLI Access using Mozilla AWS SSO (maws)

In order to use the CLI with `maws` you will need to install a python package in order for you to be able
to access the command line with your Mozilla SSO identity.

The instructions on how to install and use `maws` can be found [here][maws-howto]

Once you have `maws` installed and your enviroment variables are exported into your enviroment you
are now ready to use `maws`.

## Other
You can read on more details on how it works by going to this [page][maws-details]

[aws-sso]: https://aws.sso.mozilla.com
[maws-details]: https://mana.mozilla.org/wiki/display/SECURITY/AWS+Federated+Login+Advanced+Details
[maws-howto]: https://mana.mozilla.org/wiki/display/SECURITY/How+to+login+to+AWS+with+Single+Sign+On
 
