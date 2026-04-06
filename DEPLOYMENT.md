# Руководство по деплою Kitten Empire на Railway

## 1. Регистрация на Railway

Перейдите на [railway.app](https://railway.app) и зарегистрируйтесь через GitHub аккаунт.

## 2. Создание PostgreSQL базы данных

1. Нажмите New Project
2. Выберите Add PostgreSQL
3. Дождитесь создания базы данных
4. Скопируйте переменную DATABASE_URL (формат: postgresql://...)

## 3. Деплой бэкенда

1. Нажмите New Project
2. Выберите Add GitHub repo или Empty project
3. Нажмите Add Service и выберите Docker
4. Настройте сервис:
   - Root Directory: backend
   - Start Command: оставьте пустым (указан в Dockerfile)
5. Добавьте Environment Variables:
   - DATABASE_URL: полная строка подключения из PostgreSQL сервиса (начинается с postgresql://)
   - BOT_TOKEN: (получите от BotFather в Telegram)
   - JWT_SECRET: (любая случайная строка)

**Важно:** Railway автоматически предоставляет переменную PORT. Start Command не нужно указывать в UI, так как он уже прописан в Dockerfile.

## 4. Получение URL бэкенда

1. После деплоя скопируйте URL сервиса (формат: https://имя-проекта.railway.app)
2. Добавьте /docs в конец URL для проверки API документации

## 5. Настройка Vercel фронтенда

1. Перейдите в настройки проекта на Vercel
2. Добавьте Environment Variable:
   - NEXT_PUBLIC_API_URL = (URL бэкенда из Railway)
3. Передеплойте проект

## Просмотр логов

1. В панели Railway выберите ваш проект
2. Нажмите на сервис бэкенда
3. Перейдите на вкладку Deployments
4. Выберите активный деплой и нажмите View Logs

## Подключение к базе данных

Для подключения к PostgreSQL используйте:
-psql $DATABASE_URL

Или используйте любой PostgreSQL клиент (DBeaver, pgAdmin) с параметрами из DATABASE_URL.

## Устранение неполадок

### Ошибка подключения к базе данных
- Убедитесь что DATABASE_URL скопирована корректно
- Проверьте что бэкенд запущен после создания базы данных

### Ошибка 502 Bad Gateway
- Проверьте логи в Railway
- Убедитесь что Start Command соответствует формату: uvicorn app.main:app --host 0.0.0.0 --port $PORT

### Фронтенд не видит API
- Проверьте что NEXT_PUBLIC_API_URL заканчивается на / (https://api.example.railway.app/)
- Передеплойте фронтенд после изменения переменных

### Бот не работает
- Проверьте что BOT_TOKEN корректен
- Убедитесь что вебхук настроен на правильный URL
