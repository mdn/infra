'use strict';
exports.handler = (event, context, callback) => {
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    headers['x-xss-protection'] = [{
        key:   'X-XSS-Protection',
        value: "1; mode=block"
    }];

    headers['x-content-type-options'] = [{
        key:   'X-Content-Type-Options',
        value: "nosniff"
    }];

    headers['x-frame-options'] = [{
        key:   'X-Frame-Options',
        value: "DENY"
    }];

    headers['strict-transport-security'] = [{
        key:   'Strict-Transport-Security',
        value: "max-age=15552000; includeSubDomains; preload"
    }];

    headers['access-control-allow-origin'] = [{
        key:   'Access-Control-Allow-Origin',
        value: "*"
    }];

    headers['content-security-policy'] = [{
        key:   'Content-Security-Policy',
        value: "default-src 'none'; img-src 'self'; script-src 'unsafe-inline'; style-src 'self'"
    }];

    callback(null, response);

};
