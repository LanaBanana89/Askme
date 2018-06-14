# Веб-приложение "Спроси меня"

## Системные характеристики
Программа разработана на ОС Linux с помощью веб-фреймворка Ruby on Rails

## Описание
Приложение позволяет задавать вопросы различным пользователям. Задавать вопросы могут как зарегистрированные
пользователи, так и анонимные. В целях безопасности приложения был добавлен гем reCAPTCHA.

## Скриншот
![](https://github.com/LanaBanana89/askme/blob/master/app/assets/images/screenshot_app.png)

## Запуск приложения
1. Необходимо скачать либо клонировать репозиторий с приложением.
2. Перейти в терминале в папку с приложением.
2. Установить необходимые гемы для работы приложения, набрав в терминале команду bundle install.
3. Также необходимо сделать миграции с помощью команды bundle exec rake db:migrate.
3. Затем запустить в терминале локальный сервер localhost:3000 с помощью команды rails s 
и перейти в браузере по адресу http://localhost:3000

