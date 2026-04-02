-- ============================================================
-- SMART STAY - MOCK DATA v3 (Valid UUIDs - all hex characters)
-- Password mặc định: 123456
-- UUID pattern: chỉ dùng ký tự hex [0-9, a-f]
-- ============================================================

TRUNCATE TABLE
    visitor_logs, vehicles, roommates,
    inventory_items, tickets,
    announcements, listings,
    meter_readings, service_configs,
    invoices, contracts,
    rooms, properties,
    refresh_tokens, users
CASCADE;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================
-- UUID LEGEND
-- Users    : 1111...1, 2222...2, 3333...3
-- Property A (Hòa Bình)   : aaaa...a
-- Property B (Tân Bình)   : bbbb...b
-- Rooms A  : a0000001-...-0001 → 0005
-- Rooms B  : b0000001-...-0001 → 0003
-- Contracts: c0000001-...-0001, 0002
-- ============================================================

-- 1. USERS
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at)
VALUES
    ('11111111-1111-1111-1111-111111111111',
     'Nguyễn Văn An', '0911111111', 'an.landlord@smartstay.com',
     crypt('123456', gen_salt('bf', 10)), ARRAY['Landlord'],
     true, false, now(), now()),

    ('22222222-2222-2222-2222-222222222222',
     'Trần Thị Bình', '0922222222', 'binh.tenant@smartstay.com',
     crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'],
     true, false, now(), now()),

    ('33333333-3333-3333-3333-333333333333',
     'Lê Văn Cường', '0933333333', 'cuong.tenant@smartstay.com',
     crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'],
     true, false, now(), now());

-- 2. PROPERTIES
INSERT INTO properties (
    id, landlord_id, name, rules, shared_amenities,
    address_street, address_ward, address_district, address_city,
    is_deleted, created_at, updated_at
)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     '11111111-1111-1111-1111-111111111111',
     'Khu Trọ Hòa Bình',
     'Không nuôi thú cưng. Giờ giới nghiêm 23:00. Không tụ tập ồn ào.',
     ARRAY['WiFi chung', 'Máy giặt chung', 'Camera an ninh', 'Bãi xe máy'],
     '123 Nguyễn Thị Minh Khai', 'Phường 3', 'Quận 3', 'TP. Hồ Chí Minh',
     false, now(), now()),

    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
     '11111111-1111-1111-1111-111111111111',
     'Chung Cư Mini Tân Bình',
     'Không hút thuốc trong phòng. Đóng cửa sau 22:30.',
     ARRAY['WiFi riêng', 'Điều hòa', 'Thang máy', 'Bảo vệ 24/7'],
     '45 Hoàng Văn Thụ', 'Phường 4', 'Quận Tân Bình', 'TP. Hồ Chí Minh',
     false, now(), now());

