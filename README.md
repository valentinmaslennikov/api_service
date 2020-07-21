## API Service
#### Выполнено на Sinatra + ActiveRecord
##### seed выполняются при работающем сервере посредством Net::HTTP
###### запуск
```
rake db:create db:migrate
shotgun --port=8080 app.rb
```
###### присутствует команда для генерации данных напрямую в бд
```
rake seeds:seed
```
###### irb с подключенным проектом
```
bundle exec irb -I. -r app.rb
```