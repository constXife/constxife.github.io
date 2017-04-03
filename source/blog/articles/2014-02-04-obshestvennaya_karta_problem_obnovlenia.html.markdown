---
title: Общественная карта проблем. Обновления от 4 февраля.
tags: oblakan rm, общественная карта проблем, разработка
date: 2014-02-04 06:38:50
-------------------------

Описание обновлений за неделю.

- Были проведены оптимизационные работы, в следствие чего, скорость работы сайта ощутимо увеличилась.

- Исправлен баг с подписками для зарегистрированных пользователей

- Добавлен один уровень уровень уменьшения масштаба.

- Добавлена ссылка на редактирование карт (через редактор OSM, изменения с этого сайта будут скачиваться примерно раз в месяц)

- Добавлена информация для поисковиков (но пока индексируется лишь гуглом, с яндексом видимо надо дополнительно разбираться)

И теперь подробнее о некоторых моментах.

Оптимизация

Как некоторые могли заметить, в последнее время мой сайт загружался довольно долго. Это объясняется тем, что я сосредоточился на скорости выпуска новых возможностей и не долго не ломал голову над оптимизацией, а шёл напролом, размахивая костылями в коде, заклеивая дыры обычной пластиковой бутылкой и скотчем. Но прежде чем начать работать над поддержкой дополнительных городов мне пришлось всё же заняться оптимизацией внутренностей сайта.

В общем-то, на моём текущем уровне оптимизация — дело не очень хитрое. Всё свелось к тому, что я постарался минимизировать запросы к другим таблицам. И поэтому для счётчиков фотографий, подписчиков и комментариев были заведены соответственные поля в таблицах. Следующим шагом было подключение в запросах используемых таблиц джойнами (чтобы ORM-ка не лезла в каждой итерации в другие таблицы) и использование частичных полей в API запросе, чтобы при получении списка сообщений о проблемах выдавалась только необходимая информация, а при заходе в неё — вся оставшаяся. Идея была хорошая, но, к сожалению, я не смог завести Ember с частичными полями API — он упорно всё кешировал и не хотел отправлять новый запрос. Это наверняка решается как-то просто, но на тот момент мне хотелось поскорее уже выпустить хоть что-то, поэтому я решил частичные поля API оставить на потом. Ну и напоследник я врубил артиллерию — redis-кеширование API ответов. Но я не сильно опытен в использовании кеширования, поэтому я список проблем не решился кешировать, пока не поиграюсь и не разберусь получше в её внутренностях.

              # index.json.builder
              json.meta do
                json.total_pages @reports.total_pages
              end
              json.reports @reports, partial: 'api/reports/report', as: :report
              json.users @users, partial: 'api/users/user', as: :user
              json.photos @photos, partial: 'api/photos/photo', as: :photo
              json.cache! @statuses, expires_in: 3.day do
                json.statuses @statuses, partial: 'api/statuses/status', as: :status
              end
              json.cache! @categories, expires_in: 1.day do
                json.categories @categories, partial: 'api/categories/category', as: :category
              end
              
С API-сервером пока было закончено и я перешёл к интерфейсу. Самой главной задачей стало ускорить появление карты. Поэтому на карте сначала появляются первые 10 проблем, а потом асинхронно подгружаются остальные проблемы. Всё довольно просто, да.

              # index_route.js.coffee
              afterModel: (reports) ->
                  totalPages = reports.store.typeMapFor(reports.type).metadata.total_pages
                  page = 2
                  Ember.run.scheduleOnce 'afterRender', @, =>
                    while page < totalPages
                      @store.find('report', { map_scope: true, page: page }).then (records) ->
                        records.forEach (record) ->
                          reports.pushObject(record)
                      page++
              
Ну и потом устроил зачистку в коде, чтобы выпилить ненужные запросы к серверу, а в ответах API сервера возвращается не только список проблем, к примеру, но и сразу релевантный список сопутствующих сущностей, таких как список используемых пользователей или фотографий. В итоге получается как-то так.

              # API, возвращение списка проблем.
              INFO -- : Completed 200 OK in 236ms (Views: 199.5ms | ActiveRecord: 21.0ms)
              
А дальше дело за браузером.

Поисковые системы

Чтобы поисковые системы имели возможность индексировать содержимое моего AJAX-сайта я создал для себя отдельный мини-сервис, который заходит своим headless-браузером на определённый URL и тащит оттуда сгенерированный html-код, который потом скармливает поисковому роботу (YARRR!).

1. Ставим phantomjs

2. Колбасим скрипт для парсинга.

              # html.js
              var page = require('webpage').create(), system = require('system'), output, address;
              if (system.args.length === 1) {
                  console.log('Usage: html.js <URL>');
                  phantom.exit();
              }
              address = system.args[1];
              page.onResourceRequested = function(requestData, request) {
                if ((/http:\/\/.+?\.(css|png|jpg|jpeg)$/gi).test(requestData['url'])) {
                  request.abort();
                }
              };
              page.open(address, function(status) {
                if (status !== 'success') {
                  console.log('FAIL to load the address: ' + address);
                  phantom.exit();
                } else {
                  window.setTimeout(function() {
                    console.log(page.content);
                    phantom.exit();
                  }, 100);
                }
              });
              
3. Колбасим приёмочный веб-скрипт (внимание, говнокод)

              # phantom.rb
              class PhantomApp  
                def call(env)
                  request = Rack::Request.new(env)
                  headers = {'Content-Type' => 'text/html'}    
                  path = request.path.split('/')[1]
                  case path
                    when 'html'
                      url = request.fullpath[6..-1]
                      if url         
                        parsed_url = URI.parse(url)          
                        result_url = url
                        parameters = []
                        if parsed_url && parsed_url.query
                          parameters = CGI.parse(parsed_url.query)
                          unless parameters.empty?              
                            if parameters.has_key?('_escaped_fragment_')
                              parameters.delete('_escaped_fragment_')              
                              unless parameters.has_key?('crawler')
                                parameters.merge!({'crawler' => 'true'})
                              end
                            end
                            calculated_params = (parameters.empty?)? '' : "?#{URI.encode_www_form(parameters)}"
                            result_url = "#{parsed_url.scheme}://#{parsed_url.host}:#{parsed_url.port}#{parsed_url.path}#{calculated_params}"
                          end                                
                        end
                        output = `phantomjs /var/www/lunkserv/phantom/html.js #{result_url}`
                        [200, headers, [output]]           
                      else
                        [401, headers, ['html is empty']]   
                      end
                  else
                    [404, headers, ['404: ' + path]]
                  end
                end
              end
              
3. И теперь мы можем получать html-код по такому адресу: http://phantom.lunkserv.ru/html/http://report.obla...

4. Настраиваем httpd-сервер.

              server {
                  ...
                  if ( $args ~ _escaped_fragment_ ) {
                      rewrite ^(.*)$ /phantom-proxy$scheme://$host:$server_port$uri last;
                  }
                  location ^~ /phantom-proxy {
                      proxy_pass <a href="http://phantom.lunkserv.ru/html/;"> <a href="http://phantom.lunkserv.ru/html/;"> http://phantom.lunkserv.ru/html/;
                  }
                  ...
              }
              
5. Ну и нужно немного посыпать свои странички мета-тегом (https://developers.google.com/webmasters/ajax-craw...)

              <meta name="fragment" content="!">
              
Теперь должно работать.
