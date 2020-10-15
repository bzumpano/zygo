class BookChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    stream_from 'books'
  end

  def unsubscribed
  end
end
