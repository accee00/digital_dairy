CREATE OR REPLACE FUNCTION search_cattle_with_monthly_milk_cursor(
  p_user_id UUID,
  p_limit INT DEFAULT 10,
  p_search TEXT DEFAULT NULL,
  p_last_created_at TIMESTAMP DEFAULT NULL,
  p_last_id UUID DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  user_id UUID,
  name TEXT,
  tag_id TEXT,
  image_url TEXT,
  breed TEXT,
  gender TEXT,
  dob DATE,
  calving_date DATE,
  status TEXT,
  notes TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  this_month_l NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id,
    c.user_id,
    c.name,
    c.tag_id,
    c.image_url,
    c.breed,
    c.gender,
    c.dob,
    c.calving_date,
    c.status,
    c.notes,
    c.created_at,
    c.updated_at,
    COALESCE(SUM(m.quantity_litres), 0) AS this_month_l
  FROM cattle c
  LEFT JOIN milk_entries m
    ON c.id = m.cattle_id
   AND m.date >= DATE_TRUNC('month', CURRENT_DATE)
   AND m.date < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
  WHERE c.user_id = p_user_id
    AND (
      p_search IS NULL OR
      c.name ILIKE '%' || p_search || '%' OR
      c.tag_id ILIKE '%' || p_search || '%'
    )
    AND (
      p_last_created_at IS NULL
      OR (
        c.created_at < p_last_created_at
        OR (c.created_at = p_last_created_at AND c.id < p_last_id)
      )
    )
  GROUP BY
    c.id, c.user_id, c.name, c.tag_id, c.image_url,
    c.breed, c.gender, c.dob, c.calving_date,
    c.status, c.notes, c.created_at, c.updated_at
  ORDER BY
    c.created_at DESC,
    c.id DESC
  LIMIT p_limit;
END;
$$;


CREATE INDEX idx_cattle_user_created
ON cattle (user_id, created_at DESC, id DESC);

CREATE INDEX idx_cattle_search
ON cattle USING gin (
  (name || ' ' || tag_id) gin_trgm_ops
);
