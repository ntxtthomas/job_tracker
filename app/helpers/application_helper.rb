module ApplicationHelper
  def sortable_link(column, title = nil)
    title ||= column.to_s.humanize
    direction = column.to_s == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    icon = ""

    if column.to_s == params[:sort]
      icon = params[:direction] == "asc" ? " ▲" : " ▼"
    end

    link_to "#{title}#{icon}".html_safe,
            request.params.merge(sort: column, direction: direction),
            style: "text-decoration: none; color: inherit; font-weight: bold;"
  end
end
