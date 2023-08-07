drop user schema_fnbk_ms_authn cascade;

create user schema_fnbk_ms_authn
    identified by schema_fnbk_ms_authn
    default tablespace users
    quota unlimited on users
    account unlock;

grant
    create session,
    create table,
    create procedure,
    create type,
    create trigger,
    create sequence
to
    schema_fnbk_ms_authn;

create table tuser (
    user_id    number           not null,
    username   varchar2(100)    not null,
    password   varchar2(100)    not null,
    created_us varchar2(100)    not null,
    updated_us varchar2(100)    not null,
    created_ts timestamp        not null,
    updated_ts timestamp        not null,

    constraint pk_tuser primary key (
        user_id
    ),

    constraint uq_username unique(
        username
    )
);

grant
    select,
    insert,
    update,
    delete
on
    tuser
to
    schema_fnbk_ms_authn;

drop sequence sq_user_id;

create sequence sq_user_id
    start with 1
    increment by 1;

-- mock data
declare
    v_username tuser.username%type;
    v_password tuser.password%type;
begin
    for i in 1 .. 1000
    loop
        if i < 10
        then
            v_username := 'user_000' || i;
            v_password := 'user_000' || i;
        elsif i < 100
        then
            v_username := 'user_00' || i;
            v_password := 'user_00' || i;
        elsif i < 1000
        then
            v_username := 'user_0' || i;
            v_password := 'user_0' || i;
        else
            v_username := 'user_' || i;
            v_password := 'user_' || i;
        end if;

        insert into tuser (
            user_id,
            username,
            password,
            created_us,
            updated_us,
            created_ts,
            updated_ts
        ) values (
            sq_user_id.nextval,
            v_username,
            v_password,
            'DEV_TM',
            'DEV_TM',
            systimestamp,
            systimestamp
        );
    end loop;
end;
/

