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
