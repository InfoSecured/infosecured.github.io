---
title: "Code-less Slack Bot"
date:   2019-02-18 22:58:00
categories: [Automation]
tags: [Automation, Slack]
---

I recently came across the need to quickly access some Tenable Security Center data from my mobile device, which if you've ever attempted it, know that it isn't mobile browser friendly. So I thought to mysef, sure, I could write a python script and run it in pythonista, but then I would still need to log onto a VPN before I ran it and I also want to make this usable for others. Then I remembered that I could use Microsoft Flow to help facilitate this and the great part is that it would require minimal to no code.

Using Microsoft Flow, I began by setting up a Request trigger. I then named and saved my flow so it could generate a URL. Next, I logged into Slack and created a new app with a slash command. I pasted the URL I previously received into the Slack app as the webhook address and defined a command `/tenable [-action] [option]`.

Back in Flow, I created a response object because Slack needs a response within 3000ms. Don't worry, you'll be able to respond in Slack again. Next, I can start building the flow. When you send a slash command with Slack, the Content-Type is `application/x-www-form-urlencoded`. In Flow, this is a slight issue because there is no parser for this type of content. I initialized a new variable and set it to the body of the initial request as a string. This leads us to the most complicated section of the flow.

There are a couple of things we need from the body; the response URL, the action and if you have an option, you'll need that too. In order to parse the data, each of these items will need four compose objects. If you take a look at [this link](https://api.slack.com/slash-commands#app_command_handling), you can see a sample payload from the slash command. 

In Flow, I generally create a Scope in which to put the following Compose actions to make them easier to find and move if necessary.

Compose 1: Find the index of the first character in the response_url.
`@add(int(indexOf(variables('RequestBody'), 'https%3A%2F%2Fhooks.slack.com')), 0)`

Compose 2: Find the index of the last character in the response URL.
`@add(int(indexOf(variables('RequestBody'), '&trigger_id')), 0)`

Compose 3: Find the length of the URL.
`@sub(outputs('URL_Index_2'),outputs('URL_Index_1'))`

Compose 4: Get the substring of the URL and decode it.
`decodeUriComponent(substring(variables('RequestBody'), outputs('URL_Index_1'),outputs('URL_Index_3')))`

I performed the same steps on the action and any options as well.

Once all of the body is parsed, I set each item to a variable. 

Next, I created the request for data. The first action I'm creating will start a scan. For this action, we'll need to send an HTTP POST with a json payload.

Creating the json body:
Create a new Compose action. In the action, add the following json (changing the values to make sense for your environment).

![](/images/posts/json.jpeg "json")

Next, create an HTTP action:

![](/images/posts/createscan.jpeg "Create")


