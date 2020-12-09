# ARGS
EMAIL=$1

echo
cat << EOF
-- 1 => user_job_id, user_company_id
select user_company_id from users_jobs where user_id in (select id from users where email = '$EMAIL');

-- 2 => delete company related
delete from users_jobs where user_id in (select id from users where email = '$EMAIL');
delete from users_companies_to_companies_groups where user_company_id = {USER_COMPANY_ID};
delete from users_companies where id = {user_company_id};

-- 3 => delete users
delete from users_login_providers where user_id in (select id from users where email = '$EMAIL');
delete from users_login_ids where user_id in (select id from users where email = '$EMAIL');
delete from users where id in (select id from users where email = '$EMAIL');
EOF
echo
