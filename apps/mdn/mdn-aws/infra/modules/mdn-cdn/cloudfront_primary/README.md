# MDN Primary CDN
This CDN configuration is used to create the CDN placed in front of
[developer.mozilla.org](https://developer.mozilla.org) (production) as well as
the CDN in front of [developer.allizom.org](https://developer.allizom.org)
(stage). The core of this configuration is an ordered list of behaviors, where
the behavior for any given request is selected by starting at the beginning of
the list and finding the first match between the request path and the
behavior's path pattern. All of the behaviors will automatically handle
compression, but GZip only (Brotli compression is not yet supported).

CloudFront will
[cache many error responses by default](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HTTPStatusCodes.html#HTTPStatusCodes-cached-errors),
so we include custom error responses that effectively turn-off the caching for:
* `400 Bad Request`
* `403 Forbidden`
* `404 Not Found`
* `500 Internal Server Error`
* `502 Bad Gateway`
* `504 Gateway Timeout`

CloudFront ignores the `Vary` header. All desired cache variance must be
explicitly configured via the header, cookie, and query-parameter configuration
within each behavior.

## Static and Media Behaviors
The first three behaviors (`#0`, `#1`, and `#2`) match against requests for static
and media files. The responses to these requests are cached for long periods of time
(typically a year or more). These behaviors eliminate the need for a
separate CDN for the static/media assets.

## Pass-Through Behaviors
Each of these behaviors, `#3` through `#14` as well as `#19` through `#26`, share
the same configuration except for the path pattern, and are designed to simply
forward the complete incoming request to the origin (all headers, cookies,
and query parameters), and perform **no** caching of the response. Most,
if not all, of these behaviors match endpoints that allow `POST` requests that
depend upon a `csrftoken` cookie, which is so varied as to make caching
useless anyway. Also, most of these behaviors match endpoints that require
login, so not caching them is of almost no consequence since requests
from logged-in users comprise only a tiny fraction of the total requests.

## Dashboard Caching Behaviors
Behaviors `#16`, `#17`, and `#18`, are designed specifically for the three
dashboard endpoints that can vary caching based on the `X-Requested-With`
header.

## Core Document Behavior
Behavior `#15` handles the core requests to MDN, the document requests.

## Default Behavior
The default behavior handles all requests that do not match any of the
preceding behaviors.
