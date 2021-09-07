# MDN Incident Response Guide

Stay cool, take a deep breath. We'll solve this problem together, and this guide is here to help.

This document does not describe the on-call or escalation process, but rather the process we use once an issue has been identified.

## Declaring an incident and the incident leader (IL) role

The incident leader (IL) is an MDN staff member that serves as the primary point of contact and coordinator for an incident. This person may have been called by the `IT-SRE` team, or just noticed that a service is broken.

When an incident occurs, the IL posts messages in one of the service channels for MDN stating:

- an incident has been declared and a few words about the incident
- "I am the incident leader"
- the main service channel for communication
    - we'll call this the *incident comms channel* in this document
- a Zoom meeting room if needed
- finally, decide if you need to notify the appropriate engineers that can help resolve the issue

Our service channels are `#mdndev` (IRC), `#mdn` (Slack), and `#mdn-infra` (Slack).


***Security incidents must not be discussed on IRC.***

Example incident declaration:

```
limed>  MDN is experiencing an outage                          12:00 PM
limed>  I am declaring an incident and am incident leader      12:00 PM
limed>  updates will be posted in the #mdndev channel          12:00 PM
limed>  ping rjohnson there is an urgent MDN outage            12:00 PM
limed>  please meet in my zoom room                            12:01 PM
```

> It's helpful to include a short description of the incident when mentioning comms channel users. For example `ping rjohnson` is not very useful when it appears as a notification on my phone, but `ping rjohnson MDN infra is on fire` lets me know that the issue is urgent without having to open my IRC app.

### Acknowledge Incident In PagerDuty

If you are responding to an incident that has been reported via PagerDuty it is important to `acknowledge` the incident within the PagerDuty system. Acknowledging the incident stops the automatic escalation process and informs folks who have access to PagerDuty that the incident is being worked on.

### Passing the baton

Incident response can be stressful, and it's ok if you need a break. In the incident comms channel, you can hand off the IL role to someone else if they agree. The new IL should acknowledge that they are now IL.

Example:

```
rjohnson> I need a few minutes of downtime                        4:01 PM
rjohnson> fiji has agreed to take over IL                         4:01 PM
fiji> Confirmed, I am now IL                                      4:01 PM
```

## Communications

Notify the following service channels:

- `#mdn` (Slack)
- `#mdn-infra` (Slack)
- `#mdndev` (IRC)
- `#it-sre` (Slack)

Example:

```
rjohnson>  there is an MDN outage, we are working in #mdndev       12:05 PM
rjohnson>  I'll post an update here within the next 30 minutes     12:05 PM
```

- Notify the appropriate lead(s) for the product.

For extended outages, a bug should be filed and the `#it-sre` Slack channel should be notified to update the status page.

> Don't post phone numbers in IRC!

### Frequency of updates

For outages, status should be posted every 30 minutes *or less* in the incident comms channel.

## Incident timeline

To help write an incident report, it's very useful to include a `TL:` prefix on channel messages when logging important events and decisions.

Example:

```
limed> TL: listeners appear to missing from the MDN ELB          3:11 PM
           ...
           ...
limed> TL: listeners have been manually added back to the ELB    4:05 PM
limed> TL: listeners have been overwritten by K8s                4:10 PM
```

## Incident resolution

When an incident has been resolved, post a message in the incident comms channel stating so:

```
limed> TL: the MDN outage has been resolved                      5:00 PM
limed> we'll followup with an incident report                    5:00 PM
```

### Resolve Incident In PagerDuty

Resolve the incident in PagerDuty. Once an incident is resolved, no additional notifications are sent and the incident cannot be triggered again.

## Incident report

Please add an [incident report](https://mana.mozilla.org/wiki/display/MDN/Incidents+Reports) to Mana within 48 hours of the incident.

## Incident response tips

- Take a few deep breaths, you're doing great!
- Stay positive, the IL is relying on teamwork to get things working again.
    - Give props to team members who are "fighting the good fight".
- Bring some humor to help break the tension.
- Don't distract the team by being critical, such as "this is poorly designed, it should be implemented with XYZ". This doesn't help us resolve the issue we're working on *right now*, but may be helpful as part of a postmortem.
