module ApplicationHelper
  def format_date(date)
    date.strftime('%e %B %Y (%A)')
  end
end
