dhcpc.rsh
===

Скрипт добавляет рекурсивные маршруты и входящие метки на основе дхчп клиента.
В dhcp-client ставите метрику 200 на главном, 250 на запасном. Скопируйте скрипт в script. Установите 
testip1,testip2 разные для каждого интерфейса. Установите recursivedistance 100 на главном, 150 на запасном.

TODO: 

* выкинуть скрипт в system scripts.
* расчитать метрику автоматом
* выделять тестовые ип из пула
