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
   
   sudo cp systemd/monitor-test.* /etc/systemd/system/

3. Создаём директорию для состояния (PID-файл):

   sudo mkdir -p /var/lib/monitoring

4. Активирование и запуск таймер:

   sudo systemctl daemon-reload
   sudo systemctl enable --now monitor-test.timer

5. Логи:

   /var/log/monitoring.log