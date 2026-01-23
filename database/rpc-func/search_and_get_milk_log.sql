CREATE OR REPLACE FUNCTION search_milk_log_cursor(
  p_user_id UUID,
  p_limit INT DEFAULT 10,
  p_search TEXT DEFAULT NULL,
  p_shift TEXT DEFAULT NULL,
  p_last_created_at TIMESTAMP DEFAULT NULL,
  p_last_id UUID DEFAULT NULL,
  p_sort_by_quantity BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
  id UUID,
  user_id UUID,
  cattle_id UUID,
  date DATE,
  shift TEXT,
  quantity_litres NUMERIC,
  notes TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  cattle JSON
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    me.id,
    me.user_id,
    me.cattle_id,
    me.date,
    me.shift,
    me.quantity_litres,
    me.notes,
    me.created_at,
    me.updated_at,
    json_build_object(
      'id', c.id,
      'name', c.name,
      'tag_id', c.tag_id,
      'breed', c.breed,
      'image_url', c.image_url
    ) AS cattle
  FROM milk_entries me
  JOIN cattle c ON c.id = me.cattle_id
  WHERE me.user_id = p_user_id
    AND (p_shift IS NULL OR me.shift = p_shift)
    AND (
      p_search IS NULL OR
      c.name ILIKE '%' || p_search || '%' OR
      c.tag_id ILIKE '%' || p_search || '%'
    )
    AND (
      p_last_created_at IS NULL
      OR (
        me.created_at < p_last_created_at
        OR (me.created_at = p_last_created_at AND me.id < p_last_id)
      )
    )
  ORDER BY
    CASE WHEN p_sort_by_quantity THEN me.quantity_litres END DESC,
    me.created_at DESC,
    me.id DESC
  LIMIT p_limit;
END;
$$;
