-- Полная информация по проекту
SELECT
    p.id,
    p.name AS project_name,
    c.contact_person AS client,
    u.full_name AS designer,
    p.status,
    p.start_date,
    p.deadline,
    p.budget,
    COUNT(DISTINCT ps.id) AS stages_count,
    COUNT(DISTINCT f.id) AS files_count,
    e.total_amount AS estimate_amount,
    SUM(i.amount) FILTER (WHERE i.payment_status = 'оплачен') AS paid_amount
FROM projects p
LEFT JOIN clients c ON p.client_id = c.id
LEFT JOIN users u ON p.designer_id = u.id
LEFT JOIN project_stages ps ON p.id = ps.project_id
LEFT JOIN files f ON p.id = f.project_id
LEFT JOIN estimates e ON p.id = e.project_id
LEFT JOIN invoices i ON p.id = i.project_id
WHERE p.id = 1
GROUP BY p.id, p.name, c.contact_person, u.full_name, p.status,
         p.start_date, p.deadline, p.budget, e.total_amount;