create or replace function calculate1()
returns integer
language plpgsql    
as $$
declare
    tot_wins integer;
    win integer;
    winways integer;
    pos integer;
    ms integer;
    dist integer;
    times text[];
    distances text[];
    timeval text;
begin

    select '{' || regexp_replace(trim(readings), ' +', ',', 'g') || '}' into times
    from races
    where unit = 'Time';

    select '{' || regexp_replace(trim(readings), ' +', ',', 'g') || '}' into distances
    from races
    where unit = 'Distance';

    winways := 1;
    pos := 0;
    foreach timeval in array times loop
        tot_wins := 0;
        pos := pos + 1;
        ms := cast(timeval as integer);
        dist := cast(distances[pos] as integer);
        for i in 0..ms loop
            win := i * (ms - i);
            if (win > dist) then
                tot_wins := tot_wins + 1;
            end if;
        end loop;
        winways := winways * tot_wins;
    end loop;

    return winways;
end;
$$

select calculate1();
