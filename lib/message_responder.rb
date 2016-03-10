require './models/user'
require './lib/message_sender'
require './lib/user_firewall'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user_firewall = UserFirewall.new
    # @user = User.find_or_create_by(uid: message.from.id)
  end

  def respond
    return answer_with('not_allowed_user_message') unless @user_firewall.authorized?(message.from.username) 
    return cat_selector if message.text.starts_with?"/cat"
    return next_thuesday if message.text == "/seeyou"
    
    messages_selector(message.text).each do |message|
      answer_with(message)
    end
  end

  private
  def messages_selector(command)
    case command
    when '/start'
      ['greeting_message', 'help_message']
    when '/felfa'
      ['felfa_message']
    when '/missyou'
      ['missyou_message']
    when '/stop'
      ['farewell_message']
    else
      ['wtf_message', 'help_message']
    end
  end
  
  def cat_selector
    name = message.text.remove("/cat ")
    if name == "adrian" || name == "adri"
      text = I18n.t("cat_angry_name")
      answer_with_formatted_text(text)
    elsif name.size <= 2
      text= I18n.t("cat_short_name")
      answer_with_formatted_text(text)
    elsif name.size >= 6
      text= I18n.t("cat_long_name")
      answer_with_formatted_text(text)
    else
      text= I18n.t("cat_okey_name", name: name)
      answer_with_formatted_text(text)
    end  
  end
  
  def next_thuesday
    date = Date.today
    date += 1 + ((3-date.wday) % 7)
    text = text= I18n.t("seeyou_message", time_left: date.to_s)
    answer_with_formatted_text(text)
  end
  
  def answer_with(message_text)
    text = I18n.t(message_text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
  
  def answer_with_formatted_text(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
