module ProjectsHelper
  def add_link_for(f)
    form = f.fields_for :links, Link.new, child_index: "new_link" do |l|
      render "link_form", l:l
    end
    x=link_to "Add link", "#", onclick: "addLink(this,'#{escape_javascript(form)}')"
    puts x
    return x
  end
end
