# ARGS
CURRENT_EMAIL=$1
NEW_EMAIL=$2

echo
cat << EOF
update users_login_providers set unique_id = '$NEW_EMAIL' where user_id in (select id from users where email = '$CURRENT_EMAIL');
update users set email = '$NEW_EMAIL' where id in (select id from users where email = '$CURRENT_EMAIL');
EOF
echo
