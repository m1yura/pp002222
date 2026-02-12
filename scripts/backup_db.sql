-- Полный бэкап базы данных
pg_dump -U postgres -h localhost interior_design_db > backup_interior_design_$(date +%Y%m%d_%H%M%S).sql

-- Бэкап только схемы
pg_dump -U postgres -h localhost -s interior_design_db > schema_backup.sql

-- Бэкап только данных
pg_dump -U postgres -h localhost -a interior_design_db > data_backup.sql