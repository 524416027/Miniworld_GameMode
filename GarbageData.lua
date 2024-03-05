GARBAGE_AREAS =
{ -- area xyz axis and size, phase level
    -- phase 1
    {
        {
            -17, 10, -77, 2, 2, 2,
        }, 1
    },
    {
        {
            21, 10, -68,
            2, 2, 2,
        }, 1
    },
    {
        {
            -4, 10, -45,
            2, 2, 2,
        }, 1
    },
    {
        {
            -16, 10, -23,
            2, 2, 2,
        }, 1
    },
    {
        {
            -27, 10, -19,
            2, 2, 2,
        }, 1
    },
    {
        {
            -22, 10, -60,
            2, 2, 2,
        }, 1
    },
    -- phase 2
    {
        {
            27, 10, -34,
            2, 2, 2
        }, 2
    },
    {
        {
            21, 10, -41,
            2, 2, 2
        }, 2
    },
    {
        {
            5, 10, -25,
            2, 2, 2
        }, 2
    },
    -- phase 3
    {
        {
            -59, 10, -60,
            2, 2, 2,
        }, 3
    },
    {
        {
            -56, 10, -41,
            2, 2, 2,
        }, 3
    },
    {
        {
            -75, 10, -49,
            2, 2, 2,
        }, 3
    }
}
GarbagePileItemCount =
{ -- mythical, legendary, rare, uncommon
    -- phase 1
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    -- phase 2
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    -- phase 3
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0
}
CATEGORY_TEXT_COLOUR =
{
    "#cbd3728", -- mythical
    "#cff9300", -- legendary
    "#c6600ff", -- rare
    "#c0062ff", -- uncommon
    "#c8f9190" -- common
}
GARBAGE_PILE_ITEM_HEADER =
{
    "            " .. CATEGORY_TEXT_COLOUR[1] .. "神话垃圾：",
    "            " .. CATEGORY_TEXT_COLOUR[2] .. "传奇垃圾：",
    "            " .. CATEGORY_TEXT_COLOUR[3] .. "罕见垃圾：",
    "            " .. CATEGORY_TEXT_COLOUR[4] .. "稀有垃圾："
} -- mythical, legendary, rare, uncommon, common
GARBAGE_PILE_ITEM_MAX =
{
    5, 5, 10, 30
}
GARBAGE_PILE_REFRESH_RATE =
{
    60, 30, 15, 5
} -- refresh time in seconds
-- non-stackable item used for test remaining number of grids
INVENTORY_CHECKER_ID = 4147
-- key:itemID; value:itemName, itemRarity(1:M, 2:L, 3:R, 4:U, 5:C), itemPrice;
TRASH_ITEM_INFO =
{
    -- phase 1 common
    ["2025"] = { "纸张", 5, 0.1 },
    ["2026"] = { "锡箔纸", 5, 0.2 },
    ["2027"] = { "纸板", 5, 0.3 },
    ["2028"] = { "塑料瓶", 5, 0.5 },
    ["2029"] = { "罐头瓶", 5, 0.7 },
    -- phase 1 uncommon
    ["2030"] = { "钉子", 4, 1 },
    ["2031"] = { "电池", 4, 2 },
    ["2032"] = { "废金属", 4, 3 },
    ["2033"] = { "玻璃瓶", 4, 5 },
    -- phase 1 rare
    ["2034"] = { "娃娃", 3, 20 },
    ["2035"] = { "坏掉的灯泡", 3, 30 },
    ["2036"] = { "电线", 3, 40 },
    ["2037"] = { "生锈的管道", 3, 50 },
    -- phase 1 legendary
    ["2038"] = { "化妆品", 2, 110 },
    ["2039"] = { "坏掉的收音机", 2, 130 },
    ["2040"] = { "电脑主板", 2, 220 },
    ["2041"] = { "硬盘驱动器", 2, 280 },
    ["2042"] = { "显示器", 2, 350 },
    -- phase 1 mythical
    ["2043"] = { "漫画书", 1, 400 },
    ["2044"] = { "巧克力", 1, 450 },
    ["2045"] = { "卡片包", 1, 480 },
    ["2046"] = { "金戒指", 1, 500 },
    -- ================================
    -- phase 2 common
    ["2047"] = { "腐烂奶酪", 5, 0.4 },
    ["2048"] = { "腐烂牛肉", 5, 0.5 },
    ["2049"] = { "岩石", 5, 0.6 },
    ["2050"] = { "一块钱", 5, 1 },
    ["2051"] = { "棉布", 5, 0.7 },
    ["2052"] = { "树枝", 5, 0.8 },
    -- phase 2 uncommon
    ["2053"] = { "木板", 4, 2 },
    ["2054"] = { "弹簧", 4, 3 },
    ["2056"] = { "撕裂的布", 4, 4 },
    ["2057"] = { "空的喷瓶罐", 4, 6 },
    ["2055"] = { "纸币", 4, 5 },
    -- phase 2 rare
    ["2058"] = { "手套", 3, 50 },
    ["2062"] = { "靴子", 3, 70 },
    ["2059"] = { "裤子", 3, 60 },
    ["2060"] = { "奶油", 3, 100 },
    ["2061"] = { "帽子", 3, 90 },
    -- phase 2 legendary
    ["2063"] = { "破旧的手机", 2, 300 },
    ["2064"] = { "坏掉的平板", 2, 400 },
    ["2065"] = { "破损的电视", 2, 640 },
    -- phase 2 mythical
    ["2066"] = { "煤矿块", 1, 800 },
    ["2067"] = { "黄铜块", 1, 1000 },
    ["2068"] = { "信用卡", 1, 1200 },
    -- ================================
    -- phase 3 common
    -- ["2028"] = { "塑料瓶", 5, 0.5 },
    -- ["2027"] = { "纸板", 5, 0.3 },
    -- ["2029"] = { "罐头瓶", 5, 0.7 },
    -- ["2050"] = { "一块钱", 5, 1 },
    -- ["2051"] = { "棉布", 5, 0.7 },
    -- ["2052"] = { "树枝", 5, 0.8 },
    -- phase 3 uncommon
    -- ["2032"] = { "废金属", 4, 3 },
    -- ["2033"] = { "玻璃瓶", 4, 5 },
    -- ["2057"] = { "空的喷瓶罐", 4, 6 },
    -- ["2055"] = { "纸币", 4, 5 },
    -- ["2056"] = { "撕裂的布", 4, 4 },
    -- phase 3 rare
    -- ["2036"] = { "电线", 3, 40 },
    -- ["2037"] = { "生锈的管道", 3, 50 },
    -- ["2062"] = { "靴子", 3, 70 },
    -- ["2060"] = { "奶油", 3, 100 },
    -- ["2061"] = { "帽子", 3, 90 },
    -- phase 3 legendary
    -- ["2063"] = { "破旧的手机", 2, 300 },
    -- ["2064"] = { "坏掉的平板", 2, 400 },
    -- ["2065"] = { "破损的电视", 2, 640 },
    -- phase 3 mythical
    ["2069"] = { "黄金金币", 1, 2000 },
    ["2070"] = { "腕表", 1, 3500 },
    ["2071"] = { "崭新的电话", 1, 10000 },
}
PHASE1_CATEGORY_RARITY =
{
    -- categoryCount + index 1 data, maxRandomRange
    { 5 + 1, 200 },
    -- categoryName, categoryChance, categoryRandomRange, itemPool
    { "mythical", 1, 2,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 4 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2043,  40, 40 },
            { 2044,  30, 70 },
            { 2045,  20, 90 },
            { 2046,  10, 100 }
        }
    },
    { "legendary", 4, 10,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 5 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2038,  40, 40 },
            { 2039,  30, 70 },
            { 2040,  20, 90 },
            { 2041,  6,  96 },
            { 2042,  4,  100 }
        },
    },
    { "rare", 5, 20,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 4 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2034,  40, 40 },
            { 2035,  25, 65 },
            { 2036,  20, 85 },
            { 2037,  15, 100 }
        },
    },
    { "uncommon", 20, 60,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 4 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2030,  40, 40 },
            { 2031,  30, 70 },
            { 2032,  20, 90 },
            { 2033,  10, 100 }
        },
    },
    { "common", 70, 200,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 5 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2025,  30, 30 },
            { 2026,  20, 50 },
            { 2027,  20, 70 },
            { 2028,  15, 85 },
            { 2029,  15, 100 }
        },
    }
}
PHASE2_CATEGORY_RARITY =
{
    -- categoryCount + index 1 data, maxRandomRange
    { 5 + 1, 200 },
    -- categoryName, categoryChance, categoryRandomRange, itemPool
    { "mythical", 1, 2,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 3 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2066,  60, 60 },
            { 2067,  30, 90 },
            { 2068,  10, 100 }
        }
    },
    { "legendary", 4, 10,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 3 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2063,  60, 60 },
            { 2064,  30, 90 },
            { 2065,  10, 100 }
        },
    },
    { "rare", 5, 20,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 5 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2058,  30, 30 },
            { 2062,  20, 50 },
            { 2059,  20, 70 },
            { 2060,  15, 85 },
            { 2061,  15, 100 }
        },
    },
    { "uncommon", 20, 60,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 5 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2053,  40, 40 },
            { 2054,  20, 60 },
            { 2056,  20, 80 },
            { 2057,  10, 90 },
            { 2055,  10, 100 }
        },
    },
    { "common", 70, 200,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 6 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2047,  30, 30 },
            { 2048,  20, 50 },
            { 2049,  20, 70 },
            { 2050,  10, 80 },
            { 2051,  10, 90 },
            { 2052,  10, 100 }
        },
    }
}
PHASE3_CATEGORY_RARITY =
{
    -- categoryCount + index 1 data, maxRandomRange
    { 5 + 1, 200 },
    -- categoryName, categoryChance, categoryRandomRange, itemPool
    { "mythical", 1, 2,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 3 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2071,  60, 60 },
            { 2070,  30, 90 },
            { 2069,  10, 100 }
        }
    },
    { "legendary", 4, 10,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 3 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2063,  60, 60 },
            { 2064,  30, 90 },
            { 2065,  10, 100 }
        },
    },
    { "rare", 5, 20,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 5 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2036,  30, 30 },
            { 2037,  20, 50 },
            { 2062,  20, 70 },
            { 2060,  15, 85 },
            { 2061,  15, 100 }
        },
    },
    { "uncommon", 20, 60,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 5 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2032,  30, 30 },
            { 2033,  20, 50 },
            { 2057,  20, 70 },
            { 2055,  15, 85 },
            { 2056,  15, 100 }
        },
    },
    { "common", 70, 200,
        {
            -- categoryCount + index 1 data, maxRandomRange
            { 6 + 1, 100 },
            -- itemID, itemChance, itemRandomRange
            { 2028,  30, 30 },
            { 2027,  20, 50 },
            { 2029,  20, 70 },
            { 2050,  10, 80 },
            { 2051,  10, 90 },
            { 2052,  10, 100 }
        },
    }
}
CATEGORY_RARITY =
{
    PHASE1_CATEGORY_RARITY,
    PHASE2_CATEGORY_RARITY,
    PHASE3_CATEGORY_RARITY
}
