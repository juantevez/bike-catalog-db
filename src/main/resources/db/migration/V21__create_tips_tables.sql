-- V21__create_tips_tables.sql

CREATE TABLE tip_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theft_report_id UUID NOT NULL REFERENCES theft_reports(id) ON DELETE CASCADE,
    token VARCHAR(20) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT true,
    expires_at TIMESTAMP,
    scan_count INT NOT NULL DEFAULT 0,
    last_scanned_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_token_format CHECK (token ~ '^[a-zA-Z0-9]{6,20}$')
);

CREATE INDEX idx_tip_tokens_token ON tip_tokens(token);
CREATE INDEX idx_tip_tokens_report ON tip_tokens(theft_report_id);
CREATE INDEX idx_tip_tokens_active ON tip_tokens(is_active) WHERE is_active = true;

CREATE TABLE anonymous_tips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_id UUID NOT NULL REFERENCES tip_tokens(id),
    theft_report_id UUID NOT NULL REFERENCES theft_reports(id),

    -- Sighting details
    sighting_date DATE,
    sighting_time_approx VARCHAR(50),

    -- Location (embedded TheftLocation)
    sighting_locality_id INT REFERENCES localities(id),
    sighting_street_type VARCHAR(20),
    sighting_street_name VARCHAR(200),
    sighting_street_number VARCHAR(20),
    sighting_intersection VARCHAR(200),
    sighting_reference VARCHAR(500),
    sighting_latitude DOUBLE PRECISION,
    sighting_longitude DOUBLE PRECISION,
    sighting_location_precision VARCHAR(20),

    -- Description
    description TEXT NOT NULL,

    -- Informant contact (optional)
    informant_contact VARCHAR(255),
    wants_reply BOOLEAN DEFAULT false,

    -- Metadata
    submitted_from_ip VARCHAR(45),
    user_agent TEXT,

    -- Status
    status VARCHAR(30) NOT NULL DEFAULT 'NEW',
    read_at TIMESTAMP,

    -- Audit
    submitted_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_tip_status CHECK (status IN ('NEW', 'READ', 'REPLIED', 'CONVERTED_TO_SIGHTING'))
);

CREATE INDEX idx_anonymous_tips_report ON anonymous_tips(theft_report_id);
CREATE INDEX idx_anonymous_tips_token ON anonymous_tips(token_id);
CREATE INDEX idx_anonymous_tips_status ON anonymous_tips(status);
CREATE INDEX idx_anonymous_tips_unread ON anonymous_tips(theft_report_id, status) WHERE status = 'NEW';
