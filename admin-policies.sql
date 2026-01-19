-- Add RLS policies to allow authenticated users to read data in admin panel
-- Run this in your Supabase SQL Editor

-- First, check if policies already exist and drop them if needed
DROP POLICY IF EXISTS "authenticated users can read leads" ON leads;
DROP POLICY IF EXISTS "authenticated users can read all courses" ON courses;
DROP POLICY IF EXISTS "authenticated users can read all experiences" ON experiences;
DROP POLICY IF EXISTS "anon can read experiences" ON experiences;
DROP POLICY IF EXISTS "authenticated can insert experiences" ON experiences;
DROP POLICY IF EXISTS "authenticated can update experiences" ON experiences;
DROP POLICY IF EXISTS "anon can read demo slots" ON demo_slots;
DROP POLICY IF EXISTS "authenticated can insert demo slots" ON demo_slots;
DROP POLICY IF EXISTS "authenticated can update demo slots" ON demo_slots;
DROP POLICY IF EXISTS "allow anon read demo slots" ON demo_slots;
DROP POLICY IF EXISTS "anon read available slots" ON demo_slots;

-- Allow authenticated users to select (read) from leads table
CREATE POLICY "authenticated users can read leads"
ON leads
FOR SELECT
TO authenticated
USING (true);

-- Allow authenticated users to read courses (in addition to anon access)
CREATE POLICY "authenticated users can read all courses"
ON courses
FOR SELECT
TO authenticated
USING (true);

-- Allow authenticated users to read experiences (in addition to anon access)
CREATE POLICY "authenticated users can read all experiences"
ON experiences
FOR SELECT
TO authenticated
USING (true);

-- Allow public (anon) read so the home page can fetch experiences/education
CREATE POLICY "anon can read experiences"
ON experiences
FOR SELECT
TO anon
USING (true);

-- Allow authenticated users to insert and update experiences/education from the admin panel
CREATE POLICY "authenticated can insert experiences"
ON experiences
FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "authenticated can update experiences"
ON experiences
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Demo slots: allow public read (homepage) and authenticated add/update (admin)
CREATE POLICY "anon read available slots"
ON demo_slots
FOR SELECT
TO anon
USING (is_available = true);

CREATE POLICY "authenticated can insert demo slots"
ON demo_slots
FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "authenticated can update demo slots"
ON demo_slots
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Verify the policies were created
SELECT schemaname, tablename, policyname, roles, cmd, qual
FROM pg_policies
WHERE tablename IN ('leads', 'courses', 'experiences', 'demo_slots')
ORDER BY tablename, policyname;
