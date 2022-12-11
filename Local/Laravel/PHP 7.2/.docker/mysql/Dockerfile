FROM mysql:5.7
RUN touch /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "innodb_strict_mode = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "innodb_log_file_size = 1024M" >> /etc/mysql/mysql.conf.d/mysqld.cnf