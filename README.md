SF Labs Tamplier Tool
=====================

Генератор проектов на основе  **Bootstrap** ([iOS](https://github.com/sflabsorg/bootstrap-ios) / [Android](https://github.com/sflabsorg/bootstrap-android)).


tamplier
-----

Генерирует простые проекты на основе шаблонов **.templates**


Использование
-----

Установка

    brew tap sflabsorg/sf
    brew install tamplier

Генерация проекта по шаблону авторизации

    tamplier generate --auth --output ~/Desktop --name AwesomeProject
    
Генерация Swift Package с Swagger API по YML спецификации

    tamplier api --path {path_to_yml_spec_file} --output ~/Desktop/AwesomeProject


Разработка
-----

- Для разработки **шаблонов** и/или внесения изменений в **Boostrap** следует использовать ```Package.xcworkspace```
- Для создания шаблонов следует скопировать Authentication и изменить название проекта на свой
- Если хочется сделать начисто - структура шаблона должна повторять **Authentication** для корректной генерации проектов, а именно:
  - Название проекта = название шаблона
  - Корневая директория проекта = 'Application'
  - Инициализация Bootstrap в **main.swift**
  - Info.plist файл должен находиться в Supporting директории
  - В директории Supporting/Configuration должны находиться xcconfig и entitlements файлы
  - Все настройки проекта хранятся в xcconfig, без использования Xcode
- Следует не забыть добавить свой шаблон в **<bootstrap-path>/Sources/Tamplier/main.swift**
- После успешного создания шаблона его генерацию следует проврить локально, с помощью схемы **tamplier**
