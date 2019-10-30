{{- config(materialized='view', schema='STG', enabled=true, tags='stage') -}}

{%- set source_table = ref('src_inventory') -%}

{{ dbtvault.multi_hash([('SUPPLIERKEY', 'SUPPLIER_PK'),
('SUPPLIER_NATION_KEY', 'NATION_PK'),
('SUPPLIER_REGION_KEY', 'REGION_PK'),
(['SUPPLIER_NATION_KEY', 'SUPPLIER_REGION_KEY'], 'NATION_REGION_PK'),
(['SUPPLIERKEY', 'SUPPLIER_NATION_KEY'], 'LINK_SUPPLIER_NATION_PK'),
('PARTKEY', 'PART_PK'),
(['PARTKEY', 'SUPPLIERKEY'], 'INVENTORY_PK'),
(['SUPPLIERKEY', 'SUPPLIER_ACCTBAL', 'SUPPLIER_ADDRESS', 'SUPPLIER_PHONE', 'SUPPLIER_COMMENT', 'SUPPLIER_NAME'], 'SUPPLIER_HASHDIFF', true),
(['PARTKEY', 'PART_BRAND', 'PART_COMMENT', 'PART_CONTAINER', 'PART_MFGR', 'PART_NAME', 'PART_RETAILPRICE', 'PART_SIZE', 'PART_TYPE'], 'PART_HASHDIFF', true),
(['SUPPLIER_REGION_KEY', 'SUPPLIER_REGION_COMMENT', 'SUPPLIER_REGION_NAME'], 'SUPPLIER_REGION_HASHDIFF', true),
(['SUPPLIER_NATION_KEY', 'SUPPLIER_NATION_COMMENT', 'SUPPLIER_NATION_NAME'], 'SUPPLIER_NATION_HASHDIFF', true),
(['PARTKEY', 'SUPPLIERKEY', 'AVAILQTY', 'SUPPLYCOST', 'PART_SUPPLY_COMMENT'], 'INVENTORY_HASHDIFF', true)]) -}},

{{ dbtvault.add_columns(source_table,
[('SUPPLIER_NATION_KEY', 'NATIONKEY'),
('SUPPLIER_NATION_NAME', 'NATION_NAME'),
('SUPPLIER_NATION_COMMENT', 'NATION_COMMENT'),
('SUPPLIER_REGION_KEY', 'REGIONKEY'),
('SUPPLIER_REGION_NAME', 'REGION_NAME'),
('SUPPLIER_REGION_COMMENT', 'REGION_COMMENT'),
('SUPPLIERKEY', 'SUPPLIER_KEY'),
('PARTKEY', 'PART_KEY'),
(var('date'), 'LOADDATE'),
('LOADDATE', 'EFFECTIVE_FROM'),
('!TPCH-INVENTORY', 'SOURCE')]) }}

{{ dbtvault.from(source_table) }}