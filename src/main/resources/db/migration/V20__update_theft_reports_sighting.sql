-- =====================================================
-- Migration V20: Expand location fields
-- Already applied manually - this is for Flyway history only
-- =====================================================

-- This migration was applied manually.
-- Tables theft_reports and theft_sightings now have expanded location fields:
-- - theft_locality_id / sighting_locality_id (replaces theft_location_id / sighting_location_id)
-- - theft_street_type / sighting_street_type
-- - theft_street_name / sighting_street_name
-- - theft_street_number / sighting_street_number
-- - theft_intersection / sighting_intersection
-- - theft_reference / sighting_reference (replaces theft_address / sighting_address)
-- - theft_latitude / sighting_latitude
-- - theft_longitude / sighting_longitude
-- - theft_location_precision / sighting_location_precision

SELECT 1; -- No-op, changes already applied