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
    -- Milk stats (ONLY from milk_entries)
    COALESCE((
      SELECT SUM(quantity_litres)
      FROM milk_entries
      WHERE user_id = p_user_id
        AND shift = 'Morning'
        AND date = CURRENT_DATE
    ), 0) AS today_morning_milk,

    COALESCE((
      SELECT SUM(quantity_litres)
      FROM milk_entries
      WHERE user_id = p_user_id
        AND shift = 'Evening'
        AND date = CURRENT_DATE
    ), 0) AS today_evening_milk,

    COALESCE((
      SELECT SUM(quantity_litres)
      FROM milk_entries
      WHERE user_id = p_user_id
        AND date = CURRENT_DATE
    ), 0) AS today_total_milk,

    COALESCE((
      SELECT SUM(quantity_litres)
      FROM milk_entries
      WHERE user_id = p_user_id
        AND date >= date_trunc('month', CURRENT_DATE)
        AND date < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'
    ), 0) AS month_total_milk,

    -- Income stats (ONLY from milk_sales)
    COALESCE((
      SELECT SUM(total_amount)
      FROM milk_sales
      WHERE user_id = p_user_id
        AND date = CURRENT_DATE
    ), 0) AS today_income,

    COALESCE((
      SELECT SUM(total_amount)
      FROM milk_sales
      WHERE user_id = p_user_id
        AND date >= date_trunc('month', CURRENT_DATE)
        AND date < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'
    ), 0) AS month_income;
$$;
