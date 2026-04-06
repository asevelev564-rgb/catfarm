# Kitten Empire: Crypto-Farm — Telegram Mini App

Telegram Mini App для управления виртуальной крипто-фермой котят с элементами экономической стратегии и play-to-earn механиками.

## Описание игры

**Kitten Empire** — это интерактивная мини-игра в Telegram, где игроки:

- Покупают и выращивают виртуальных котят
- Строят и улучшают фермерские постройки
- Участвуют в экономике токенов
- Выполняют ежедневные задания и квесты
- Соревнуются с другими игроками в таблице лидеров

Каждый котёнок имеет уникальные характеристики, влияющие на доходность фермы. Игроки могут торговать ресурсами, развивать инфраструктуру и участвовать в сезонных ивентах.

## Архитектура

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│    Frontend     │────▶│     Backend     │────▶│   PostgreSQL    │
│   (Next.js)     │◀────│    (FastAPI)    │◀────│      16         │
│  Port 3000      │     │  Port 8000      │     │  Port 5432      │
└─────────────────┘     └─────────────────┘     └─────────────────┘
        ▲                        ▲
        │                        │
   Telegram WebApp        Telegram Bot API
```

- **Frontend**: Next.js 14 (App Router) с TypeScript и Tailwind CSS
- **Backend**: FastAPI на Python 3.11+ с asyncpg для асинхронной работы с БД
- **База данных**: PostgreSQL 16 с миграциями через Alembic

## Предварительные требования

- [Docker](https://docs.docker.com/get-docker/) и Docker Compose v2+
- [Telegram Bot Token](https://t.me/BotFather) — создайте бота через @BotFather
- Node.js 18+ (для ручной настройки без Docker)
- Python 3.11+ (для ручной настройки без Docker)

## Быстрый старт

### Запуск через Docker Compose

```bash
# 1. Клонируйте репозиторий
git clone <repository-url>
cd XXXiii

# 2. Установите BOT_TOKEN (замените на свой токен)
export BOT_TOKEN="6530690581:AAGHtC-cN8y3LdlvxDXZyvRCcv7oIgSX2mA"

# 3. Запустите все сервисы
docker-compose up -d

# 4. Проверьте статус
docker-compose ps
```

Приложение будет доступно по адресам:

| Сервис     | URL                       |
|------------|---------------------------|
| Frontend   | http://localhost:3000     |
| Backend    | http://localhost:8000     |
| API Docs   | http://localhost:8000/docs|
| PostgreSQL | localhost:5432            |

### Остановка сервисов

```bash
docker-compose down          # Остановить контейнеры
docker-compose down -v       # Остановить и удалить данные
```

## Ручная настройка

### Backend

```bash
cd backend

# Создайте виртуальное окружение
python -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\Scripts\activate   # Windows

# Установите зависимости
pip install -r requirements.txt

# Настройте переменные окружения
cp .env.example .env
# Отредактируйте .env с вашими настройками

# Примените миграции
alembic upgrade head

# Запустите сервер
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend

```bash
cd frontend

# Установите зависимости
npm install

# Настройте переменные окружения
cp .env.example .env.local
# Отредактируйте .env.local

# Запустите в режиме разработки
npm run dev
```

## Переменные окружения

### Backend

| Переменная         | Описание                          | По умолчанию                                        |
|--------------------|-----------------------------------|-----------------------------------------------------|
| `DATABASE_URL`     | URL подключения к PostgreSQL      | `postgresql+asyncpg://postgres:postgres@localhost:5432/kitten_empire` |
| `BOT_TOKEN`        | Telegram Bot Token                | —                                                   |
| `SECRET_KEY`       | Ключ для подписи JWT/HMAC         | —                                                   |
| `ALGORITHM`        | Алгоритм шифрования               | `HS256`                                             |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | TTL токена (мин)       | `30`                                                |
| `REDIS_URL`        | URL подключения к Redis           | `redis://localhost:6379/0`                          |
| `RATE_LIMIT_PER_MINUTE` | Лимит запросов в минуту     | `60`                                                |

### Frontend

| Переменная              | Описание                        | По умолчанию              |
|-------------------------|---------------------------------|---------------------------|
| `NEXT_PUBLIC_API_URL`   | URL бэкенд API                  | `http://localhost:8000`   |
| `NEXT_PUBLIC_BOT_NAME`  | Имя Telegram бота               | —                         |

## API Endpoints

### Аутентификация

