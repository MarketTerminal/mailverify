-- Migration 002: add next_retry_at to verifications so the worker can
-- back off rows that hit "no IP available" without busy-looping. See
-- backend/src/services/verifier.js (stamp on capacity-exhausted) and
-- backend/src/services/bulkProcessor.js (claimBatch filter).
-- Idempotent.

BEGIN;

ALTER TABLE verifications
  ADD COLUMN IF NOT EXISTS next_retry_at TIMESTAMPTZ;

COMMIT;

-- ROLLBACK (run manually if you need to undo this migration):
--   BEGIN;
--   ALTER TABLE verifications DROP COLUMN IF EXISTS next_retry_at;
--   COMMIT;
