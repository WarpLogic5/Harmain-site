-- Fix RLS policy for leads table to allow inserting contact form submissions
-- Run this in your Supabase SQL Editor

-- First, drop all existing policies on leads table to avoid conflicts
DROP POLICY IF EXISTS "anon insert with length guards" ON leads;
DROP POLICY IF EXISTS "limit anon inserts" ON leads;
DROP POLICY IF EXISTS "authenticated users can read leads" ON leads;
DROP POLICY IF EXISTS "Allow insert for anonymous users" ON leads;

-- Create a single, clear policy that allows anyone to insert
CREATE POLICY "Anyone can insert leads"
ON leads
FOR INSERT
TO anon, authenticated
WITH CHECK (
  char_length(name) > 0 AND char_length(name) <= 120 AND
  char_length(email) > 0 AND char_length(email) <= 320 AND
  char_length(message) > 0 AND char_length(message) <= 4000
);

-- Allow authenticated users to read leads
CREATE POLICY "Authenticated users can read leads"
ON leads
FOR SELECT
TO authenticated
USING (true);

-- Verify policies
SELECT schemaname, tablename, policyname, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'leads'
ORDER BY policyname;
