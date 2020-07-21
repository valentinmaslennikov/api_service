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

###### тесты
 На процессоре Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz 
 на тестовых данных где ip - 289, пользователей - 543, постов - 200012. curl дал следующие результаты:
```
curl -w "@curl-format" -o /dev/null  --location --request GET '0.0.0.0:8080/top?count=10

    time_namelookup:  0,000031s
       time_connect:  0,001063s
    time_appconnect:  0,000000s
   time_pretransfer:  0,001156s
      time_redirect:  0,000000s
 time_starttransfer:  0,783322s
                    ----------
         time_total:  0,783367s

curl -w "@curl-format" -o /dev/null  --location --request GET '0.0.0.0:8080/top?count=1000
```
```
    time_namelookup:  0,000027s
       time_connect:  0,000960s
    time_appconnect:  0,000000s
   time_pretransfer:  0,001010s
      time_redirect:  0,000000s
 time_starttransfer:  0,818671s
                    ----------
         time_total:  0,820457s
```
```
 curl -w "@curl-format" -o /dev/null  --location --request GET '0.0.0.0:8080/ips'


    time_namelookup:  0,000050s
       time_connect:  0,001329s
    time_appconnect:  0,000000s
   time_pretransfer:  0,001442s
      time_redirect:  0,000000s
 time_starttransfer:  0,864936s
                    ----------
         time_total:  0,866741s
```
```
curl  -w "@curl-format" -o /dev/null --location --request PATCH '0.0.0.0:8080/ratings' \
--header 'Content-Type: application/json' \
--data-raw '{
    "post_id": "3",
    "value": "3"
}'

    time_namelookup:  0,000041s
       time_connect:  0,000852s
    time_appconnect:  0,000000s
   time_pretransfer:  0,000939s
      time_redirect:  0,000000s
 time_starttransfer:  0,709884s
                    ----------
         time_total:  0,709939s
```
```
curl -w "@curl-format" -o /dev/null --location --request POST '0.0.0.0:8080/posts' \
--header 'Content-Type: application/json' \
--data-raw '{
    "title": "Test post",
    "content": "Post post post",
    "username": "Vz06xE5fhTClyboqUWZd",
    "ip": "76.22.44.109"
}'

    time_namelookup:  0,000038s
       time_connect:  0,000953s
    time_appconnect:  0,000000s
   time_pretransfer:  0,001081s
      time_redirect:  0,000000s
 time_starttransfer:  0,753660s
                    ----------
         time_total:  0,753848s
```