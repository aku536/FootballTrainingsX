FootballTrainingsX
===
Финальный проект для Школы iOS Сбербанка. Приложение для отслеживания футбольных тренировок. Помогает правильно выполнять упражнения и отслеживать свой прогресс.
***
Есть список тренировок. По нажатию на тренировку открывается вкладка с названием, подробным описанием и видео как правильно выполнять упражнение. Также, можно ввести количество выполненых подходов и количество успешных (например, 10 ударов по воротам, 5 точных ударов). 

Сохраненные данные можно посмотреть на вкладке Статистика. Там накапливается информация за всё время и показывается процент успешности выполнения упражнения.
***
### ToDo: 
1. Добавить больше упражнений
2. Добавить более подходящие видео для упражнений
3. Добиться покрытия всей логики Unit-тестами

### Реализовано:
* MVC
* TabBar
* NavigationController
* TableView
* Загрузка и отображение видео по сети
* Работа с AVFoundation
    * AVPlayer play/pause; 
    * GradientLayer для эффекта затенения
    * Анимирование появление элементов управления
    * Элементы управления плеером
        * Трекер прогресса видео
        * Возможность перемотки видео
        * Кнопка play/pause c Анимацией
* CoreData загрузка и сохранение данных из памяти, обнуление накопленных данных
* UserDefaults для определения первого запуска приложения на устройстве
* Unit-тесты
