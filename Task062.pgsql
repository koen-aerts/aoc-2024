create or replace function calculate2()
returns bigint
language plpgsql    
as $$
declare
    tot_wins bigint;
    win bigint;
    ms bigint;
    dist bigint;
begin

    select cast(regexp_replace(trim(readings), ' +', '', 'g') as bigint) into ms
    from races
    where unit = 'Time';

    select cast(regexp_replace(trim(readings), ' +', '', 'g') as bigint) into dist
    from races
    where unit = 'Distance';

    tot_wins := 0;
    for i in 0..ms loop
        win := i * (ms - i);
        if (win > dist) then
            tot_wins := tot_wins + 1;
        end if;
    end loop;

    return tot_wins;
end;
$$

select calculate2();
