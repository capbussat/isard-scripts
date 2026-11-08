DO $$                                                        
BEGIN
  IF (SELECT rolpassword IS NULL FROM pg_authid WHERE rolname = 'postgres') THEN 
    ALTER USER postgres WITH PASSWORD 'postgres'; SELECT rolpassword FROM pg_authid WHERE rolname = 'postgres';
  END IF;
END $$;
