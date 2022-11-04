-- Создание таблицы "Календарь" (справочник)
CREATE TABLE dim_calendar (
                           "id" SERIAL PRIMARY KEY
                           , "general_date" TIMESTAMP
                           , "year" NUMERIC
                           , "quarter" NUMERIC
                           , "month" NUMERIC
                           , "day" NUMERIC
                           , "hour" NUMERIC
                           , "minute" NUMERIC
                          );

                                 
-- Обогащение таблицы "Календарь" сущностями                                 
INSERT INTO dim_calendar (
                          "general_date"
                          , "year"
                          , "quarter"
                          , "month"
                          , "day"
                          , "hour"
                          , "minute"
                         )
SELECT calendar::TIMESTAMP 
      , EXTRACT (YEAR FROM calendar)
      , EXTRACT (QUARTER FROM calendar)
      , EXTRACT (MONTH FROM calendar)
      , EXTRACT (DAY FROM calendar)
      , EXTRACT (HOUR FROM calendar)
      , EXTRACT (MINUTE FROM calendar)
FROM GENERATE_SERIES (
                      TO_DATE('2016-08-01', 'yyyy-mm-dd'), 
                      TO_DATE('2016-10-31', 'yyyy-mm-dd'), 
                      INTERVAL '1 MINUTE'
                     ) AS calendar
ORDER BY calendar; 


-- Создание таблицы "Пассажиры" (справочник)
CREATE TABLE dim_passengers (
                             "id" SERIAL PRIMARY KEY
                             , "passenger_doc_num" VARCHAR(20) NOT NULL
                             , "passenger_name" TEXT 
                             , "phone" VARCHAR(30)
                             , "email" VARCHAR(50)
                            );
                
                            
-- Создание таблицы "Воздушное судно" (справочник)                     
CREATE TABLE dim_aircrafts (
                            "id" SERIAL PRIMARY KEY
                            , "aircraft_code" BPCHAR(3) NOT NULL CHECK ("aircraft_code" NOT LIKE '%[А-Я]%')
                            , "model" TEXT NOT NULL
                            , "range" INTEGER NOT NULL CHECK ("range" > 0)
                            , "count_seats" INTEGER NOT NULL CHECK ("count_seats" > 0)
                           );

                          
-- Создание таблицы "Аэропорт" (справочник)                    
CREATE TABLE dim_airports (
                           "id" SERIAL PRIMARY KEY
                           , "airport_code" BPCHAR(3) NOT NULL
                           , "airport_name" TEXT NOT NULL 
                           , "city" TEXT NOT NULL
                           , "longitude" FLOAT8 NOT NULL UNIQUE
                           , "latitude" FLOAT8 NOT NULL UNIQUE
                           , "timezone" TEXT NOT NULL
                          );

                         
-- Создание таблицы "Тариф" (справочник)                    
CREATE TABLE dim_tariff (
                         "id" SERIAL PRIMARY KEY
                         , "fare_conditions" VARCHAR(10) NOT NULL
                        );

                                  
                                  
-- Создание таблицы фактов                                
CREATE TABLE fact_flights ( 
                           "id" SERIAL PRIMARY KEY
                           , "passenger_id" INTEGER REFERENCES dim_passengers(id)
                           , "actual_departure_id" BIGINT REFERENCES dim_calendar(id)
                           , "actual_arrival_id" BIGINT REFERENCES dim_calendar(id)
                           , "delay_departure" NUMERIC
                           , "delay_arrival" NUMERIC
                           , "aircraft_id" INTEGER REFERENCES dim_aircrafts(id)
                           , "departure_airport_id" INTEGER REFERENCES dim_airports(id)
                           , "arrival_airport_id" INTEGER REFERENCES dim_airports(id)
                           , "tariff_id" INTEGER REFERENCES dim_tariff(id)
                          );
                                  