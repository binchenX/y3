module Markdownable
  def self.included(base)
    base.class_eval do
      before_save :generate_html_content
    end
  end

  def generate_html_content
    self.html_content = RDiscount.new(content).to_html
  end
end
