---
title: "Code-less Slack Bot"
date:   2019-02-18 22:58:00
categories: [Automation]
tags: [Automation, Slack]
---

I recently came across the need to quickly access some Tenable Security Center data from my mobile device, which if you've ever attempted it, know that it isn't mobile browser friendly. So I thought to mysef, sure, I could write a python script and run it in pythonista, but then I would still need to log onto a VPN before I ran it and I also want to make this usable for others. Then I remembered that I could use Microsoft Flow to help facilitate this and the great part is that it would require minimal to no code.

Using Microsoft Flow, I began by setting up a Request trigger. I then named and saved my flow so it could generate a URL. I then created a response object because Slack needs a response within 3000ms. Don't worry, you'll be able to respond in Slack again.

![](/images/posts/Step1.png "Request")

Next, I logged into Slack and created a new app with a slash command. I pasted the URL I previously received into the Slack app as the webhook address and defined a command `/tenable [-action] [option]`.

I can now start building the rest of the flow. When you send a slash command with Slack, the Content-Type is `application/x-www-form-urlencoded`. In Flow, this is a slight issue because there is no parser for this type of content. I initialized a new variable and set it to the body of the initial request as a string. This leads us to the most complicated section of the flow.

![](/images/posts/Step2.png "Variable1")

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

![](/images/posts/Step3.png "Parse URL")

I performed the same steps on the action and any options as well.

Once all of the body is parsed, I set each item to a variable. 

At this point, there are several paths we can take. In this post, I'll explain how to start a scan in Tenable IO but by passing in your intention into a variable, you can use the same parsing technique above to make more options available. Then a Switch can be created to choose which option you parsed.

![](/images/posts/Switch.png "Switch")

#### Start a Scan in Tenable IO

For this Switch, you'll be creating several options.

 1. Set the Slack Title variable (This is needed as setting this directly in the JSON file will remove any spaces you may have).
 2. Create the JSON for the Tenable Scan. 
 3. Create a Scan in Tenable IO.
 4. Parse the response to get the Scan ID.
 5. Launch the scan.
 6. Determine if the scan launched successfully.
 7. Create the JSON for the response to Slack.
 8. Notifying you back in the original Slack channel.

 This may seem like a lot of steps, but they're created very quickly.

 Here's what the first two steps should look like. To get these working, you'll need some data from Tenable IO (UUID, Scanner ID, and optional Folder ID). In addition, you can have the scan send the results to specific e-mail addresses by entering them in the JSON.

 ![](/images/posts/Step4.png "JSON")

 ```
 {
  "uuid": "",
  "settings": {
    "name": @{outputs('IPAddress2')},
    "description": "Scan created by Slack",
    "emails": "",
    "enabled": true,
    "launch": "ON_DEMAND",
    "scanner_id": 123456,
    "text_targets": @{outputs('IPAddress2')},
    "rrules": "FREQ=ONETIME",
    "folder_id": 123456
  }
}
```

Next, I created the request for data. The first action I'm creating will create a scan. For this action, we'll need to send an HTTP POST with the JSON payload. For this step, you'll need an API key and Secret key from Tenable IO. They can be entered into the X-ApiKeys object like this: `ApiKey=insertkeyhere; Secret=insertsecrethere`. The Body field should contain the output of the JSON object you created in the previous step.

![](/images/posts/Step5.png "First POST")

After creating the HTTP object, you'll need to parse the response from Tenable IO in order to get the Scan ID. Luckily, this is much easier than parsing `application/x-www-form-urlencoded`.  Create a new action and search for Parse Json. Choose that action and in the Content field, insert the Body of the previous HTTP request. In addition, you'll need a either a sample of that Body or the JSON schema. To get this, you can save and run your script. It will fail, but in doing so, you'll be able to get the response from the above Body object. I'm also including the schema so you can skip that step here. The field you're looking for is `id`.

![](/images/posts/Step6.png "Parse JSON")

```
{
    "type": "object",
    "properties": {
        "scan": {
            "type": "object",
            "properties": {
                "container_id": {
                    "type": "string"
                },
                "owner_uuid": {
                    "type": "string"
                },
                "uuid": {
                    "type": "string"
                },
                "name": {
                    "type": "string"
                },
                "description": {
                    "type": "string"
                },
                "policy_id": {
                    "type": "integer"
                },
                "scanner_id": {},
                "scanner_uuid": {
                    "type": "string"
                },
                "emails": {
                    "type": "string"
                },
                "sms": {
                    "type": "string"
                },
                "enabled": {
                    "type": "boolean"
                },
                "dashboard_file": {},
                "include_aggregate": {
                    "type": "boolean"
                },
                "scan_time_window": {},
                "custom_targets": {
                    "type": "string"
                },
                "starttime": {},
                "rrules": {
                    "type": "string"
                },
                "timezone": {},
                "notification_filters": {},
                "tag_id": {
                    "type": "integer"
                },
                "shared": {
                    "type": "integer"
                },
                "user_permissions": {
                    "type": "integer"
                },
                "default_permissions": {
                    "type": "integer"
                },
                "owner": {
                    "type": "string"
                },
                "owner_id": {
                    "type": "integer"
                },
                "last_modification_date": {
                    "type": "integer"
                },
                "creation_date": {
                    "type": "integer"
                },
                "type": {
                    "type": "string"
                },
                "id": {
                    "type": "integer"
                }
            }
        }
    }
}
```

Once you've parsed the JSON and extracted the `id`, you can simply launch the scan with another HTTP request. You'll need the same authentication data from the previous steps.

![](/images/posts/Step7.png "Launch Scan")

In the next step, you'll determine if the scan started successfully. This can be done by creating a Condition action and checking that the Status from the previous HTTP POST equals 200. Then, you'll create some variables with the text of your choosing to insert into the JSON body for the Slack response.

![](/images/posts/Step8.png "Launch Condition")

Next, you'll create the Slack response in JSON format. Below is an example of mine, but it can be as simple as a single text key.

![](/images/posts/Step9.png "Slack JSON")

```
{
  "attachments": [
    {
      "fallback": "Please visit the Tenable console to view results at this time.",
      "color": @{variables('SlackColor')},
      "pretext": "",
      "author_name": @{variables('SlackAuthor')},
      "author_link": "",
      "author_icon": "",
      "title": @{variables('SlackTitle')},
      "title_link": "https://cloud.tenable.com",
      "text": "",
      "fields": [
        {
          "title": @{variables('SlackText')},
          "value": "",
          "short": false
        }
      ],
      "image_url": "",
      "thumb_url": "",
      "footer": "",
      "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png"
    }
  ]
}
```

Finally, you'll create the HTTP POST to send your response to Slack. The URI for the Slack Response should be the first item you parsed and the Body should be the JSON you just created.

![](/images/posts/Step10.png "Slack Response")

I hope this post has been helpful. Feel free to reach out with any questions or comments.