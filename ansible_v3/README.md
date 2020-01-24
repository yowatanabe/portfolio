①[file] - [database.yml] の以下の設定を環境に応じて設定すること

default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: #usernameを設定　　　　　　 ★ココ
  password: #passwordを設定　　　　　　 ★ココ
  socket: /var/lib/mysql/mysql.sock
  host: #RDSエンドポイントを記入　　　　　　 ★ココ
  
  
 
②[hosts] - [all_host] に設定対象のサーバの情報を設定すること

[web]
xxxx　　★ココ
  
