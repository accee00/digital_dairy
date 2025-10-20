-- Create RPC function to get milk log with cattle details
CREATE OR REPLACE FUNCTION get_milk_log_with_cattle(
  p_user_id UUID,
  p_page INT DEFAULT 0,
  p_limit INT DEFAULT 10
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
  -- Cattle details
  cattle JSON
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_offset INT;
BEGIN
  -- Calculate offset for pagination
  v_offset := p_page * p_limit;
  
  -- Return the result set with cattle details as JSON
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
    -- Build cattle JSON object
    json_build_object(
      'id', c.id,
      'user_id', c.user_id,
      'name', c.name,
      'breed', c.breed,
      'gender', c.gender,
      'dob', c.dob,
      'calving_date', c.calving_date,
      'status', c.status,
      'notes', c.notes,
      'created_at', c.created_at,
      'updated_at', c.updated_at,
      'tag_id', c.tag_id,
      'image_url', c.image_url
    ) as cattle
  FROM milk_entries me
  INNER JOIN cattle c ON me.cattle_id = c.id
  WHERE me.user_id = p_user_id
  ORDER BY me.created_at DESC
  LIMIT p_limit
  OFFSET v_offset;
END;
$$;