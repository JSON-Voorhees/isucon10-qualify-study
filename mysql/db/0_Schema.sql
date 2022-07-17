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
    rent        INTEGER             NOT NULL,
    door_height INTEGER             NOT NULL,
    door_width  INTEGER             NOT NULL,
    features    VARCHAR(64)         NOT NULL,
    popularity  INTEGER             NOT NULL,
    popularity_desc INTEGER AS (-popularity) NOT NULL,
    INDEX idx_rent (`rent`),
    INDEX idx_popularity_desc_id (`popularity_desc`, `id`),
    INDEX idx_rent_popularity_desc_id (`rent`,`popularity_desc`, `id`)
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
        WHEN price < 80 THEN 0
        WHEN price < 110 and price >= 80 THEN 1
        WHEN price < 150 and price >= 110 THEN 2
        WHEN price >= 150 THEN 3
    END) STORED,
    width_id    INTEGER AS (CASE
        WHEN price < 80 THEN 0
        WHEN price < 110 and price >= 80 THEN 1
        WHEN price < 150 and price >= 110 THEN 2
        WHEN price >= 150 THEN 3
    END) STORED,
    depth_id    INTEGER AS (CASE
        WHEN price < 80 THEN 0
        WHEN price < 110 and price >= 80 THEN 1
        WHEN price < 150 and price >= 110 THEN 2
        WHEN price >= 150 THEN 3
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
        WHEN color = "黒" THEN 1
        WHEN color = "白" THEN 2
        WHEN color = "赤" THEN 3
        WHEN color = "青" THEN 4
        WHEN color = "緑" THEN 5
        WHEN color = "黄" THEN 6
        WHEN color = "紫" THEN 7
        WHEN color = "ピンク" THEN 8
        WHEN color = "オレンジ" THEN 9
        WHEN color = "水色" THEN 10
        WHEN color = "ネイビー" THEN 11
        WHEN color = "ベージュ" THEN 12
    END) STORED,
    kind_id    INTEGER AS (CASE
        WHEN kind = "ゲーミングチェア" THEN 1
        WHEN kind = "座椅子" THEN 2
        WHEN kind = "エルゴノミクス" THEN 3
        WHEN kind = "ハンモック" THEN 4
    END) STORED,
    popularity_rev INTEGER AS (popularity * -1) STORED,
    PRIMARY KEY (id, stock),
    INDEX height_id_idx (height_id),
    INDEX width_id_idx (width_id),
    INDEX depth_id_idx (depth_id),
    INDEX price_id_idx (price_id),
    INDEX color_id_idx (color_id),
    INDEX kind_id_idx (price_id),
    INDEX sort_idx (popularity_rev, id),
    INDEX low_price_sort_idx (price, id)
)
PARTITION BY RANGE COLUMNS(stock) (
    PARTITION p0 VALUES LESS THAN (1),
    PARTITION pMax VALUES LESS THAN MAXVALUE
);
