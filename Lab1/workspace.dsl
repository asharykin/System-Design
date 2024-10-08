workspace {

    model {
        user1 = person "Отправитель" "Отправляет посылки"
        
        user2 = person "Получатель" "Получает посылки"
        
        system = softwareSystem "Сервис доставки посылок" {
            description "Управляет аккаунтами пользователей, посылками и доставками"
        
            website = container "Веб-сайт" {
                description "Предоставляет графический интерфейс, взаимодействует с пользователями и бэкенд-приложением"
                technology "HTML, CSS, JavaScript"
            }
            
            group "Бэкенд-приложение на Spring Boot" {

                controller = container "Контроллеры" {
                    description "Принимают HTTP-запросы и отправляют HTTP-ответы с телом в формате JSON. Осуществляют десериализацию и сериализацию сущностей"
                    technology "Spring Web MVC"
                }
                
                service = container "Сервисы" {
                    description "Реализуют бизнес-логику над полученными сущностями"
                    technology "Spring"
                }
                
                repository = container "Репозитории" {
                    description "С помощью ORM-фреймворка составляют на основе полученных сущностей запросы к СУБД или создают сущности из данных от полученных ответов"
                    technology "Spring Data JPA"
                }
            }
            
            dbms = container "СУБД" {
                description "Хранит данные о сущностях в таблицах и управляет ими"
                technology "PostgreSQL"
            }
        }

        user1 -> website "Создаёт аккаунт, создаёт посылку, получает список посылок..." "Браузер"
        user2 -> website "Создаёт аккаунт, получает список посылок, получает информацию о доставке..." "Браузер"
        website -> controller "Отправляет запросы и получает ответы" "Fetch API, JSON, HTTP"
        controller -> service "Передают и получают сущности" "Java"
        service -> repository "Передают и получают сущности" "Java"
        repository -> dbms "Отправляют запросы и получают ответы" "Hibernate, JDBC"
    }

    views {
        themes default
        
        systemContext system {
            include *
            autoLayout lr
        }
        
        container system {
            include *
            autolayout lr
        }
        
        dynamic system "createUser" {
            description "Создание аккаунта пользователя"
            autolayout lr
            
            user1 -> website "Создаёт аккаунт"
            website -> controller "POST /users"
            controller -> service "Десериализует JSON в объект пользователя и передаёт"
            service -> repository "Проводит валидацию полей объекта пользователя и передаёт"
            repository -> dbms "INSERT INTO users \n VALUES (?, ?, ?)"
        }
    }
    
}