# Мониторинг процесса `test` в Linux

##  Описание

Скрипт проверяет каждую минуту:
- Запущен ли процесс с именем `test`.
- Если запущен — отправляет HTTPS-запрос на `https://test.com/monitoring/test/api`.
- Если процесс был перезапущен (PID изменился) — записывает событие в лог `/var/log/monitoring.log`.
- Если HTTPS-эндпоинт недоступен — также записывает ошибку в лог.
- Если процесс не запущен — ничего не делает.

>  Примечание: по состоянию на момент тестирования, эндпоинт `https://test.com/monitoring/test/api` недоступен и возвращает блокировку от Cloudflare. Скрипт корректно обрабатывает такие ошибки и логирует их.


##  Установка

1. Копируем скрипт:

   ```bash
   sudo cp scripts/monitor-test.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/monitor-test.sh
  
2. Установка systemd-юнитов:
   
   ```bash
   sudo cp systemd/monitor-test.* /etc/systemd/system/

4. Создаём директорию для состояния (PID-файл):

   ```bash
   sudo mkdir -p /var/lib/monitoring

6. Активирование и запуск таймер:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now monitor-test.timer

8. Логи:

   ```bash
   /var/log/monitoring.log
