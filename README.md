## API Service
#### Выполнено на Sinatra + ActiveRecord
##### seed выполняются при работающем сервере посредством Net::HTTP
###### запуск
```
rake db:create db:migrate
shotgun --port=8080 app.rb
```
###### irb с подключенным проектом
```
bundle exec irb -I. -r app.rb
```