| Метод  | Endpoint               | Описание                           |
|--------|------------------------|------------------------------------|
| POST   | `/api/auth/telegram`   | Валидация Telegram initData        |
| POST   | `/api/auth/refresh`    | Обновление access токена           |

### Котята

| Метод  | Endpoint                   | Описание                       |
|--------|----------------------------|--------------------------------|
| GET    | `/api/kittens`             | Список котят игрока            |
| GET    | `/api/kittens/{id}`        | Информация о котёнке           |
| POST   | `/api/kittens/purchase`    | Покупка нового котёнка         |
| POST   | `/api/kittens/{id}/feed`   | Покормить котёнка              |
| POST   | `/api/kittens/{id}/upgrade`| Улучшить котёнка               |

### Ферма

| Метод  | Endpoint                 | Описание                         |
|--------|--------------------------|----------------------------------|
| GET    | `/api/farm`              | Состояние фермы                  |
| POST   | `/api/farm/build`        | Построить здание                 |
| POST   | `/api/farm/upgrade/{id}` | Улучшить здание                  |

### Экономика

| Метод  | Endpoint               | Описание                           |
|--------|------------------------|------------------------------------|
| GET    | `/api/economy/balance` | Баланс игрока                      |
| GET    | `/api/economy/history` | История транзакций                 |
| POST   | `/api/economy/withdraw`| Вывод токенов                      |

### Задания и рейтинг

| Метод  | Endpoint               | Описание                           |
|--------|------------------------|------------------------------------|
| GET    | `/api/quests`          | Список активных заданий            |
| POST   | `/api/quests/{id}/claim`| Получить награду за задание       |
| GET    | `/api/leaderboard`     | Таблица лидеров                    |

## Схема базы данных

```sql
-- Пользователи
CREATE TABLE users (
    id              BIGSERIAL PRIMARY KEY,
    telegram_id     BIGINT UNIQUE NOT NULL,
    username        VARCHAR(255),
    balance         NUMERIC(20, 8) DEFAULT 0,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Котята
CREATE TABLE kittens (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT REFERENCES users(id) ON DELETE CASCADE,
    name            VARCHAR(100) NOT NULL,
    breed           VARCHAR(50) NOT NULL,
    level           INT DEFAULT 1,
    experience      INT DEFAULT 0,
    hunger          INT DEFAULT 100,
    happiness       INT DEFAULT 100,
    productivity    NUMERIC(10, 4) DEFAULT 1.0,
    last_fed_at     TIMESTAMP,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Здания фермы
CREATE TABLE buildings (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT REFERENCES users(id) ON DELETE CASCADE,
    building_type   VARCHAR(50) NOT NULL,
    level           INT DEFAULT 1,
    production_rate NUMERIC(10, 4) DEFAULT 1.0,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Транзакции
CREATE TABLE transactions (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT REFERENCES users(id),
    type            VARCHAR(50) NOT NULL,   -- purchase, reward, feed, withdraw
    amount          NUMERIC(20, 8) NOT NULL,
    reference_id    BIGINT,
    idempotency_key UUID UNIQUE,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Задания
CREATE TABLE quests (
    id              BIGSERIAL PRIMARY KEY,
    title           VARCHAR(255) NOT NULL,
    description     TEXT,
    reward_amount   NUMERIC(20, 8) NOT NULL,
    quest_type      VARCHAR(50) NOT NULL,
    requirement     JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Выполненные задания
CREATE TABLE user_quests (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT REFERENCES users(id),
    quest_id        BIGINT REFERENCES quests(id),
    progress        INT DEFAULT 0,
    completed       BOOLEAN DEFAULT FALSE,
    claimed_at      TIMESTAMP,
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, quest_id)
);
```

## Экономическая модель

Распределение доходов от внутриигровых транзакций:

```
┌───────────────────────────────────────────────────┐
│                 100% от транзакции                 │
├───────────────┬───────────────┬───────────────────┤
│  Платформа    │   Владелец    │   Тех. расходы    │
│    30%        │     10%       │      10%          │
├───────────────┴───────────────┴───────────────────┤
│           Игровой фонд (50%)                       │
├───────────────────────────────────────────────────┤
│     Стоимость кормления котят: 40% от фонда       │
│     Награды за задания:        35% от фонда       │
│     Бонусы и события:          25% от фонда       │
└───────────────────────────────────────────────────┘
```

### Подробное описание

