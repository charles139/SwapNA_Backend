CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS attractions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    country VARCHAR(255) NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    created_by_user_id BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS user_rankings (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    attraction_id BIGINT NOT NULL,
    position INTEGER NOT NULL
);

WITH should_insert AS (
    SELECT NOT EXISTS (SELECT 1 FROM attractions) AS ok
)
INSERT INTO attractions (id, name, description, country, image_url, created_by_user_id)
SELECT v.id, v.name, v.description, v.country, v.image_url, v.created_by_user_id
FROM (
    VALUES
        (1, 'Grand Canyon', 'Massive canyon carved by the Colorado River in Arizona', 'US', 'https://example.com/grand-canyon.jpg', 1),
        (2, 'Yosemite Valley', 'Glacial valley known for granite cliffs and waterfalls in California', 'US', 'https://example.com/yosemite-valley.jpg', 1),
        (3, 'Yellowstone Geysers', 'World-famous geothermal geysers and hot springs in Wyoming', 'US', 'https://example.com/yellowstone-geysers.jpg', 1),
        (4, 'Niagara Falls', 'Powerful waterfalls on the border of New York and Canada', 'US', 'https://example.com/niagara-falls.jpg', 1),
        (5, 'Great Smoky Mountains', 'Misty mountain range with rich biodiversity in Tennessee and North Carolina', 'US', 'https://example.com/great-smoky-mountains.jpg', 1),
        (6, 'Denali', 'North America''s tallest mountain located in Alaska', 'US', 'https://example.com/denali.jpg', 1),
        (7, 'Zion Canyon', 'Deep red canyon with towering sandstone cliffs in Utah', 'US', 'https://example.com/zion-canyon.jpg', 1),
        (8, 'Bryce Canyon Hoodoos', 'Unique rock spires known as hoodoos in southern Utah', 'US', 'https://example.com/bryce-canyon.jpg', 1),
        (9, 'Arches National Park', 'Desert landscape famous for natural sandstone arches in Utah', 'US', 'https://example.com/arches.jpg', 1),
        (10, 'Glacier National Park', 'Mountainous wilderness with glaciers and alpine lakes in Montana', 'US', 'https://example.com/glacier-national-park.jpg', 1),
        (11, 'Lake Tahoe', 'Clear alpine lake in the Sierra Nevada mountains', 'US', 'https://example.com/lake-tahoe.jpg', 1),
        (12, 'Mount Rainier', 'Snow-covered volcanic peak in Washington state', 'US', 'https://example.com/mount-rainier.jpg', 1),
        (13, 'Crater Lake', 'Deep blue lake formed in a collapsed volcano in Oregon', 'US', 'https://example.com/crater-lake.jpg', 1),
        (14, 'Death Valley Sand Dunes', 'Expansive desert dunes in the hottest place in North America', 'US', 'https://example.com/death-valley.jpg', 1),
        (15, 'Redwood National Park', 'Forest of the tallest trees on Earth in northern California', 'US', 'https://example.com/redwoods.jpg', 1),
        (16, 'Antelope Canyon', 'Narrow sandstone slot canyon known for light beams in Arizona', 'US', 'https://example.com/antelope-canyon.jpg', 1),
        (17, 'Monument Valley', 'Iconic desert valley with towering sandstone buttes', 'US', 'https://example.com/monument-valley.jpg', 1),
        (18, 'Everglades Wetlands', 'Subtropical wetlands ecosystem in southern Florida', 'US', 'https://example.com/everglades.jpg', 1),
        (19, 'Great Salt Lake', 'Large saltwater lake in northern Utah', 'US', 'https://example.com/great-salt-lake.jpg', 1),
        (20, 'Badlands National Park', 'Eroded buttes and dramatic rock formations in South Dakota', 'US', 'https://example.com/badlands.jpg', 1),
        (21, 'Joshua Tree Desert', 'Unique desert landscape with twisted Joshua trees in California', 'US', 'https://example.com/joshua-tree.jpg', 1),
        (22, 'Acadia Coastline', 'Rocky Atlantic coastline and forests in Maine', 'US', 'https://example.com/acadia.jpg', 1),
        (23, 'Havasu Falls', 'Turquoise waterfall oasis within the Grand Canyon region', 'US', 'https://example.com/havasu-falls.jpg', 1),
        (24, 'Devils Tower', 'Striking volcanic rock monolith rising from Wyoming plains', 'US', 'https://example.com/devils-tower.jpg', 1),
        (25, 'Lake Powell', 'Massive reservoir with dramatic canyon scenery in Utah and Arizona', 'US', 'https://example.com/lake-powell.jpg', 1)
) AS v(id, name, description, country, image_url, created_by_user_id)
CROSS JOIN should_insert s
WHERE s.ok;

SELECT setval(
    pg_get_serial_sequence('attractions', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM attractions),
    true
);
