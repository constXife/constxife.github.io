---
title: Crystal 0.26 на Raspberry PI (raspbian)
tags: rpi, crystal
category:
  name: Разработка
  icon: magic
date: 2018-10-16 00:34:00
-------------------------

Установка [Crystal 0.26](http://crystal-lang.org) на Raspberry PI (raspbian).

Решил я на выходных поиграться с Arduino и построением веб-интерфейса к моим механизмам на платформе Rasberry PI. 
Можно было бы наклепать сайтик на Ruby и не писать эту статью, но [по определенным причинам](#reason),
я решил делать веб-сайт на Crystal — компилируемым ruby-like языке. Засучил рукава, открыл гугл и наткнулся на отличный 
ответ на [stackoverflow](https://stackoverflow.com/questions/42796143/how-do-i-install-crystal-lang-on-rapsberry-pi), 
который мне здорово помог в моих изысканиях. Можно было бы удовлетвориться semi-официальному зеркалу Crystal и успокоиться,
благо он встал в RPi словно всегда там и стоял. Но так как в репозитории была старая версия, то [по определенным причинам](#reason), я решил пользоваться 
современнейшими технологиями и быть на острие прогресса, поэтому передо мной встала задача внедрить новейший Crystal 
в этот миниатюрно-мигающий, процессинговый оплот моих будущих экспериментов. Итоги моих мытарств я сейчас и изложу 
в кратком виде. 

В нашем распоряжении

- Компьютер с Debian GNU/Linux 9 (stretch), llvm-3.8
- Raspberry Pi Zero, Raspbian GNU/Linux 9 (stretch), llvm-3.8
- Решимость во что бы то ни стало пройти сквозь тернии к установленному Crystal-у

Общая схема действий такова: мы на нашем Debian скомпилируем object файл, перенесём его на raspbian, 
скомпилируем его там и наслаждаемся результатом. Самая главная мысль, которая проходит сквозь весь туториал — надо 
держать версии софта на обоих системах одинаковыми. Я кучу времени убил, пытаясь установить более новое ПО то тут, то там, 
но в итоге оставил софт, который уже был в пакетах. 

Сначала [установим](https://crystal-lang.org/docs/installation/on_debian_and_ubuntu.html) на наш Debian 
Crystal нужной версии. Далее нужно провести предварительные ласки для Debian и для raspbian в виде установки 
обязательного программного обеспечения, общий список которых находится — [тут](https://github.com/crystal-lang/crystal/wiki/All-required-libraries).

Принимаем во внимание, что нам не нужно ставить BOEHM GC из исходников, у нас этим занимается пакет *libgc-dev*, 
который нужно поставить, если его нет.

##### Debian

- Клонируем исходники crystal

```
user@debian ~/src $ git clone https://github.com/crystal-lang/crystal
```

```
user@debian ~/src $ cd crystal
```

- Переключаемся из мастера в стабильную ветку

```
user@debian ~/src/crystal $ git checkout 0.26.1
```

- Собираем объектный файл компилятора

```
user@debian ~/src/crystal $ make deps
```

```
user@debian ~/src/crystal $ ./bin/crystal build src/compiler/crystal.cr --cross-compile --target "armv6-unknown-linux-gnueabihf" --release -s -D without_openssl -D without_zlib
```

Если всё сделано правильно, то у нас в директории появится файл *crystal.o*. Половина дела сделана. Переходим к raspbian.

##### Raspbian

- Повторяем действия как на debian

```
user@raspbian ~/src $ git clone https://github.com/crystal-lang/crystal
``` 

```
user@raspbian ~/src $ cd crystal
```

```
user@raspbian ~/src/crystal $ git checkout 0.26.1
```

```
user@raspbian ~/src/crystal $ make deps
```

- Бережно переносим файл *crystal.o* на raspbian с debian.

```
user@raspbian ~/src/crystal $ scp user@debian:~/src/crystal/crystal.o .
```

- Я решил взять расположение файлов как в Debian, чтобы было удобнее пользоваться компилятором (это обусловлено 
динамической линковкой компилятора — ему потребуется доступ к библиотекам и исходникам)

```
user@raspbian ~/src/crystal $ mkdir -p /usr/share/crystal /usr/lib/crystal/bin
```

```
user@raspbian ~/src/crystal $ cp -R src /usr/share/crystal/src
```

- Компилируем! (обратите внимание, что строка линковки отличается от предлагаемой после создания crystal.o, потому что
у нас несколько другое расположение папок и файлов)

```
user@raspbian ~/src/crystal $ cc 'crystal.o' -o '/usr/lib/crystal/bin/crystal' -rdynamic /usr/share/crystal/src/llvm/ext/llvm_ext.o `/usr/bin/llvm-config-3.8 --libs --system-libs --ldflags 2> /dev/null` -lstdc++ -lpcre -lm -lgc -lpthread /usr/share/crystal/src/ext/libcrystal.a -levent -lrt -ldl -L/usr/lib -L/usr/local/lib
```

В идеале здесь у вас должен скомпилироваться компилятор, если нет, проверьте шаги ранее, а может я просто ошибся в 
последовательности действий или забыл что-то очень важное. Но, предположим, что всё идёт по плану. Дальше нужно дать доступ
другим пользователям до бинарника и добавить shards (bundler в кристальном мире).

- Забираем shell-обвязку к компилятору c Debian (из-за динамической линковки компилятора)

```
user@raspbian ~/src/crystal $ scp user@debian:/usr/bin/crystal /usr/bin/crystal
```

```
user@raspbian ~/src/crystal $ cd ..
```

```
user@raspbian ~/src $ git clone https://github.com/crystal-lang/shards.git
```

```
user@raspbian ~/src $ cd shards
```

```
user@raspbian ~/src/shards $ git checkout v0.8.1
```

```
user@raspbian ~/src/shards $ crystal build src/shards.cr -o /usr/lib/crystal/bin/shards --release
```

```
user@raspbian ~/src/shards $ ln -s /usr/lib/crystal/bin/shards /usr/bin
```

Вуаля. 

```
user@raspbian ~/src/shards $ crystal -v
```

```
user@raspbian ~/src/shards $ shards --version
```

##### Сноски

<p id="reason">* так как я люблю создавать себе проблемы на пустом месте</p>
