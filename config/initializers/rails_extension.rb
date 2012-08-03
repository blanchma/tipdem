module Rails
  def self.development?
    self.env == "development"
  end
end