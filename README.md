# Scenario
Single Page Application uses ActionCable to receive update messages segregated by authenticated User using `stream_for`.

If the updated message is broadcasted from an ActionJob, this works using the `:async` development ActionJob queue_adaptor, but doesn't appear to work with any delayed or perform later queue adaptor.

# Fix
This branch fixes the issue by configuring the ActionCable adaptor to use Redis. See `config/cable.yml`

# Navigating the code
The ActionJob is triggered in `app/channels/web_notifications_channel.rb`:

``` ruby
class WebNotificationsChannel < ApplicationCable::Channel
  def subscribed
    logger.debug '> in WebNotificationsChannel.subscribed'
    stream_for current_user

    WebNotifyJob.perform_now('perform_now at WebNotificationsChannel.subscribed')
    WebNotifyJob.perform_later('perform_later at WebNotificationsChannel.subscribed')
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
```

# Steps to run / reproduce

1. Clone this repo
1. `$ bundle install`
1. `$ rails webpacker:install`
1. `$ rails db:migrate`
1. `$ rails db:seed`
1. `$ rails server`
1. `$ rails jobs:work`
1. Open [http://localhost:3000](http://localhost:3000), open the developer tools > network > web sockets and select 'cable'
1. Reload the page, and inspect the output:

![image](https://raw.githubusercontent.com/AndrewFreemantle/rails-action-cable-from-action-job-issue/delayed-job-adaptor-fails/dev-tools-image-one-message-bad.png)

We're expecting two messages, one sent immediately and one sent via `perform_later` which doesn't arrive.


# Desired outcome

The delayed ActiveJob should be able to broadcast via ActionCable - the output is expected to look like this:

![image](https://raw.githubusercontent.com/AndrewFreemantle/rails-action-cable-from-action-job-issue/delayed-job-adaptor-fails/dev-tools-image-two-messages-good.png)
