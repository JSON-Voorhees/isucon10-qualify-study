DROP DATABASE IF EXISTS isuumo;
CREATE DATABASE isuumo;

DROP TABLE IF EXISTS isuumo.estate;
DROP TABLE IF EXISTS isuumo.chair;

CREATE TABLE isuumo.estate
(
    id          INTEGER             NOT NULL PRIMARY KEY,
    name        VARCHAR(64)         NOT NULL,
    description VARCHAR(4096)       NOT NULL,
    thumbnail   VARCHAR(128)        NOT NULL,
    address     VARCHAR(128)        NOT NULL,
    latitude    DOUBLE PRECISION    NOT NULL,
    longitude   DOUBLE PRECISION    NOT NULL,
    geo GEOMETRY AS (ST_GeomFromText(CONCAT('POINT(', latitude, ' ', longitude, ')'))) STORED NOT NULL,
    rent        INTEGER             NOT NULL,
    door_height INTEGER             NOT NULL,
    door_width  INTEGER             NOT NULL,
    features    VARCHAR(64)         NOT NULL,
    popularity  INTEGER             NOT NULL,
    popularity_desc INTEGER AS (-popularity) NOT NULL,
    door_width_id    INTEGER AS (CASE
        WHEN door_width < 80 THEN 0
        WHEN door_width < 110 and door_width >= 80 THEN 1
        WHEN door_width < 150 and door_width >= 110 THEN 2
        WHEN door_width >= 150 THEN 3
    END) STORED,
    door_height_id    INTEGER AS (CASE
        WHEN door_height < 80 THEN 0
        WHEN door_height < 110 and door_height >= 80 THEN 1
        WHEN door_height < 150 and door_height >= 110 THEN 2
        WHEN door_height >= 150 THEN 3
    END) STORED,
    rent_id INTEGER AS (CASE
        WHEN rent < 50000 THEN 0
        WHEN rent < 100000 and rent >= 50000 THEN 1
        WHEN rent < 150000 and rent >= 100000 THEN 2
        WHEN rent >= 150000 THEN 3
    END) STORED,
    INDEX idx_rent (`rent`),
    INDEX idx_popularity_desc_id (`popularity_desc`, `id`),
    INDEX idx_rent_popularity_desc_id (`rent`,`popularity_desc`, `id`),
    SPATIAL INDEX idx_geo (`geo`),
    INDEX idx_door_width_door_height (`door_width`,`door_height`),
    INDEX idx_door_height_rent (`door_height`, `rent`),
    INDEX idx_door_width_rent (`door_width`, `rent`),
    INDEX door_height_width_rent_idx (door_height_id, door_width_id, rent_id),
    INDEX door_height_rent_idx (door_height_id, rent_id),
    INDEX door_width_rent_idx (door_width_id, rent_id),
    INDEX rent_id_idx (rent_id)
);

CREATE TABLE isuumo.chair
(
    id          INTEGER         NOT NULL,
    name        VARCHAR(64)     NOT NULL,
    description VARCHAR(4096)   NOT NULL,
    thumbnail   VARCHAR(128)    NOT NULL,
    price       INTEGER         NOT NULL,
    height      INTEGER         NOT NULL,
    width       INTEGER         NOT NULL,
    depth       INTEGER         NOT NULL,
    color       VARCHAR(64)     NOT NULL,
    features    VARCHAR(64)     NOT NULL,
    kind        VARCHAR(64)     NOT NULL,
    popularity  INTEGER         NOT NULL,
    stock       INTEGER         NOT NULL,
    height_id    INTEGER AS (CASE
        WHEN height < 80 THEN 0
        WHEN height < 110 and height >= 80 THEN 1
        WHEN height < 150 and height >= 110 THEN 2
        WHEN height >= 150 THEN 3
    END) STORED,
    width_id    INTEGER AS (CASE
        WHEN width < 80 THEN 0
        WHEN width < 110 and width >= 80 THEN 1
        WHEN width < 150 and width >= 110 THEN 2
        WHEN width >= 150 THEN 3
    END) STORED,
    depth_id    INTEGER AS (CASE
        WHEN depth < 80 THEN 0
        WHEN depth < 110 and depth >= 80 THEN 1
        WHEN depth < 150 and depth >= 110 THEN 2
        WHEN depth >= 150 THEN 3
    END) STORED,
    price_id    INTEGER AS (CASE
        WHEN price < 3000 THEN 0
        WHEN price < 6000 and price >= 3000 THEN 1
        WHEN price < 9000 and price >= 6000 THEN 2
        WHEN price < 12000 and price >= 9000 THEN 3
        WHEN price < 15000 and price >= 12000 THEN 4
        WHEN price >= 15000 THEN 5
    END) STORED,
    color_id    INTEGER AS (CASE
        WHEN color = "???" THEN 1
        WHEN color = "???" THEN 2
        WHEN color = "???" THEN 3
        WHEN color = "???" THEN 4
        WHEN color = "???" THEN 5
        WHEN color = "???" THEN 6
        WHEN color = "???" THEN 7
        WHEN color = "?????????" THEN 8
        WHEN color = "????????????" THEN 9
        WHEN color = "??????" THEN 10
        WHEN color = "????????????" THEN 11
        WHEN color = "????????????" THEN 12
    END) STORED,
    kind_id    INTEGER AS (CASE
        WHEN kind = "????????????????????????" THEN 1
        WHEN kind = "?????????" THEN 2
        WHEN kind = "?????????????????????" THEN 3
        WHEN kind = "???????????????" THEN 4
    END) STORED,
    popularity_rev INTEGER AS (popularity * -1) STORED,
    PRIMARY KEY (id, stock),
    INDEX price_height_width_depth_kind_idx (price_id, height_id, width_id, depth_id, kind_id, color_id),
    INDEX price_height_depth_kind_idx (price_id, height_id, depth_id, kind_id, color_id),
    INDEX price_height_width_kind_idx (price_id, height_id, width_id, kind_id, color_id),
    INDEX price_width_depth_color_idx (price_id, width_id, depth_id, color_id),
    INDEX price_height_color_idx (price_id, height_id, color_id),
    INDEX price_width_color_idx (price_id, width_id, color_id),
    INDEX price_depth_color_idx (price_id, depth_id, color_id),
    INDEX price_height_kind_color_idx (price_id, height_id, kind_id, color_id),
    INDEX price_depth_kind_color_idx (price_id, depth_id, kind_id, color_id),
    INDEX height_depth_color_idx (height_id, depth_id, color_id),
    INDEX height_id_idx (height_id, width_id, depth_id, kind_id, color_id),
    INDEX width_id_idx (width_id, depth_id, kind_id, color_id),
    INDEX depth_id_idx (depth_id, kind_id, color_id),
    INDEX kind_id_idx (kind_id, color_id),
    INDEX color_id_idx (color_id),
    INDEX sort_idx (popularity_rev, id),
    INDEX low_price_sort_idx (price, id)
)
PARTITION BY RANGE COLUMNS(stock) (
    PARTITION p0 VALUES LESS THAN (1),
    PARTITION pMax VALUES LESS THAN MAXVALUE
);
