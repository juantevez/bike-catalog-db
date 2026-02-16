-- V23__create_tip_conversations.sql

CREATE TABLE tip_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tip_id UUID NOT NULL REFERENCES anonymous_tips(id) ON DELETE CASCADE,

    -- Message details
    sender_type VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,

    -- Timestamps
    sent_at TIMESTAMP NOT NULL DEFAULT NOW(),
    read_at TIMESTAMP,

    CONSTRAINT chk_sender_type CHECK (sender_type IN ('OWNER', 'INFORMANT'))
);

CREATE INDEX idx_tip_conversations_tip ON tip_conversations(tip_id);
CREATE INDEX idx_tip_conversations_unread ON tip_conversations(tip_id, read_at) WHERE read_at IS NULL;
CREATE INDEX idx_tip_conversations_sent ON tip_conversations(sent_at);
