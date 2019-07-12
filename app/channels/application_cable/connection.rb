module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      logger.info '> in ActionCable::Connection.connect'
      # Illustration purposes only - obviously we'd look up the current user by
      #  some means but for now we'll treat every ActionCable connection
      #  as belonging to our only seeded User
      self.current_user = User.all.first
    end
  end
end
