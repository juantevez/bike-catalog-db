-- V4__create_theft_matching.sql
-- ============================================================
-- DOMINIO: Reportes de robo y matching
-- ============================================================

-- Reportes de robo
CREATE TABLE theft_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bicycle_id UUID NOT NULL REFERENCES registered_bicycles(id),
    reported_by_user_id UUID NOT NULL,

    -- Snapshot inmutable de la bici al momento del reporte
    bicycle_snapshot JSONB NOT NULL,

    -- Datos del incidente
    theft_date DATE NOT NULL,
    theft_time_range VARCHAR(50),

    -- Ubicación
    location_address TEXT,
    location_city VARCHAR(100),
    location_province VARCHAR(100),
    location_country VARCHAR(50) DEFAULT 'Argentina',
    location_coords POINT,
    location_type VARCHAR(50),
    -- 'street', 'home', 'work', 'bike_parking', 'event'

    -- Circunstancias
    lock_type VARCHAR(50),
    lock_brand VARCHAR(100),
    how_stolen TEXT,

    -- Denuncia policial
    police_report_number VARCHAR(100),
    police_station VARCHAR(255),
    police_report_date DATE,
    police_report_photo_url TEXT,

    -- Estado
    status VARCHAR(20) DEFAULT 'ACTIVE',
    -- 'ACTIVE', 'POSSIBLE_MATCH', 'FOUND', 'RECOVERED', 'CLOSED'

    recovery_date DATE,
    recovery_notes TEXT,

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_theft_reports_bicycle ON theft_reports(bicycle_id);
CREATE INDEX idx_theft_reports_status ON theft_reports(status);
CREATE INDEX idx_theft_reports_city ON theft_reports(location_city);
CREATE INDEX idx_theft_reports_date ON theft_reports(theft_date);
CREATE INDEX idx_theft_reports_snapshot ON theft_reports USING GIN(bicycle_snapshot);

-- Publicaciones detectadas (scraper)
CREATE TABLE detected_listings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Origen
    platform VARCHAR(50) NOT NULL,
    platform_listing_id VARCHAR(255),
    original_url TEXT NOT NULL,

    -- Datos extraídos
    title TEXT,
    description TEXT,
    price DECIMAL(12,2),
    currency VARCHAR(10),

    -- Vendedor
    seller_name VARCHAR(255),
    seller_profile_url TEXT,
    seller_phone VARCHAR(50),

    -- Ubicación
    location_raw TEXT,
    location_city VARCHAR(100),
    location_province VARCHAR(100),

    -- Imágenes
    images JSONB DEFAULT '[]',
    /*
    [
      {"original_url": "...", "local_path": "...", "analyzed": true}
    ]
    */

    -- Features extraídos por AI
    extracted_features JSONB DEFAULT '{}',
    /*
    {
      "detected_brand": "Trek",
      "detected_model": "Domane",
      "brand_confidence": 0.85,
      "detected_type": "road",
      "detected_colors": ["black", "red"],
      "color_confidence": 0.92,
      "detected_components": {
        "wheels_profile": "high",
        "saddle_color": "white"
      },
      "suspicious_signals": [
        "no_serial_visible",
        "price_below_market",
        "new_account"
      ],
      "suspicion_score": 0.7
    }
    */

    -- Estado
    processing_status VARCHAR(20) DEFAULT 'PENDING',
    -- 'PENDING', 'PROCESSING', 'ANALYZED', 'MATCHED', 'DISMISSED', 'ERROR'

    listing_date DATE,
    scraped_at TIMESTAMP DEFAULT NOW(),
    analyzed_at TIMESTAMP,

    -- Dedup
    content_hash VARCHAR(64),

    UNIQUE(platform, platform_listing_id)
);

CREATE INDEX idx_listings_platform ON detected_listings(platform);
CREATE INDEX idx_listings_status ON detected_listings(processing_status);
CREATE INDEX idx_listings_city ON detected_listings(location_city);
CREATE INDEX idx_listings_date ON detected_listings(scraped_at);
CREATE INDEX idx_listings_features ON detected_listings USING GIN(extracted_features);
CREATE INDEX idx_listings_hash ON detected_listings(content_hash);

-- Matches potenciales
CREATE TABLE potential_matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    theft_report_id UUID NOT NULL REFERENCES theft_reports(id),
    detected_listing_id UUID NOT NULL REFERENCES detected_listings(id),

    -- Scores
    overall_score DECIMAL(5,4) NOT NULL,

    match_details JSONB NOT NULL,
    /*
    {
      "brand": {"score": 1.0, "expected": "Trek", "found": "Trek"},
      "model": {"score": 0.8, "expected": "Domane SL5", "found": "Domane"},
      "colors": {"score": 0.9, "expected": ["black","red"], "found": ["black","red"]},
      "components": {
        "wheels": {"score": 0.85, "note": "perfil alto coincide"},
        "saddle": {"score": 0.7, "note": "color similar"}
      },
      "visual_similarity": {"score": 0.78, "method": "embedding_cosine"},
      "location": {"score": 0.6, "distance_km": 15},
      "timing": {"score": 0.9, "days_since_theft": 3}
    }
    */

    -- Workflow
    status VARCHAR(20) DEFAULT 'PENDING',
    -- 'PENDING', 'NOTIFIED', 'REVIEWING', 'CONFIRMED', 'FALSE_POSITIVE', 'REPORTED'

    user_notified_at TIMESTAMP,
    user_response VARCHAR(20),
    -- 'CONFIRMED', 'NOT_MINE', 'UNSURE'
    user_response_at TIMESTAMP,
    user_notes TEXT,

    -- Si se reportó
    reported_to_police BOOLEAN DEFAULT FALSE,
    police_report_date TIMESTAMP,

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(theft_report_id, detected_listing_id)
);

CREATE INDEX idx_matches_theft ON potential_matches(theft_report_id);
CREATE INDEX idx_matches_listing ON potential_matches(detected_listing_id);
CREATE INDEX idx_matches_score ON potential_matches(overall_score DESC);
CREATE INDEX idx_matches_status ON potential_matches(status);
