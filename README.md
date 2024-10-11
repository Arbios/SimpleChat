# SimpleChat - iOS Code Challenge

SimpleChat - это простое чат-приложение, разработанное в рамках тестового задания. Пользователь может отправлять сообщения, и получать в ответ перевернутый текст.

![demo](https://github.com/user-attachments/assets/8da6314d-0930-4bda-abcb-93ec554a1bf1)


- [x] Архитектура **VIPER**
- [x] Использование **UICollectionView** с **UICollectionViewDiffableDataSource** и **UICollectionViewCompositionalLayout**
- [x] Реверс строки происходит в **фоновом потоке** с использованием **structured concurrency**. Для имитации ответа от сервера добавил задержку в 0.5 секунд
- [x] Максимальное ограничение введенного текста до 300 символов
- [x] Реагирование на появление клавиатуры и скрытие (по тапу) 

## Что можно было бы добавить

1. [ ] Многострочный текст. Использование **UITextView** породило бы больше проблем, поэтому для начала тестового решил сделать на основе **UITextField**
2. [ ] Использование SnapKit или чего то подобно сильно упростило бы читаемость кода но решил не прибегать к зависимостям
3. [ ] Вынести логику переворачивания текста в отдельный сервис, но в рамках такого простого приложения это излишне

## Стэк

- Swift 5
- UICollectionView (UICollectionViewDiffableDataSource и UICollectionViewCompositionalLayout)
- VIPER архитектура
- Structured Concurrency для обработки в фоновом потоке

## Как запустить проект

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/<your_username>/SimpleChat.git
