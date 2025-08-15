module ApplicationHelper
  def language_switcher
    content_tag(:div, class: "dropdown") do
      # This is the dropdown toggle link
      concat(link_to("#",
                     id: "Dropdown",
                     role: "button",
                     class: "dropdown-toggle",
                     "data-mdb-toggle": "dropdown",
                     "data-mdb-dropdown-init": "",  # <<< THIS ATTRIBUTE IS CRUCIAL
                     "aria-expanded": "false"
                    ) do
                      # This generates the flag icon inside the link
                      content_tag(:i, "", class: "flag-#{locale_to_country_flag(I18n.locale)} flag m-0")
                    end)

      # This is the dropdown menu
      concat(content_tag(:ul, class: "dropdown-menu", "aria-labelledby": "Dropdown") do
        # Generate a link for each available language
        I18n.available_locales.each do |locale|
          concat(content_tag(:li) do
            link_to(url_for(locale: locale), class: "dropdown-item") do
              concat(content_tag(:i, "", class: "flag-#{locale_to_country_flag(locale)} flag"))
              concat(" #{locale.to_s.upcase}")
              if I18n.locale == locale
                concat(content_tag(:i, "", class: "fa fa-check text-success ms-2"))
              end
            end
          end)
        end
      end)
    end
  end

  def locale_to_country_flag(locale)
    case locale.to_sym
    when :en
      "united-kingdom"
    when :pt
      "brazil"
    when :it
      "italy" # Assuming "italian" is the class for the Italian flag
    else
      "united-kingdom"
    end
  end
end