| Категория          | Процент | Назначение                                      |
|--------------------|---------|-------------------------------------------------|
| Платформа          | 30%     | Комиссия платформы Telegram                     |
| Владелец проекта   | 10%     | Доход разработчика/владельца                    |
| Тех. расходы       | 10%     | Серверы, API, инфраструктура                    |
| Игровой фонд       | 50%     | Ресурсы для игровой экономики                    |
| → Кормление        | 40%     | Стоимость поддержания котят в активном состоянии|
| → Задания          | 35%     | Награды за выполнение квестов и заданий         |
| → События          | 25%     | Сезонные ивенты, бонусы, розыгрыши              |

### Балансирование

- Инфляция контролируется через динамическую корректировку наград
- Каждый котёнок имеет базовую доходность `productivity × level × breed_multiplier`
- Кормление снижает `hunger`; при `hunger < 20` доходность падает на 50%
- Стоимость улучшений растёт экспоненциально: `base_cost × level^1.5`

## Безопасность

### Аутентификация и авторизация

- **HMAC-SHA256**: Валидация `initData` от Telegram WebApp с проверкой подписи
- **JWT-токены**: Access/Refresh токены для API-запросов
- **Проверка bot_token**: Каждый запрос initData проверяется на соответствие боту

### Защита от атак

- **Rate Limiting**: Ограничение запросов (60 запросов/мин на пользователя)
- **Idempotency**: Уникальные ключи идемпотентности для финансовых операций
- **Anti-cheat**: Серверная валидация всех игровых действий
  - Проверка баланса перед покупкой
  - Валидация времени между кормлениями (cooldown)
  - Ограничение скорости накопления опыта
- **Input Sanitization**: Экранирование входных данных для защиты от XSS
- **SQL Injection Protection**: Параметризованные запросы через SQLAlchemy ORM
- **CORS**: Настроен разрешённый список origins

### Валидация Telegram initData

```python
import hmac
import hashlib
from urllib.parse import parse_qs

def validate_telegram_init_data(init_data: str, bot_token: str) -> bool:
    data = dict(parse_qs(init_data))
    hash_value = data.pop('hash', [None])[0]
    data_check_string = '\n'.join(f'{k}={v[0]}' for k, v in sorted(data.items()))
    secret_key = hmac.new(b'WebAppData', bot_token.encode(), hashlib.sha256).digest()
    computed_hash = hmac.new(secret_key, data_check_string.encode(), hashlib.sha256).hexdigest()
    return hmac.compare_digest(computed_hash, hash_value)
```

## Заметки по разработке

### Структура проекта

```
XXXiii/
├── backend/
│   ├── app/
│   │   ├── api/            # Роутеры API
│   │   ├── core/           # Конфигурация, безопасность
│   │   ├── models/         # SQLAlchemy модели
│   │   ├── schemas/        # Pydantic схемы
│   │   ├── services/       # Бизнес-логика
│   │   └── main.py         # Точка входа FastAPI
│   ├── alembic/            # Миграции БД
│   ├── tests/              # Тесты
│   └── requirements.txt
├── frontend/
│   ├── src/
│   │   ├── app/            # Next.js App Router
│   │   ├── components/     # React компоненты
│   │   ├── hooks/          # Кастомные хуки
│   │   ├── lib/            # Утилиты и API клиент
│   │   └── types/          # TypeScript типы
│   ├── public/
│   └── package.json
├── docker-compose.yml
└── README.md
```

### Команды для разработки

```bash
# Запуск тестов backend
docker-compose exec backend pytest

# Линтинг backend
docker-compose exec backend ruff check app/

# Линтинг frontend
docker-compose exec frontend npm run lint

# Генерация миграции
docker-compose exec backend alembic revision --autogenerate -m "description"

# Применение миграций
docker-compose exec backend alembic upgrade head

# Просмотр логов
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Технологический стек

| Слой         | Технология                       |
|--------------|----------------------------------|
| Frontend     | Next.js 14, React 18, TypeScript |
| Styling      | Tailwind CSS, Shadcn UI          |
| State        | Zustand / Redux Toolkit          |
| Backend      | FastAPI, Python 3.11             |
| ORM          | SQLAlchemy 2.0 (async)           |
| Миграции     | Alembic                          |
| Валидация    | Pydantic v2                      |
| База данных  | PostgreSQL 16                    |
| Кэширование  | Redis                            |
| Контейнеры   | Docker, Docker Compose           |
| Бот          | python-telegram-bot / aiogram    |
