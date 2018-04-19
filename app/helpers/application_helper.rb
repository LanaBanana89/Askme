module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def sklonenie(number, krokodil, krokodila, krokodilov)
    if number == nil || !number.is_a?(Numeric)
      number = 0
    end

    #Рассчитываем остаток от деления на сто
    ostatok_100 = number % 100

    # Проверяем, входит ли остаток от деления на сто в период 11..14
    if (11..14).include?(ostatok_100)
      return krokodilov
    end

    ostatok = number % 10

    if ostatok == 1
      return krokodil
    end

    if ostatok >= 2 && ostatok <= 4
      return krokodila
    end


    if ostatok >= 5 && ostatok <= 9 || ostatok == 0
      return krokodilov
    end
  end
end
