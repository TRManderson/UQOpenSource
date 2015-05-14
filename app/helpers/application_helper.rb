module ApplicationHelper
  def page_title
    if defined? @page_title
      @page_title
    else
      "UQ OSS Projects"
    end
  end

  def markdown(text)
    text.blank? ? "" : Markdown.new(text, banner: false).to_html.html_safe
  end

  def bootstrap_flash_for(flash_type)
    case flash_type
    when "success"
      "alert-success"
    when "error"
      "alert-danger"
    when "alert"
      "alert-warning"
    when "notice"
      "alert-info"
    else
      "alert-"+flash_type
    end
  end
end