-- 3. ROOMS
-- Rooms Khu Hòa Bình: a0000001-0000-0000-0000-000000000001 → 0005
-- Rooms Tân Bình    : b0000001-0000-0000-0000-000000000001 → 0003
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at)
VALUES
    ('a0000001-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     'P.101', 'Standard', 2500000, 20, 1, 2, false, now(), now()),  -- Occupied

    ('a0000001-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     'P.102', 'Standard', 2800000, 22, 1, 2, false, now(), now()),  -- Occupied

    ('a0000001-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     'P.103', 'VIP',      3000000, 25, 0, 2, false, now(), now()),  -- Empty (đang rao)

    ('a0000001-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     'P.201', 'Standard', 2200000, 18, 0, 1, false, now(), now()),  -- Empty (đang rao)

    ('a0000001-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     'P.202', 'Standard', 2200000, 18, 2, 1, false, now(), now()),  -- Maintenance

    ('b0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
     'A01', 'VIP',      4500000, 35, 1, 2, false, now(), now()),    -- Occupied

    ('b0000001-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
     'A02', 'VIP',      4000000, 30, 0, 2, false, now(), now()),    -- Empty (đang rao)

    ('b0000001-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
     'A03', 'Standard', 3500000, 28, 0, 2, false, now(), now());    -- Empty (đang rao)

-- 4. SERVICE CONFIGS
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, 'Electricity', 3500,   1, false, now(), now()),
    (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, 'Water',       20000,  1, false, now(), now()),
    (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, 'Internet',    100000, 2, false, now(), now()),
    (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, 'Garbage',     20000,  2, false, now(), now()),

    (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'Electricity', 4000,   1, false, now(), now()),
    (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'Water',       25000,  1, false, now(), now()),
    (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'Internet',    150000, 2, false, now(), now()),
    (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'Garbage',     30000,  2, false, now(), now()),
    (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'Management',  50000,  2, false, now(), now());

-- 5. CONTRACTS
-- c0000001-...-0001 = contract của Bình (P.101)
-- c0000001-...-0002 = contract của Cường (A01)
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at)
VALUES
    ('c0000001-0000-0000-0000-000000000001',
     'a0000001-0000-0000-0000-000000000001',
     '22222222-2222-2222-2222-222222222222',
     5000000, '2026-01-01', '2026-12-31', 1,
     'https://storage.smartstay.vn/contracts/hd001.jpg',
     false, now(), now()),

    ('c0000001-0000-0000-0000-000000000002',
     'b0000001-0000-0000-0000-000000000001',
     '33333333-3333-3333-3333-333333333333',
     9000000, '2026-02-01', '2027-01-31', 1,
     'https://storage.smartstay.vn/contracts/hd002.jpg',
     false, now(), now());

-- 6. INVENTORY ITEMS
INSERT INTO inventory_items (id, contract_id, item_name, check_in_photos, check_out_photos, condition, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001',
     'Giường đôi 1.8m',
     ARRAY['https://storage.smartstay.vn/inv/bed_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001',
     'Tủ quần áo 3 cánh',
     ARRAY['https://storage.smartstay.vn/inv/closet_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001',
     'Điều hòa 12000 BTU (Daikin)',
     ARRAY['https://storage.smartstay.vn/inv/ac_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),

    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000002',
     'Giường đôi 2.0m',
     ARRAY['https://storage.smartstay.vn/inv/bed2_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000002',
     'Tủ lạnh 200L (Samsung)',
     ARRAY['https://storage.smartstay.vn/inv/fridge_in.jpg'], ARRAY[]::text[], 1, false, now(), now());

-- 7. METER READINGS
INSERT INTO meter_readings (id, room_id, type, old_unit, new_unit, month, year, photo_url, is_deleted, created_at, updated_at)
VALUES
    -- P.101 tháng 3
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 120, 185, 3, 2026, NULL, false, now(), now()),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water',        30,  34, 3, 2026, NULL, false, now(), now()),
    -- P.101 tháng 4
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 185, 240, 4, 2026, NULL, false, now(), now()),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water',        34,  38, 4, 2026, NULL, false, now(), now()),

    -- A01 tháng 3
    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', 'Electricity', 200, 278, 3, 2026, NULL, false, now(), now()),
    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', 'Water',        15,  19, 3, 2026, NULL, false, now(), now()),
    -- A01 tháng 4
    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', 'Electricity', 278, 345, 4, 2026, NULL, false, now(), now()),
    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', 'Water',        19,  23, 4, 2026, NULL, false, now(), now());

-- 8. INVOICES
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at)
VALUES
    -- P.101 - Tháng 3 - Đã thanh toán
    (gen_random_uuid(),
     'a0000001-0000-0000-0000-000000000001',
     'c0000001-0000-0000-0000-000000000001',
     3, 2026,
     '{"rent":2500000,"electricity":{"old":120,"new":185,"consumed":65,"unitPrice":3500,"amount":227500},"water":{"old":30,"new":34,"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":20000}',
     2927500, 2927500, 1, false, now() - interval '20 days', now()),

    -- P.101 - Tháng 4 - Chưa thanh toán
    (gen_random_uuid(),
     'a0000001-0000-0000-0000-000000000001',
     'c0000001-0000-0000-0000-000000000001',
     4, 2026,
     '{"rent":2500000,"electricity":{"old":185,"new":240,"consumed":55,"unitPrice":3500,"amount":192500},"water":{"old":34,"new":38,"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":20000}',
     2892500, 0, 0, false, now() - interval '1 day', now()),

    -- A01 - Tháng 3 - Quá hạn
    (gen_random_uuid(),
     'b0000001-0000-0000-0000-000000000001',
     'c0000001-0000-0000-0000-000000000002',
     3, 2026,
     '{"rent":4500000,"electricity":{"old":200,"new":278,"consumed":78,"unitPrice":4000,"amount":312000},"water":{"old":15,"new":19,"consumed":4,"unitPrice":25000,"amount":100000},"internet":150000,"garbage":30000,"management":50000}',
     5142000, 0, 3, false, now() - interval '25 days', now());

-- 9. TICKETS
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(),
     'a0000001-0000-0000-0000-000000000001',
     '22222222-2222-2222-2222-222222222222',
     1, 'Vòi nước bồn rửa mặt bị rỉ',
     'Vòi nước bồn rửa mặt bị rỉ sét, nước chảy chậm và có tiếng kêu lạ khi mở.',
     ARRAY['https://storage.smartstay.vn/tickets/water_leak.jpg'],
     0, 1, false, now() - interval '2 days', now()),

    (gen_random_uuid(),
     'a0000001-0000-0000-0000-000000000001',
     '22222222-2222-2222-2222-222222222222',
     0, 'Ổ điện phòng ngủ bị chập',
     'Ổ điện góc phòng ngủ sát giường bị chập, thỉnh thoảng tóe lửa nhỏ rất nguy hiểm.',
     ARRAY['https://storage.smartstay.vn/tickets/electric.jpg'],
     1, 0, false, now() - interval '5 days', now()),

    (gen_random_uuid(),
     'b0000001-0000-0000-0000-000000000001',
     '33333333-3333-3333-3333-333333333333',
     2, 'Điều hòa không làm lạnh',
     'Điều hòa chạy bình thường nhưng không ra hơi lạnh, nhiệt độ phòng vẫn cao.',
     ARRAY['https://storage.smartstay.vn/tickets/ac_broken.jpg'],
     2, 2, false, now() - interval '10 days', now());

-- 10. ROOMMATES
INSERT INTO roommates (id, contract_id, full_name, phone, cccd_photo_url, is_approved, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(),
     'c0000001-0000-0000-0000-000000000001',
     'Phạm Thị Dung', '0944444444',
     'https://storage.smartstay.vn/cccd/dung_cccd.jpg',
     true, false, now(), now()),

    (gen_random_uuid(),
     'c0000001-0000-0000-0000-000000000002',
     'Ngô Văn Em', '0955555555',
     NULL, false, false, now(), now());

-- 11. VEHICLES
-- VehicleType: 0=Motorbike, 1=Car, 2=Bicycle
INSERT INTO vehicles (id, tenant_id, plate_number, vehicle_type, photo_url, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222',
     '51G1-12345', 0, 'https://storage.smartstay.vn/vehicles/xe_binh.jpg', false, now(), now()),

    (gen_random_uuid(), '33333333-3333-3333-3333-333333333333',
     '51F1-67890', 0, 'https://storage.smartstay.vn/vehicles/xe_cuong.jpg', false, now(), now()),

    (gen_random_uuid(), '33333333-3333-3333-3333-333333333333',
     '51H1-11111', 1, 'https://storage.smartstay.vn/vehicles/car_cuong.jpg', false, now(), now());

-- 12. VISITOR LOGS
INSERT INTO visitor_logs (id, tenant_id, visitor_name, phone, stay_overnight, arrived_at, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222',
     'Bạn thân Minh', '0966666666', false,
     now() - interval '2 days', false, now(), now()),

    (gen_random_uuid(), '33333333-3333-3333-3333-333333333333',
     'Anh họ Tuấn', '0977777777', true,
     now() - interval '1 day', false, now(), now());

-- 13. ANNOUNCEMENTS
INSERT INTO announcements (id, property_id, room_id, title, content, created_by, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL,
     '🔔 Cúp điện ngày 05/04/2026',
     'Điện lực thông báo: Thứ 7 ngày 05/04 cúp điện từ 08:00 - 17:00 để bảo trì đường dây. Xin thông cảm.',
     '11111111-1111-1111-1111-111111111111',
     false, now() - interval '3 days', now()),

    (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL,
     '🧹 Nhắc nhở vệ sinh bếp chung',
     'Kính nhờ vệ sinh khu vực bếp sau khi nấu. Không để thức ăn trong tủ lạnh chung quá 3 ngày.',
     '11111111-1111-1111-1111-111111111111',
     false, now() - interval '7 days', now()),

    (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL,
     '📅 Thu tiền phòng tháng 4',
     'Tiền phòng tháng 4 vui lòng thanh toán trước ngày 05/04/2026.',
     '11111111-1111-1111-1111-111111111111',
     false, now() - interval '1 day', now()),

    -- Thông báo riêng phòng A01
    (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
     'b0000001-0000-0000-0000-000000000001',
     '🔧 Lịch sửa điều hòa phòng A01',
     'Thợ sẽ đến sửa điều hòa lúc 9:00 sáng ngày 01/04/2026. Nhờ ở nhà hoặc để chìa tại văn phòng.',
     '11111111-1111-1111-1111-111111111111',
     false, now(), now());

-- 14. LISTINGS
INSERT INTO listings (id, room_id, photo_urls, description, is_active, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000003',
     ARRAY['https://storage.smartstay.vn/rooms/p103_1.jpg','https://storage.smartstay.vn/rooms/p103_2.jpg','https://storage.smartstay.vn/rooms/p103_3.jpg'],
     'Phòng VIP 25m² tầng 2 cửa sổ thoáng, nội thất mới 100%. Giường 1.8m, tủ áo, điều hòa, bình nóng lạnh. Gần chợ 300m. Giá 3.000.000đ/tháng.',
     true, false, now(), now()),

    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000004',
     ARRAY['https://storage.smartstay.vn/rooms/p201_1.jpg','https://storage.smartstay.vn/rooms/p201_2.jpg'],
     'Phòng 18m² giá sinh viên. Có máy lạnh, WiFi. Gần trường ĐH. Giá 2.200.000đ/tháng.',
     true, false, now(), now()),

    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000002',
     ARRAY['https://storage.smartstay.vn/rooms/a02_1.jpg','https://storage.smartstay.vn/rooms/a02_2.jpg','https://storage.smartstay.vn/rooms/a02_3.jpg'],
     'Studio cao cấp 30m² full nội thất: giường 2m, tủ lạnh, máy giặt riêng, điều hòa inverter. Thang máy, bảo vệ 24/7. Giá 4.000.000đ/tháng.',
     true, false, now(), now()),

    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000003',
     ARRAY['https://storage.smartstay.vn/rooms/a03_1.jpg','https://storage.smartstay.vn/rooms/a03_2.jpg'],
     'Phòng 28m² mới xây, nội thất cơ bản. Thích hợp người đi làm khu Tân Bình. Giá 3.500.000đ/tháng.',
     true, false, now(), now());

-- ============================================================
DO $$
BEGIN
    RAISE NOTICE '=====================================';
    RAISE NOTICE 'Mock data v3 OK!';
    RAISE NOTICE '-------------------------------------';
    RAISE NOTICE 'Đăng nhập bằng phone (password: 123456):';
    RAISE NOTICE '  Landlord : 0911111111';
    RAISE NOTICE '  Tenant 1 : 0922222222 (P.101 - Hoa Binh)';
    RAISE NOTICE '  Tenant 2 : 0933333333 (A01  - Tan Binh)';
    RAISE NOTICE '=====================================';
END;
$$;
