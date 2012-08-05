module AntiSpamService

  BOTS = ["gnip", "bitlybot", "JS-Kit", "bot", "PostRank", "UnwindFetchor", "Bot",
  "Python", "facebookexternalhit", "Butterfly"]


  def self.human?(user_agent)
    !BOTS.include?(user_agent)
  end

end