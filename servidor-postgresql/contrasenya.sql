DO $$                                                        
BEGIN
  IF (SELECT rolpassword IS NULL FROM pg_authid WHERE rolname = 'postgres') THEN 
    ALTER USER postgres WITH PASSWORD 'postgres';
  END IF;
END $$;
