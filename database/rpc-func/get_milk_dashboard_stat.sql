CREATE OR REPLACE FUNCTION get_milk_dashboard_stats(p_user_id uuid)
RETURNS TABLE (
  today_morning_milk numeric,
  today_evening_milk numeric,
  today_total_milk numeric,
  month_total_milk numeric,
  today_income numeric,
  month_income numeric
)
LANGUAGE sql
AS $$
  SELECT
    -- Today production
    COALESCE(SUM(me.quantity_litres) FILTER (WHERE me.shift = 'Morning' AND me.date = CURRENT_DATE), 0),
    COALESCE(SUM(me.quantity_litres) FILTER (WHERE me.shift = 'Evening' AND me.date = CURRENT_DATE), 0),
    COALESCE(SUM(me.quantity_litres) FILTER (WHERE me.date = CURRENT_DATE), 0),

    -- Month production
    COALESCE(SUM(me.quantity_litres) FILTER (
      WHERE me.date >= date_trunc('month', CURRENT_DATE)
        AND me.date < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'
    ), 0),

    -- Today income
    COALESCE(SUM(ms.total_amount) FILTER (WHERE ms.date = CURRENT_DATE), 0),

    -- Month income
    COALESCE(SUM(ms.total_amount) FILTER (
      WHERE ms.date >= date_trunc('month', CURRENT_DATE)
        AND ms.date < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'
    ), 0)
  FROM user_profiles u
  LEFT JOIN milk_entries me ON me.user_id = u.id
  LEFT JOIN milk_sales ms ON ms.user_id = u.id
  WHERE u.id = p_user_id;
$$;
