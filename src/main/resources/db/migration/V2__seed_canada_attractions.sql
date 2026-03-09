-- Adds 25 default Canada attractions (IDs 26-50).
-- Uses a guard so this runs only if no Canada defaults are present.
WITH should_insert_ca AS (
    SELECT NOT EXISTS (SELECT 1 FROM attractions WHERE country = 'CA') AS ok
)
INSERT INTO attractions (id, name, description, country, image_url, created_by_user_id)
SELECT v.id, v.name, v.description, v.country, v.image_url, v.created_by_user_id
FROM (
    VALUES
        (26, 'Niagara Falls', 'Massive waterfalls located on the border of Ontario and New York', 'CA', 'https://example.com/niagara-falls-canada.jpg', 1),
        (27, 'Banff National Park', 'Mountain wilderness with turquoise lakes in Alberta', 'CA', 'https://example.com/banff.jpg', 1),
        (28, 'Lake Louise', 'Iconic glacial lake surrounded by the Canadian Rockies', 'CA', 'https://example.com/lake-louise.jpg', 1),
        (29, 'Moraine Lake', 'Brilliant blue alpine lake in the Valley of the Ten Peaks', 'CA', 'https://example.com/moraine-lake.jpg', 1),
        (30, 'Jasper National Park', 'Expansive wilderness park with glaciers and wildlife in Alberta', 'CA', 'https://example.com/jasper.jpg', 1),
        (31, 'Athabasca Glacier', 'Accessible glacier flowing from the Columbia Icefield', 'CA', 'https://example.com/athabasca-glacier.jpg', 1),
        (32, 'Yoho National Park', 'Rocky Mountain park known for waterfalls and fossil beds', 'CA', 'https://example.com/yoho.jpg', 1),
        (33, 'Emerald Lake', 'Vibrant green alpine lake in British Columbia', 'CA', 'https://example.com/emerald-lake.jpg', 1),
        (34, 'Bay of Fundy', 'Coastal bay known for the world''s highest tides', 'CA', 'https://example.com/bay-of-fundy.jpg', 1),
        (35, 'Hopewell Rocks', 'Flowerpot-shaped rock formations shaped by Fundy tides', 'CA', 'https://example.com/hopewell-rocks.jpg', 1),
        (36, 'Gros Morne National Park', 'Dramatic fjords and cliffs in Newfoundland', 'CA', 'https://example.com/gros-morne.jpg', 1),
        (37, 'Torngat Mountains', 'Remote Arctic mountains in northern Labrador', 'CA', 'https://example.com/torngat-mountains.jpg', 1),
        (38, 'Peggy''s Cove', 'Rocky Atlantic shoreline with dramatic granite formations', 'CA', 'https://example.com/peggys-cove.jpg', 1),
        (39, 'Algonquin Provincial Park', 'Vast forest park famous for lakes, moose, and canoeing', 'CA', 'https://example.com/algonquin.jpg', 1),
        (40, 'Nahanni National Park Reserve', 'Wild river canyon system in the Northwest Territories', 'CA', 'https://example.com/nahanni.jpg', 1),
        (41, 'Virginia Falls', 'Powerful waterfall twice the height of Niagara Falls', 'CA', 'https://example.com/virginia-falls.jpg', 1),
        (42, 'Lake Superior Shoreline', 'Dramatic cliffs and beaches along the largest Great Lake', 'CA', 'https://example.com/lake-superior.jpg', 1),
        (43, 'Spirit Island', 'Small picturesque island in Maligne Lake', 'CA', 'https://example.com/spirit-island.jpg', 1),
        (44, 'Churchill Polar Bear Coast', 'Arctic tundra known for polar bear migrations', 'CA', 'https://example.com/churchill.jpg', 1),
        (45, 'Cape Breton Highlands', 'Rugged coastal cliffs and forests in Nova Scotia', 'CA', 'https://example.com/cape-breton.jpg', 1),
        (46, 'Icefields Parkway', 'Scenic mountain corridor through glaciers and peaks', 'CA', 'https://example.com/icefields-parkway.jpg', 1),
        (47, 'Great Bear Rainforest', 'Vast coastal rainforest in British Columbia', 'CA', 'https://example.com/great-bear-rainforest.jpg', 1),
        (48, 'Dinosaur Provincial Park', 'Badlands landscape rich with dinosaur fossils', 'CA', 'https://example.com/dinosaur-park.jpg', 1),
        (49, 'Waterton Lakes National Park', 'Mountain lakes and prairies meeting in southern Alberta', 'CA', 'https://example.com/waterton-lakes.jpg', 1),
        (50, 'Haida Gwaii Islands', 'Remote Pacific archipelago with wild coastline and forests', 'CA', 'https://example.com/haida-gwaii.jpg', 1)
) AS v(id, name, description, country, image_url, created_by_user_id)
CROSS JOIN should_insert_ca s
WHERE s.ok
ON CONFLICT (id) DO NOTHING;

SELECT setval(
    pg_get_serial_sequence('attractions', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM attractions),
    true
);
