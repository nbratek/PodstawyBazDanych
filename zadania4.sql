
select m.firstname, m.lastname
FROM member m
left JOIN adult a ON m.member_no = a.member_no
LEFT JOIN juvenile j ON j.member_no = m.member_no and j.adult_member_no = a.member_no
WHERE a.state IN ('AZ', 'CA')
    AND NOT EXISTS (
        SELECT 1
        FROM juvenile j_child
        WHERE j_child.adult_member_no = a.member_no
            AND j_child.birth_date >= '2000-10-14'
    )
GROUP BY m.member_no, m.firstname, m.lastname
ORDER BY m.lastname, m.firstname;

--

select m.firstname, m.lastname, a.state, a.city, a.street, isnull(t.title, 'brak')
from adult a
left join member m on a.member_no = m.member_no
left join juvenile j on m.member_no = j.member_no and j.adult_member_no = a.member_no
left join loan l on m.member_no = l.member_no
left join title t on l.title_no = t.title_no
where a.state = 'AZ'

--
select t.title
from title t
where t.title_no not in (select t.title_no
                             FROM title t
                                 left join item i on t.title_no = i.title_no
                                 left join reservation r on i.isbn = r.isbn
                                 left join member m on r.member_no = m.member_no
                                 left join adult a on m.member_no = a.member_no
                                 left  join juvenile j on j.member_no = m.member_no and j.adult_member_no = a.member_no
                                 where a.state = 'AZ')





--

select m.firstname, m.lastname,isnull(title, 'brak')
from adult a
left join member m on a.member_no = m.member_no
left join reservation r on m.member_no = r.member_no
left join item i on r.isbn = i.isbn
left join title t on i.title_no = t.title_no
where a.state = 'AZ'
order by m.lastname, m.firstname

--
select distinct m.firstname, m.lastname, lh.in_date, t.title
from adult a
left join member m on a.member_no = m.member_no
left join loan l on m.member_no = l.member_no
left join title t on l.title_no = t.title_no
left join loanhist lh on t.title_no = lh.title_no
left  join juvenile j on j.member_no = m.member_no and j.adult_member_no = a.member_no
where (MONTH(in_date) = 12) and (day(in_date) = 14) and (YEAR(in_date) = 2001)
  and t.title = 'Walking'