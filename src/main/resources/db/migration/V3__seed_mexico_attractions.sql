-- Adds 25 default Mexico attractions (IDs 51-75).
-- Uses a guard so this runs only if no Mexico defaults are present.
WITH should_insert_mx AS (
    SELECT NOT EXISTS (SELECT 1 FROM attractions WHERE country = 'MX') AS ok
)
INSERT INTO attractions (id, name, description, country, image_url, created_by_user_id)
SELECT v.id, v.name, v.description, v.country, v.image_url, v.created_by_user_id
FROM (
    VALUES
        (51, 'Copper Canyon', 'Massive canyon system in Chihuahua larger and deeper than the Grand Canyon', 'MX', 'https://example.com/copper-canyon.jpg', 1),
        (52, 'Sumidero Canyon', 'Towering canyon cliffs rising above the Grijalva River in Chiapas', 'MX', 'https://example.com/sumidero-canyon.jpg', 1),
        (53, 'Hierve el Agua', 'Petrified mineral waterfalls and natural pools in Oaxaca', 'MX', 'https://example.com/hierve-el-agua.jpg', 1),
        (54, 'Cenote Ik Kil', 'Deep natural limestone sinkhole filled with clear water in Yucatan', 'MX', 'https://example.com/cenote-ik-kil.jpg', 1),
        (55, 'Sian Ka''an Biosphere Reserve', 'Protected tropical wetlands and coral reef ecosystem in Quintana Roo', 'MX', 'https://example.com/sian-kaan.jpg', 1),
        (56, 'Monarch Butterfly Biosphere Reserve', 'Mountain forests where millions of monarch butterflies migrate each winter', 'MX', 'https://example.com/monarch-butterflies.jpg', 1),
        (57, 'Grutas de Tolantongo', 'Thermal spring pools and caves set into a canyon in Hidalgo', 'MX', 'https://example.com/tolantongo.jpg', 1),
        (58, 'Nevado de Toluca', 'Extinct volcano with crater lakes in central Mexico', 'MX', 'https://example.com/nevado-de-toluca.jpg', 1),
        (59, 'Pico de Orizaba', 'Mexico''s tallest mountain and a snow-capped stratovolcano', 'MX', 'https://example.com/pico-de-orizaba.jpg', 1),
        (60, 'Paricutin Volcano', 'Young volcano that dramatically emerged from a cornfield in 1943', 'MX', 'https://example.com/paricutin.jpg', 1),
        (61, 'Lagunas de Montebello', 'Cluster of colorful mountain lakes near the Guatemala border', 'MX', 'https://example.com/montebello-lakes.jpg', 1),
        (62, 'Cascada de Tamul', 'One of Mexico''s tallest waterfalls located in San Luis Potosi', 'MX', 'https://example.com/tamul-waterfall.jpg', 1),
        (63, 'Huasteca Potosina', 'Region of turquoise rivers, waterfalls, and jungle landscapes', 'MX', 'https://example.com/huasteca-potosina.jpg', 1),
        (64, 'Islas Marietas', 'Pacific islands known for wildlife and the hidden beach', 'MX', 'https://example.com/marietas-islands.jpg', 1),
        (65, 'Balandra Beach', 'Protected bay with turquoise water and white sand in Baja California Sur', 'MX', 'https://example.com/balandra-beach.jpg', 1),
        (66, 'Cabo Pulmo Reef', 'Thriving coral reef ecosystem in the Sea of Cortez', 'MX', 'https://example.com/cabo-pulmo.jpg', 1),
        (67, 'Valle de los Cirios', 'Desert landscape filled with towering cactus and rare plants', 'MX', 'https://example.com/valle-de-los-cirios.jpg', 1),
        (68, 'Basaseachic Falls', 'One of the tallest waterfalls in Mexico located in Chihuahua', 'MX', 'https://example.com/basaseachic-falls.jpg', 1),
        (69, 'Cenote Dos Ojos', 'Famous underwater cave system for diving in the Riviera Maya', 'MX', 'https://example.com/cenote-dos-ojos.jpg', 1),
        (70, 'Sierra Gorda Biosphere Reserve', 'Mountain ecosystem with forests, rivers, and wildlife in Queretaro', 'MX', 'https://example.com/sierra-gorda.jpg', 1),
        (71, 'Laguna Bacalar', 'Clear freshwater lagoon known as the Lake of Seven Colors', 'MX', 'https://example.com/bacalar.jpg', 1),
        (72, 'Isla Espiritu Santo', 'Wild island sanctuary with sea lions and pristine beaches', 'MX', 'https://example.com/espiritu-santo.jpg', 1),
        (73, 'Popocatepetl Volcano', 'Active volcano towering near Mexico City', 'MX', 'https://example.com/popocatepetl.jpg', 1),
        (74, 'Iztaccihuatl Volcano', 'Snow-capped dormant volcano known as the Sleeping Woman', 'MX', 'https://example.com/iztaccihuatl.jpg', 1),
        (75, 'Celestun Biosphere Reserve', 'Coastal wetlands famous for large flamingo populations', 'MX', 'https://example.com/celestun.jpg', 1)
) AS v(id, name, description, country, image_url, created_by_user_id)
CROSS JOIN should_insert_mx s
WHERE s.ok
ON CONFLICT (id) DO NOTHING;

SELECT setval(
    pg_get_serial_sequence('attractions', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM attractions),
    true
);
