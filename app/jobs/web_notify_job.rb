class WebNotifyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    WebNotificationsChannel.broadcast_to(
      User.all.first,
      message: "Hello from WebNotifyJob, args: #{args}"
    )
  end
end
