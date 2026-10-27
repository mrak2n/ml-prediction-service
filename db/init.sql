-- Инициализация БД ML Prediction Service
-- Выполняется на db-server от имени postgres: sudo -u postgres psql -f db/init.sql
-- Пароль НЕ хранится в репозитории. После выполнения задать его:
--   sudo -u postgres psql -c "\password ml_app"

-- База данных и пользователь приложения
CREATE DATABASE ml_predictions;
CREATE USER ml_app;

-- Минимальные права на уровне БД: только подключение
REVOKE ALL ON DATABASE ml_predictions FROM PUBLIC;
GRANT CONNECT ON DATABASE ml_predictions TO ml_app;

\c ml_predictions

-- Запрет создания объектов в схеме public для всех (актуально для PG < 15)
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO ml_app;

-- Таблица предсказаний модели
CREATE TABLE predictions (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    input_data JSONB NOT NULL,
    prediction JSONB NOT NULL,
    model_version VARCHAR(50) NOT NULL
);

-- Приложению только чтение и вставка
GRANT SELECT, INSERT ON predictions TO ml_app;
GRANT USAGE, SELECT ON SEQUENCE predictions_id_seq TO ml_app;
