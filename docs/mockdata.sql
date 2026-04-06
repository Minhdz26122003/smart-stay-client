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
     'P.101', 'Standard', 2500000, 20, 1, 3, false, now(), now()),  -- Occupied (Test Chi tiết sâu cho phòng này)

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
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at)
VALUES
    ('c0000001-0000-0000-0000-000000000001',
     'a0000001-0000-0000-0000-000000000001',
     '22222222-2222-2222-2222-222222222222',
     5000000, '2025-06-01', '2026-12-31', 1,
     'https://storage.smartstay.vn/contracts/hd001.jpg',
     false, '2025-05-25 10:00:00', '2025-05-25 10:00:00'),

    ('c0000001-0000-0000-0000-000000000002',
     'b0000001-0000-0000-0000-000000000001',
     '33333333-3333-3333-3333-333333333333',
     9000000, '2026-02-01', '2027-01-31', 1,
     'https://storage.smartstay.vn/contracts/hd002.jpg',
     false, now(), now());

-- 6. INVENTORY ITEMS (TÀI SẢN CHI TIẾT - Focus P.101)
INSERT INTO inventory_items (id, contract_id, item_name, check_in_photos, check_out_photos, condition, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Giường đôi 1.8m (Gỗ sồi)', ARRAY['https://storage.smartstay.vn/inv/bed_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Tủ quần áo 3 cánh (Gỗ công nghiệp)', ARRAY['https://storage.smartstay.vn/inv/closet_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Điều hòa 12000 BTU (Daikin Inverter)', ARRAY['https://storage.smartstay.vn/inv/ac_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Bàn làm việc (Khung sắt, mặt gỗ)', ARRAY['https://storage.smartstay.vn/inv/desk_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Ghế xoay văn phòng', ARRAY['https://storage.smartstay.vn/inv/chair_in.jpg'], ARRAY[]::text[], 1, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Tivi Smart Samsung 43 inch', ARRAY['https://storage.smartstay.vn/inv/tv_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Tủ lạnh 150L (Aqua)', ARRAY['https://storage.smartstay.vn/inv/fridge_150_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Máy nước nóng lạnh', ARRAY['https://storage.smartstay.vn/inv/heater_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),

    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000002', 'Giường đôi 2.0m', ARRAY['https://storage.smartstay.vn/inv/bed2_in.jpg'], ARRAY[]::text[], 0, false, now(), now()),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000002', 'Tủ lạnh 200L (Samsung)', ARRAY['https://storage.smartstay.vn/inv/fridge_in.jpg'], ARRAY[]::text[], 1, false, now(), now());

-- 7. METER READINGS (CHỈ SỐ ĐIỆN NƯỚC LỊCH SỬ - Focus P.101)
INSERT INTO meter_readings (id, room_id, type, old_unit, new_unit, month, year, photo_url, is_deleted, created_at, updated_at)
VALUES
    -- P.101 Tháng 10/2025
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 0, 50, 10, 2025, NULL, false, '2025-10-30 08:00:00', '2025-10-30 08:00:00'),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water', 0, 5, 10, 2025, NULL, false, '2025-10-30 08:00:00', '2025-10-30 08:00:00'),
    -- P.101 Tháng 11/2025
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 50, 95, 11, 2025, NULL, false, '2025-11-30 08:00:00', '2025-11-30 08:00:00'),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water', 5, 11, 11, 2025, NULL, false, '2025-11-30 08:00:00', '2025-11-30 08:00:00'),
    -- P.101 Tháng 12/2025
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 95, 140, 12, 2025, NULL, false, '2025-12-30 08:00:00', '2025-12-30 08:00:00'),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water', 11, 17, 12, 2025, NULL, false, '2025-12-30 08:00:00', '2025-12-30 08:00:00'),
    -- P.101 Tháng 1/2026
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 140, 180, 1, 2026, NULL, false, '2026-01-30 08:00:00', '2026-01-30 08:00:00'),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water', 17, 23, 1, 2026, NULL, false, '2026-01-30 08:00:00', '2026-01-30 08:00:00'),
    -- P.101 Tháng 2/2026
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 180, 235, 2, 2026, NULL, false, '2026-02-28 08:00:00', '2026-02-28 08:00:00'),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water', 23, 29, 2, 2026, NULL, false, '2026-02-28 08:00:00', '2026-02-28 08:00:00'),
    -- P.101 Tháng 3/2026
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 235, 280, 3, 2026, NULL, false, '2026-03-30 08:00:00', '2026-03-30 08:00:00'),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water', 29, 34, 3, 2026, NULL, false, '2026-03-30 08:00:00', '2026-03-30 08:00:00'),
    -- P.101 Tháng 4/2026
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Electricity', 280, 335, 4, 2026, NULL, false, now(), now()),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'Water', 34, 38, 4, 2026, NULL, false, now(), now()),

    -- A01 tháng 3
    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', 'Electricity', 200, 278, 3, 2026, NULL, false, now(), now()),
    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', 'Water', 15, 19, 3, 2026, NULL, false, now(), now());

-- 8. INVOICES (LỊCH SỬ HÓA ĐƠN ĐÓNG TIỀN - Focus P.101)
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at)
VALUES
    -- P.101 Tháng 10/2025 (Đã thanh toán)
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'c0000001-0000-0000-0000-000000000001', 10, 2025,
     '{"rent":2500000,"electricity":{"old":0,"new":50,"consumed":50,"unitPrice":3500,"amount":175000},"water":{"old":0,"new":5,"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":20000}',
     2895000, 2895000, 1, false, '2025-11-01 00:00:00', '2025-11-03 00:00:00'),
    -- P.101 Tháng 11/2025 (Đã thanh toán)
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'c0000001-0000-0000-0000-000000000001', 11, 2025,
     '{"rent":2500000,"electricity":{"old":50,"new":95,"consumed":45,"unitPrice":3500,"amount":157500},"water":{"old":5,"new":11,"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":20000}',
     2897500, 2897500, 1, false, '2025-12-01 00:00:00', '2025-12-05 00:00:00'),
    -- P.101 Tháng 12/2025 (Đã thanh toán)
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'c0000001-0000-0000-0000-000000000001', 12, 2025,
     '{"rent":2500000,"electricity":{"old":95,"new":140,"consumed":45,"unitPrice":3500,"amount":157500},"water":{"old":11,"new":17,"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":20000}',
     2897500, 2897500, 1, false, '2026-01-01 00:00:00', '2026-01-02 00:00:00'),
    -- P.101 Tháng 1/2026 (Đã thanh toán)
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'c0000001-0000-0000-0000-000000000001', 1, 2026,
     '{"rent":2500000,"electricity":{"old":140,"new":180,"consumed":40,"unitPrice":3500,"amount":140000},"water":{"old":17,"new":23,"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":20000}',
     2880000, 2880000, 1, false, '2026-02-01 00:00:00', '2026-02-04 00:00:00'),
    -- P.101 Tháng 2/2026 (Đã thanh toán)
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'c0000001-0000-0000-0000-000000000001', 2, 2026,
     '{"rent":2500000,"electricity":{"old":180,"new":235,"consumed":55,"unitPrice":3500,"amount":192500},"water":{"old":23,"new":29,"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":20000}',
     2932500, 2932500, 1, false, '2026-03-01 00:00:00', '2026-03-06 00:00:00'),
    -- P.101 Tháng 3/2026 (Đã thanh toán)
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'c0000001-0000-0000-0000-000000000001', 3, 2026,
     '{"rent":2500000,"electricity":{"old":235,"new":280,"consumed":45,"unitPrice":3500,"amount":157500},"water":{"old":29,"new":34,"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":20000}',
     2877500, 2877500, 1, false, '2026-04-01 00:00:00', '2026-04-03 00:00:00'),
    -- P.101 Tháng 4/2026 (Chưa thanh toán)
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', 'c0000001-0000-0000-0000-000000000001', 4, 2026,
     '{"rent":2500000,"electricity":{"old":280,"new":335,"consumed":55,"unitPrice":3500,"amount":192500},"water":{"old":34,"new":38,"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":20000}',
     2892500, 0, 0, false, now() - interval '1 day', now()),

    -- A01 - Tháng 3 - Quá hạn
    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', 'c0000001-0000-0000-0000-000000000002', 3, 2026,
     '{"rent":4500000,"electricity":{"old":200,"new":278,"consumed":78,"unitPrice":4000,"amount":312000},"water":{"old":15,"new":19,"consumed":4,"unitPrice":25000,"amount":100000},"internet":150000,"garbage":30000,"management":50000}',
     5142000, 0, 3, false, now() - interval '25 days', now());

-- 9. TICKETS (LỊCH SỬ BÁO CÁO SỰ CỐ - Focus P.101)
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at)
VALUES
    -- Các sự cố cũ của P.101 đã sửa xong (Status: 2 hoặc 3 - Tùy quy ước, giả sử 2 là Completed)
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222',
     1, 'Bóng đèn nhà vệ sinh bị cháy', 'Tôi bật công tắc nhấp nháy vài lần rồi xì khói đen ở sát chuôi đèn', ARRAY['https://storage.smartstay.vn/tickets/bulb.jpg'], 2, 0, false, '2025-08-15 10:00:00', '2025-08-16 10:00:00'),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222',
     2, 'Chìa khóa cổng bị kẹt lỏng', 'Ổ khóa từ cổng chính bị khó quẹt thẻ, nhờ chú chủ nhà xem lại', ARRAY[]::text[], 2, 1, false, '2025-11-20 18:00:00', '2025-11-21 09:00:00'),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222',
     1, 'Ghế làm việc bị gãy bánh xe', 'Bánh xe ghế xoay bị nứt và rụng ra rồi ạ.', ARRAY['https://storage.smartstay.vn/tickets/chair.jpg'], 2, 0, false, '2026-01-05 14:00:00', '2026-01-06 10:00:00'),

    -- Các sự cố hiện tại của P.101
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222',
     1, 'Vòi nước bồn rửa mặt bị rỉ', 'Vòi nước bồn rửa mặt bị rỉ sét, nước chảy chậm và có tiếng kêu lạ khi mở.', ARRAY['https://storage.smartstay.vn/tickets/water_leak.jpg'], 0, 1, false, now() - interval '2 days', now()),
    (gen_random_uuid(), 'a0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222',
     0, 'Ổ điện phòng ngủ bị chập', 'Ổ điện góc phòng ngủ sát giường bị chập, thỉnh thoảng tóe lửa nhỏ rất nguy hiểm.', ARRAY['https://storage.smartstay.vn/tickets/electric.jpg'], 1, 0, false, now() - interval '5 days', now()),

    -- Sự cố phòng A01
    (gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333',
     2, 'Điều hòa không làm lạnh', 'Điều hòa chạy bình thường nhưng không ra hơi lạnh, nhiệt độ phòng vẫn cao.', ARRAY['https://storage.smartstay.vn/tickets/ac_broken.jpg'], 2, 2, false, now() - interval '10 days', now());

-- 10. ROOMMATES (NGƯỜI Ở GHÉP - Focus P.101)
INSERT INTO roommates (id, contract_id, full_name, phone, cccd_photo_url, is_approved, is_deleted, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Phạm Thị Dung', '0944444444', 'https://storage.smartstay.vn/cccd/dung_cccd.jpg', true, false, '2025-06-05 10:00:00', '2025-06-05 10:00:00'),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Lê Thị Thu', '0988888888', 'https://storage.smartstay.vn/cccd/thu_cccd.jpg', true, false, '2025-10-15 09:00:00', '2025-10-15 09:00:00'),
    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'Nguyễn Thị Hoa', '0999999999', 'https://storage.smartstay.vn/cccd/hoa_cccd.jpg', false, false, now(), now()), -- Người mới chờ duyệt

    (gen_random_uuid(), 'c0000001-0000-0000-0000-000000000002', 'Ngô Văn Em', '0955555555', NULL, false, false, now(), now());

-- 11. VEHICLES (PHƯƠNG TIỆN - Focus P.101)
INSERT INTO vehicles (id, tenant_id, plate_number, vehicle_type, photo_url, is_deleted, created_at, updated_at)
VALUES
    -- Xe của phòng P.101
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '51G1-12345', 0, 'https://storage.smartstay.vn/vehicles/xe_binh.jpg', false, now(), now()),
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '59S2-98765', 0, 'https://storage.smartstay.vn/vehicles/xe_dung.jpg', false, now(), now()),
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', '61B1-55555', 0, 'https://storage.smartstay.vn/vehicles/xe_thu.jpg', false, now(), now()),

    -- Xe của A01
    (gen_random_uuid(), '33333333-3333-3333-3333-333333333333', '51F1-67890', 0, 'https://storage.smartstay.vn/vehicles/xe_cuong.jpg', false, now(), now()),
    (gen_random_uuid(), '33333333-3333-3333-3333-333333333333', '51H1-11111', 1, 'https://storage.smartstay.vn/vehicles/car_cuong.jpg', false, now(), now());

-- 12. VISITOR LOGS (KHÁCH THĂM - Focus P.101)
INSERT INTO visitor_logs (id, tenant_id, visitor_name, phone, stay_overnight, arrived_at, is_deleted, created_at, updated_at)
VALUES
    -- Khách của P.101
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'Bác Hai (Phụ Huynh)', '0901112222', true, '2025-09-01 18:00:00', false, '2025-09-01 18:00:00', '2025-09-01 18:00:00'),
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'Chị họ (Lan)', '0903334444', false, '2025-11-20 09:00:00', false, '2025-11-20 09:00:00', '2025-11-20 09:00:00'),
    (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'Bạn đại học (Trang)', '0966666666', false, now() - interval '2 days', false, now(), now()),

    -- Khách của A01
    (gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'Anh họ Tuấn', '0977777777', true, now() - interval '1 day', false, now(), now());

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
    (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'b0000001-0000-0000-0000-000000000001',
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
-- 15. PROPERTY C (KHU TRỌ LÀNG ĐẠI HỌC) & LỊCH SỬ DOANH THU LỚN
-- ============================================================
INSERT INTO properties (id, landlord_id, name, rules, shared_amenities, address_street, address_ward, address_district, address_city, is_deleted, created_at, updated_at) VALUES 
('cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111', 'Khu Trọ Làng Đại Học (Test Pagination/Dashboard)', 'Tuân thủ nội quy', ARRAY['Khu để xe chung', 'Bảo vệ 24/7', 'Thang máy'], 'Đường số 10', 'Phường Linh Trung', 'Thành phố Thủ Đức', 'TP. Hồ Chí Minh', false, now(), now());

INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000001', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C01', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000001', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000001', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000001', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000001', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000002', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C02', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000002', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000002', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000002', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000002', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000003', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C03', 'VIP', 3500000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000003', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000003', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000003', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000003', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000004', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C04', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000004', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000004', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000004', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000004', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000005', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C05', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000005', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000005', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000005', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000005', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000006', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C06', 'VIP', 3500000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000006', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000006', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000006', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000006', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000007', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C07', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000007', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000007', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000007', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000007', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000008', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C08', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000008', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000008', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000008', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000008', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000009', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C09', 'VIP', 3500000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000009', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000009', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000009', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000009', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000010', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C10', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000010', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000010', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000010', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000010', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000011', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C11', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000011', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000011', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000011', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000011', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000012', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C12', 'VIP', 3500000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000012', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000012', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000012', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000012', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000013', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C13', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000013', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000013', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000013', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000013', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000014', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C14', 'Standard', 2000000, 20, 1, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000014', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000014', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000014', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000014', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000015', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C15', 'VIP', 3500000, 20, 0, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000015', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000015', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000015', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000015', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000016', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C16', 'Standard', 2000000, 20, 0, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000016', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000016', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000016', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000016', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000017', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C17', 'Standard', 2000000, 20, 0, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000017', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000017', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000017', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000017', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000018', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C18', 'VIP', 3500000, 20, 2, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000018', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000018', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000018', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000018', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000019', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C19', 'Standard', 2000000, 20, 2, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000019', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000019', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000019', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000019', 'Internet', 100000, 2, false, now(), now());
INSERT INTO rooms (id, property_id, name, type, base_price, area_m2, status, max_occupants, is_deleted, created_at, updated_at) VALUES 
    ('cc000000-0000-0000-0000-000000000020', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'C20', 'Standard', 2000000, 20, 2, 2, false, now(), now());
INSERT INTO service_configs (id, property_id, room_id, type, unit_price, calc_method, is_deleted, created_at, updated_at) VALUES 
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000020', 'Electricity', 3500, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000020', 'Water', 20000, 1, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000020', 'Garbage', 30000, 2, false, now(), now()),
    (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000000-0000-0000-0000-000000000020', 'Internet', 100000, 2, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000001', 'Sinh Viên C1', '0800000001', 'sv.c1@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000001', 'cc000000-0000-0000-0000-000000000001', 'ee000000-0000-0000-0000-000000000001', 4000000, '2025-01-01', now() + interval '15 days', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000002', 'Sinh Viên C2', '0800000002', 'sv.c2@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000002', 'cc000000-0000-0000-0000-000000000002', 'ee000000-0000-0000-0000-000000000002', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000003', 'Sinh Viên C3', '0800000003', 'sv.c3@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000003', 'cc000000-0000-0000-0000-000000000003', 'ee000000-0000-0000-0000-000000000003', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000004', 'Sinh Viên C4', '0800000004', 'sv.c4@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000004', 'cc000000-0000-0000-0000-000000000004', 'ee000000-0000-0000-0000-000000000004', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000005', 'Sinh Viên C5', '0800000005', 'sv.c5@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000005', 'cc000000-0000-0000-0000-000000000005', 'ee000000-0000-0000-0000-000000000005', 4000000, '2025-01-01', now() + interval '15 days', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000006', 'Sinh Viên C6', '0800000006', 'sv.c6@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000006', 'cc000000-0000-0000-0000-000000000006', 'ee000000-0000-0000-0000-000000000006', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000007', 'Sinh Viên C7', '0800000007', 'sv.c7@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000007', 'cc000000-0000-0000-0000-000000000007', 'ee000000-0000-0000-0000-000000000007', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000008', 'Sinh Viên C8', '0800000008', 'sv.c8@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000008', 'cc000000-0000-0000-0000-000000000008', 'ee000000-0000-0000-0000-000000000008', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000009', 'Sinh Viên C9', '0800000009', 'sv.c9@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000009', 'cc000000-0000-0000-0000-000000000009', 'ee000000-0000-0000-0000-000000000009', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000010', 'Sinh Viên C10', '0800000010', 'sv.c10@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000010', 'cc000000-0000-0000-0000-000000000010', 'ee000000-0000-0000-0000-000000000010', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000011', 'Sinh Viên C11', '0800000011', 'sv.c11@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000011', 'cc000000-0000-0000-0000-000000000011', 'ee000000-0000-0000-0000-000000000011', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000012', 'Sinh Viên C12', '0800000012', 'sv.c12@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000012', 'cc000000-0000-0000-0000-000000000012', 'ee000000-0000-0000-0000-000000000012', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000013', 'Sinh Viên C13', '0800000013', 'sv.c13@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000013', 'cc000000-0000-0000-0000-000000000013', 'ee000000-0000-0000-0000-000000000013', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());
INSERT INTO users (id, full_name, phone, email, password_hash, roles, is_active, is_deleted, created_at, updated_at) VALUES 
    ('ee000000-0000-0000-0000-000000000014', 'Sinh Viên C14', '0800000014', 'sv.c14@gmail.com', crypt('123456', gen_salt('bf', 10)), ARRAY['Tenant'], true, false, now(), now());
INSERT INTO contracts (id, room_id, tenant_id, deposit_amount, start_date, end_date, status, scanned_contract_url, is_deleted, created_at, updated_at) VALUES 
    ('dd000000-0000-0000-0000-000000000014', 'cc000000-0000-0000-0000-000000000014', 'ee000000-0000-0000-0000-000000000014', 4000000, '2025-01-01', '2026-12-31', 1, NULL, false, now(), now());

-- GENERATE INVOICES AND TICKETS FOR DASHBOARD CHARTS
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 5, 2025, '{"rent":2000000,"electricity":{"consumed":67,"unitPrice":3500,"amount":234500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2424500, 2424500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 5, 2025, '{"rent":2000000,"electricity":{"consumed":78,"unitPrice":3500,"amount":273000},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2563000, 2563000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 5, 2025, '{"rent":3500000,"electricity":{"consumed":50,"unitPrice":3500,"amount":175000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3865000, 3865000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 5, 2025, '{"rent":2000000,"electricity":{"consumed":33,"unitPrice":3500,"amount":115500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2405500, 2405500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 5, 2025, '{"rent":2000000,"electricity":{"consumed":64,"unitPrice":3500,"amount":224000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2494000, 2494000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 5, 2025, '{"rent":3500000,"electricity":{"consumed":69,"unitPrice":3500,"amount":241500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3931500, 3931500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 5, 2025, '{"rent":2000000,"electricity":{"consumed":70,"unitPrice":3500,"amount":245000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2455000, 2455000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 5, 2025, '{"rent":2000000,"electricity":{"consumed":61,"unitPrice":3500,"amount":213500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2403500, 2403500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 5, 2025, '{"rent":3500000,"electricity":{"consumed":72,"unitPrice":3500,"amount":252000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 4022000, 4022000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 5, 2025, '{"rent":2000000,"electricity":{"consumed":40,"unitPrice":3500,"amount":140000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2350000, 2350000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 5, 2025, '{"rent":2000000,"electricity":{"consumed":67,"unitPrice":3500,"amount":234500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2504500, 2504500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 5, 2025, '{"rent":3500000,"electricity":{"consumed":38,"unitPrice":3500,"amount":133000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 3843000, 3843000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 5, 2025, '{"rent":2000000,"electricity":{"consumed":38,"unitPrice":3500,"amount":133000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2363000, 2363000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 5, 2025, '{"rent":2000000,"electricity":{"consumed":79,"unitPrice":3500,"amount":276500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2506500, 2506500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'ee000000-0000-0000-0000-000000000011', 1, 'Sự cố tháng 5/2025', 'Đã báo cáo từ 5/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'ee000000-0000-0000-0000-000000000003', 1, 'Sự cố tháng 5/2025', 'Đã báo cáo từ 5/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'ee000000-0000-0000-0000-000000000008', 0, 'Sự cố tháng 5/2025', 'Đã báo cáo từ 5/2025', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 6, 2025, '{"rent":2000000,"electricity":{"consumed":75,"unitPrice":3500,"amount":262500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2552500, 2552500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 6, 2025, '{"rent":2000000,"electricity":{"consumed":32,"unitPrice":3500,"amount":112000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2362000, 2362000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 6, 2025, '{"rent":3500000,"electricity":{"consumed":34,"unitPrice":3500,"amount":119000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 3829000, 3829000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 6, 2025, '{"rent":2000000,"electricity":{"consumed":33,"unitPrice":3500,"amount":115500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2405500, 2405500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 6, 2025, '{"rent":2000000,"electricity":{"consumed":62,"unitPrice":3500,"amount":217000},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2507000, 2507000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 6, 2025, '{"rent":3500000,"electricity":{"consumed":63,"unitPrice":3500,"amount":220500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3910500, 3910500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 6, 2025, '{"rent":2000000,"electricity":{"consumed":69,"unitPrice":3500,"amount":241500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2471500, 2471500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 6, 2025, '{"rent":2000000,"electricity":{"consumed":45,"unitPrice":3500,"amount":157500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2447500, 2447500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 6, 2025, '{"rent":3500000,"electricity":{"consumed":56,"unitPrice":3500,"amount":196000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3886000, 3886000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 6, 2025, '{"rent":2000000,"electricity":{"consumed":30,"unitPrice":3500,"amount":105000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2375000, 2375000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 6, 2025, '{"rent":2000000,"electricity":{"consumed":63,"unitPrice":3500,"amount":220500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2450500, 2450500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 6, 2025, '{"rent":3500000,"electricity":{"consumed":52,"unitPrice":3500,"amount":182000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 3912000, 3912000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 6, 2025, '{"rent":2000000,"electricity":{"consumed":59,"unitPrice":3500,"amount":206500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2456500, 2456500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 6, 2025, '{"rent":2000000,"electricity":{"consumed":55,"unitPrice":3500,"amount":192500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2422500, 2422500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'ee000000-0000-0000-0000-000000000014', 2, 'Sự cố tháng 6/2025', 'Đã báo cáo từ 6/2025', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'ee000000-0000-0000-0000-000000000011', 1, 'Sự cố tháng 6/2025', 'Đã báo cáo từ 6/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 7, 2025, '{"rent":2000000,"electricity":{"consumed":65,"unitPrice":3500,"amount":227500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2477500, 2477500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 7, 2025, '{"rent":2000000,"electricity":{"consumed":46,"unitPrice":3500,"amount":161000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2351000, 2351000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 7, 2025, '{"rent":3500000,"electricity":{"consumed":78,"unitPrice":3500,"amount":273000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 4023000, 4023000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 7, 2025, '{"rent":2000000,"electricity":{"consumed":77,"unitPrice":3500,"amount":269500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2499500, 2499500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 7, 2025, '{"rent":2000000,"electricity":{"consumed":56,"unitPrice":3500,"amount":196000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2406000, 2406000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 7, 2025, '{"rent":3500000,"electricity":{"consumed":45,"unitPrice":3500,"amount":157500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 3947500, 3947500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 7, 2025, '{"rent":2000000,"electricity":{"consumed":71,"unitPrice":3500,"amount":248500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2518500, 2518500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 7, 2025, '{"rent":2000000,"electricity":{"consumed":50,"unitPrice":3500,"amount":175000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2385000, 2385000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 7, 2025, '{"rent":3500000,"electricity":{"consumed":48,"unitPrice":3500,"amount":168000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 3898000, 3898000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 7, 2025, '{"rent":2000000,"electricity":{"consumed":80,"unitPrice":3500,"amount":280000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2510000, 2510000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 7, 2025, '{"rent":2000000,"electricity":{"consumed":49,"unitPrice":3500,"amount":171500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2361500, 2361500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 7, 2025, '{"rent":3500000,"electricity":{"consumed":44,"unitPrice":3500,"amount":154000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 3924000, 3924000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 7, 2025, '{"rent":2000000,"electricity":{"consumed":71,"unitPrice":3500,"amount":248500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2538500, 2538500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 7, 2025, '{"rent":2000000,"electricity":{"consumed":67,"unitPrice":3500,"amount":234500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2504500, 2504500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'ee000000-0000-0000-0000-000000000005', 2, 'Sự cố tháng 7/2025', 'Đã báo cáo từ 7/2025', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'ee000000-0000-0000-0000-000000000014', 3, 'Sự cố tháng 7/2025', 'Đã báo cáo từ 7/2025', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'ee000000-0000-0000-0000-000000000011', 2, 'Sự cố tháng 7/2025', 'Đã báo cáo từ 7/2025', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 8, 2025, '{"rent":2000000,"electricity":{"consumed":44,"unitPrice":3500,"amount":154000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2384000, 2384000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 8, 2025, '{"rent":2000000,"electricity":{"consumed":55,"unitPrice":3500,"amount":192500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2462500, 2462500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 8, 2025, '{"rent":3500000,"electricity":{"consumed":50,"unitPrice":3500,"amount":175000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 3945000, 3945000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 8, 2025, '{"rent":2000000,"electricity":{"consumed":39,"unitPrice":3500,"amount":136500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2326500, 2326500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 8, 2025, '{"rent":2000000,"electricity":{"consumed":48,"unitPrice":3500,"amount":168000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2378000, 2378000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 8, 2025, '{"rent":3500000,"electricity":{"consumed":33,"unitPrice":3500,"amount":115500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 3825500, 3825500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 8, 2025, '{"rent":2000000,"electricity":{"consumed":47,"unitPrice":3500,"amount":164500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2354500, 2354500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 8, 2025, '{"rent":2000000,"electricity":{"consumed":50,"unitPrice":3500,"amount":175000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2365000, 2365000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 8, 2025, '{"rent":3500000,"electricity":{"consumed":45,"unitPrice":3500,"amount":157500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 3907500, 3907500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 8, 2025, '{"rent":2000000,"electricity":{"consumed":56,"unitPrice":3500,"amount":196000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2426000, 2426000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 8, 2025, '{"rent":2000000,"electricity":{"consumed":79,"unitPrice":3500,"amount":276500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2506500, 2506500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 8, 2025, '{"rent":3500000,"electricity":{"consumed":43,"unitPrice":3500,"amount":150500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 3900500, 3900500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 8, 2025, '{"rent":2000000,"electricity":{"consumed":57,"unitPrice":3500,"amount":199500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2429500, 2429500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 8, 2025, '{"rent":2000000,"electricity":{"consumed":45,"unitPrice":3500,"amount":157500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2407500, 2407500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'ee000000-0000-0000-0000-000000000010', 3, 'Sự cố tháng 8/2025', 'Đã báo cáo từ 8/2025', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'ee000000-0000-0000-0000-000000000008', 2, 'Sự cố tháng 8/2025', 'Đã báo cáo từ 8/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 9, 2025, '{"rent":2000000,"electricity":{"consumed":56,"unitPrice":3500,"amount":196000},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2486000, 2486000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 9, 2025, '{"rent":2000000,"electricity":{"consumed":61,"unitPrice":3500,"amount":213500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2423500, 2423500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 9, 2025, '{"rent":3500000,"electricity":{"consumed":33,"unitPrice":3500,"amount":115500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 3825500, 3825500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 9, 2025, '{"rent":2000000,"electricity":{"consumed":52,"unitPrice":3500,"amount":182000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2452000, 2452000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 9, 2025, '{"rent":2000000,"electricity":{"consumed":61,"unitPrice":3500,"amount":213500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2423500, 2423500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 9, 2025, '{"rent":3500000,"electricity":{"consumed":68,"unitPrice":3500,"amount":238000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3928000, 3928000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 9, 2025, '{"rent":2000000,"electricity":{"consumed":47,"unitPrice":3500,"amount":164500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2374500, 2374500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 9, 2025, '{"rent":2000000,"electricity":{"consumed":57,"unitPrice":3500,"amount":199500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2489500, 2489500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 9, 2025, '{"rent":3500000,"electricity":{"consumed":65,"unitPrice":3500,"amount":227500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 3957500, 3957500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 9, 2025, '{"rent":2000000,"electricity":{"consumed":36,"unitPrice":3500,"amount":126000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2396000, 2396000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 9, 2025, '{"rent":2000000,"electricity":{"consumed":60,"unitPrice":3500,"amount":210000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2400000, 2400000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 9, 2025, '{"rent":3500000,"electricity":{"consumed":46,"unitPrice":3500,"amount":161000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 3891000, 3891000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 9, 2025, '{"rent":2000000,"electricity":{"consumed":54,"unitPrice":3500,"amount":189000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2439000, 2439000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 9, 2025, '{"rent":2000000,"electricity":{"consumed":61,"unitPrice":3500,"amount":213500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2483500, 2483500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'ee000000-0000-0000-0000-000000000006', 2, 'Sự cố tháng 9/2025', 'Đã báo cáo từ 9/2025', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'ee000000-0000-0000-0000-000000000007', 0, 'Sự cố tháng 9/2025', 'Đã báo cáo từ 9/2025', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 10, 2025, '{"rent":2000000,"electricity":{"consumed":62,"unitPrice":3500,"amount":217000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2447000, 2447000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 10, 2025, '{"rent":2000000,"electricity":{"consumed":31,"unitPrice":3500,"amount":108500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2398500, 2398500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 10, 2025, '{"rent":3500000,"electricity":{"consumed":64,"unitPrice":3500,"amount":224000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 3934000, 3934000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 10, 2025, '{"rent":2000000,"electricity":{"consumed":80,"unitPrice":3500,"amount":280000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2510000, 2510000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 10, 2025, '{"rent":2000000,"electricity":{"consumed":39,"unitPrice":3500,"amount":136500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2386500, 2386500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 10, 2025, '{"rent":3500000,"electricity":{"consumed":72,"unitPrice":3500,"amount":252000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 3962000, 3962000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 10, 2025, '{"rent":2000000,"electricity":{"consumed":47,"unitPrice":3500,"amount":164500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2374500, 2374500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 10, 2025, '{"rent":2000000,"electricity":{"consumed":30,"unitPrice":3500,"amount":105000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2355000, 2355000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 10, 2025, '{"rent":3500000,"electricity":{"consumed":49,"unitPrice":3500,"amount":171500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 3921500, 3921500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 10, 2025, '{"rent":2000000,"electricity":{"consumed":70,"unitPrice":3500,"amount":245000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2455000, 2455000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 10, 2025, '{"rent":2000000,"electricity":{"consumed":35,"unitPrice":3500,"amount":122500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2332500, 2332500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 10, 2025, '{"rent":3500000,"electricity":{"consumed":71,"unitPrice":3500,"amount":248500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 4018500, 4018500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 10, 2025, '{"rent":2000000,"electricity":{"consumed":45,"unitPrice":3500,"amount":157500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2427500, 2427500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 10, 2025, '{"rent":2000000,"electricity":{"consumed":46,"unitPrice":3500,"amount":161000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2411000, 2411000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'ee000000-0000-0000-0000-000000000001', 3, 'Sự cố tháng 10/2025', 'Đã báo cáo từ 10/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'ee000000-0000-0000-0000-000000000010', 2, 'Sự cố tháng 10/2025', 'Đã báo cáo từ 10/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'ee000000-0000-0000-0000-000000000003', 3, 'Sự cố tháng 10/2025', 'Đã báo cáo từ 10/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 11, 2025, '{"rent":2000000,"electricity":{"consumed":52,"unitPrice":3500,"amount":182000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2372000, 2372000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 11, 2025, '{"rent":2000000,"electricity":{"consumed":42,"unitPrice":3500,"amount":147000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2377000, 2377000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 11, 2025, '{"rent":3500000,"electricity":{"consumed":71,"unitPrice":3500,"amount":248500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 3998500, 3998500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 11, 2025, '{"rent":2000000,"electricity":{"consumed":30,"unitPrice":3500,"amount":105000},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2395000, 2395000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 11, 2025, '{"rent":2000000,"electricity":{"consumed":49,"unitPrice":3500,"amount":171500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2361500, 2361500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 11, 2025, '{"rent":3500000,"electricity":{"consumed":47,"unitPrice":3500,"amount":164500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 3954500, 3954500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 11, 2025, '{"rent":2000000,"electricity":{"consumed":77,"unitPrice":3500,"amount":269500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2499500, 2499500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 11, 2025, '{"rent":2000000,"electricity":{"consumed":38,"unitPrice":3500,"amount":133000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2363000, 2363000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 11, 2025, '{"rent":3500000,"electricity":{"consumed":65,"unitPrice":3500,"amount":227500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3917500, 3917500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 11, 2025, '{"rent":2000000,"electricity":{"consumed":47,"unitPrice":3500,"amount":164500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2414500, 2414500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 11, 2025, '{"rent":2000000,"electricity":{"consumed":47,"unitPrice":3500,"amount":164500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2394500, 2394500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 11, 2025, '{"rent":3500000,"electricity":{"consumed":76,"unitPrice":3500,"amount":266000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 4036000, 4036000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 11, 2025, '{"rent":2000000,"electricity":{"consumed":32,"unitPrice":3500,"amount":112000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2342000, 2342000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 11, 2025, '{"rent":2000000,"electricity":{"consumed":33,"unitPrice":3500,"amount":115500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2405500, 2405500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'ee000000-0000-0000-0000-000000000004', 0, 'Sự cố tháng 11/2025', 'Đã báo cáo từ 11/2025', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 12, 2025, '{"rent":2000000,"electricity":{"consumed":35,"unitPrice":3500,"amount":122500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2372500, 2372500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 12, 2025, '{"rent":2000000,"electricity":{"consumed":54,"unitPrice":3500,"amount":189000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2459000, 2459000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 12, 2025, '{"rent":3500000,"electricity":{"consumed":72,"unitPrice":3500,"amount":252000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 3982000, 3982000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 12, 2025, '{"rent":2000000,"electricity":{"consumed":78,"unitPrice":3500,"amount":273000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2503000, 2503000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 12, 2025, '{"rent":2000000,"electricity":{"consumed":56,"unitPrice":3500,"amount":196000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2466000, 2466000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 12, 2025, '{"rent":3500000,"electricity":{"consumed":57,"unitPrice":3500,"amount":199500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 3969500, 3969500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 12, 2025, '{"rent":2000000,"electricity":{"consumed":44,"unitPrice":3500,"amount":154000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2424000, 2424000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 12, 2025, '{"rent":2000000,"electricity":{"consumed":51,"unitPrice":3500,"amount":178500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2468500, 2468500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 12, 2025, '{"rent":3500000,"electricity":{"consumed":72,"unitPrice":3500,"amount":252000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 4022000, 4022000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 12, 2025, '{"rent":2000000,"electricity":{"consumed":70,"unitPrice":3500,"amount":245000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2515000, 2515000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 12, 2025, '{"rent":2000000,"electricity":{"consumed":74,"unitPrice":3500,"amount":259000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2489000, 2489000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 12, 2025, '{"rent":3500000,"electricity":{"consumed":79,"unitPrice":3500,"amount":276500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 4026500, 4026500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 12, 2025, '{"rent":2000000,"electricity":{"consumed":52,"unitPrice":3500,"amount":182000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2412000, 2412000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 12, 2025, '{"rent":2000000,"electricity":{"consumed":39,"unitPrice":3500,"amount":136500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2406500, 2406500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'ee000000-0000-0000-0000-000000000001', 3, 'Sự cố tháng 12/2025', 'Đã báo cáo từ 12/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'ee000000-0000-0000-0000-000000000014', 2, 'Sự cố tháng 12/2025', 'Đã báo cáo từ 12/2025', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 1, 2026, '{"rent":2000000,"electricity":{"consumed":73,"unitPrice":3500,"amount":255500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2445500, 2445500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 1, 2026, '{"rent":2000000,"electricity":{"consumed":73,"unitPrice":3500,"amount":255500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2545500, 2545500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 1, 2026, '{"rent":3500000,"electricity":{"consumed":59,"unitPrice":3500,"amount":206500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 3956500, 3956500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 1, 2026, '{"rent":2000000,"electricity":{"consumed":57,"unitPrice":3500,"amount":199500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2449500, 2449500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 1, 2026, '{"rent":2000000,"electricity":{"consumed":63,"unitPrice":3500,"amount":220500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2470500, 2470500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 1, 2026, '{"rent":3500000,"electricity":{"consumed":73,"unitPrice":3500,"amount":255500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 4005500, 4005500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 1, 2026, '{"rent":2000000,"electricity":{"consumed":57,"unitPrice":3500,"amount":199500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2389500, 2389500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 1, 2026, '{"rent":2000000,"electricity":{"consumed":64,"unitPrice":3500,"amount":224000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2414000, 2414000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 1, 2026, '{"rent":3500000,"electricity":{"consumed":67,"unitPrice":3500,"amount":234500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3924500, 3924500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 1, 2026, '{"rent":2000000,"electricity":{"consumed":42,"unitPrice":3500,"amount":147000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2337000, 2337000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 1, 2026, '{"rent":2000000,"electricity":{"consumed":74,"unitPrice":3500,"amount":259000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2489000, 2489000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 1, 2026, '{"rent":3500000,"electricity":{"consumed":72,"unitPrice":3500,"amount":252000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 3982000, 3982000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 1, 2026, '{"rent":2000000,"electricity":{"consumed":65,"unitPrice":3500,"amount":227500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2497500, 2497500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 1, 2026, '{"rent":2000000,"electricity":{"consumed":31,"unitPrice":3500,"amount":108500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2398500, 2398500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'ee000000-0000-0000-0000-000000000007', 1, 'Sự cố tháng 1/2026', 'Đã báo cáo từ 1/2026', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'ee000000-0000-0000-0000-000000000005', 1, 'Sự cố tháng 1/2026', 'Đã báo cáo từ 1/2026', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'ee000000-0000-0000-0000-000000000013', 3, 'Sự cố tháng 1/2026', 'Đã báo cáo từ 1/2026', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 2, 2026, '{"rent":2000000,"electricity":{"consumed":77,"unitPrice":3500,"amount":269500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2479500, 2479500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 2, 2026, '{"rent":2000000,"electricity":{"consumed":42,"unitPrice":3500,"amount":147000},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2437000, 2437000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 2, 2026, '{"rent":3500000,"electricity":{"consumed":46,"unitPrice":3500,"amount":161000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3851000, 3851000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 2, 2026, '{"rent":2000000,"electricity":{"consumed":34,"unitPrice":3500,"amount":119000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2369000, 2369000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 2, 2026, '{"rent":2000000,"electricity":{"consumed":54,"unitPrice":3500,"amount":189000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2459000, 2459000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 2, 2026, '{"rent":3500000,"electricity":{"consumed":71,"unitPrice":3500,"amount":248500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 4018500, 4018500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 2, 2026, '{"rent":2000000,"electricity":{"consumed":72,"unitPrice":3500,"amount":252000},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2462000, 2462000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 2, 2026, '{"rent":2000000,"electricity":{"consumed":33,"unitPrice":3500,"amount":115500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2365500, 2365500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 2, 2026, '{"rent":3500000,"electricity":{"consumed":40,"unitPrice":3500,"amount":140000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 3830000, 3830000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 2, 2026, '{"rent":2000000,"electricity":{"consumed":52,"unitPrice":3500,"amount":182000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2372000, 2372000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 2, 2026, '{"rent":2000000,"electricity":{"consumed":42,"unitPrice":3500,"amount":147000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2417000, 2417000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 2, 2026, '{"rent":3500000,"electricity":{"consumed":43,"unitPrice":3500,"amount":150500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 3920500, 3920500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 2, 2026, '{"rent":2000000,"electricity":{"consumed":65,"unitPrice":3500,"amount":227500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2497500, 2497500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 2, 2026, '{"rent":2000000,"electricity":{"consumed":64,"unitPrice":3500,"amount":224000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2494000, 2494000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'ee000000-0000-0000-0000-000000000006', 3, 'Sự cố tháng 2/2026', 'Đã báo cáo từ 2/2026', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'ee000000-0000-0000-0000-000000000004', 1, 'Sự cố tháng 2/2026', 'Đã báo cáo từ 2/2026', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'ee000000-0000-0000-0000-000000000005', 2, 'Sự cố tháng 2/2026', 'Đã báo cáo từ 2/2026', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'ee000000-0000-0000-0000-000000000008', 3, 'Sự cố tháng 2/2026', 'Đã báo cáo từ 2/2026', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 3, 2026, '{"rent":2000000,"electricity":{"consumed":76,"unitPrice":3500,"amount":266000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2456000, 2456000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 3, 2026, '{"rent":2000000,"electricity":{"consumed":78,"unitPrice":3500,"amount":273000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2543000, 2543000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 3, 2026, '{"rent":3500000,"electricity":{"consumed":80,"unitPrice":3500,"amount":280000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 4050000, 4050000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 3, 2026, '{"rent":2000000,"electricity":{"consumed":51,"unitPrice":3500,"amount":178500},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 2468500, 2468500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 3, 2026, '{"rent":2000000,"electricity":{"consumed":35,"unitPrice":3500,"amount":122500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2372500, 2372500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 3, 2026, '{"rent":3500000,"electricity":{"consumed":69,"unitPrice":3500,"amount":241500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 3991500, 3991500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 3, 2026, '{"rent":2000000,"electricity":{"consumed":58,"unitPrice":3500,"amount":203000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2473000, 2473000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 3, 2026, '{"rent":2000000,"electricity":{"consumed":32,"unitPrice":3500,"amount":112000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2302000, 2302000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 3, 2026, '{"rent":3500000,"electricity":{"consumed":80,"unitPrice":3500,"amount":280000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 4050000, 4050000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 3, 2026, '{"rent":2000000,"electricity":{"consumed":71,"unitPrice":3500,"amount":248500},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2498500, 2498500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 3, 2026, '{"rent":2000000,"electricity":{"consumed":58,"unitPrice":3500,"amount":203000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2393000, 2393000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 3, 2026, '{"rent":3500000,"electricity":{"consumed":48,"unitPrice":3500,"amount":168000},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 3958000, 3958000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 3, 2026, '{"rent":2000000,"electricity":{"consumed":44,"unitPrice":3500,"amount":154000},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2424000, 2424000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 3, 2026, '{"rent":2000000,"electricity":{"consumed":38,"unitPrice":3500,"amount":133000},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2323000, 2323000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'ee000000-0000-0000-0000-000000000001', 0, 'Sự cố tháng 3/2026', 'Đã báo cáo từ 3/2026', ARRAY[]::text[], 2, 2, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'ee000000-0000-0000-0000-000000000014', 0, 'Sự cố tháng 3/2026', 'Đã báo cáo từ 3/2026', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'ee000000-0000-0000-0000-000000000011', 0, 'Sự cố tháng 3/2026', 'Đã báo cáo từ 3/2026', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000001', 'dd000000-0000-0000-0000-000000000001', 4, 2026, '{"rent":2000000,"electricity":{"consumed":62,"unitPrice":3500,"amount":217000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2447000, 2447000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000002', 'dd000000-0000-0000-0000-000000000002', 4, 2026, '{"rent":2000000,"electricity":{"consumed":54,"unitPrice":3500,"amount":189000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2439000, 2439000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'dd000000-0000-0000-0000-000000000003', 4, 2026, '{"rent":3500000,"electricity":{"consumed":70,"unitPrice":3500,"amount":245000},"water":{"consumed":8,"unitPrice":20000,"amount":160000},"internet":100000,"garbage":30000}', 4035000, 4035000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'dd000000-0000-0000-0000-000000000004', 4, 2026, '{"rent":2000000,"electricity":{"consumed":79,"unitPrice":3500,"amount":276500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2506500, 0, 3, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000005', 'dd000000-0000-0000-0000-000000000005', 4, 2026, '{"rent":2000000,"electricity":{"consumed":33,"unitPrice":3500,"amount":115500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2325500, 2325500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000006', 'dd000000-0000-0000-0000-000000000006', 4, 2026, '{"rent":3500000,"electricity":{"consumed":75,"unitPrice":3500,"amount":262500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 3972500, 3972500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'dd000000-0000-0000-0000-000000000007', 4, 2026, '{"rent":2000000,"electricity":{"consumed":51,"unitPrice":3500,"amount":178500},"water":{"consumed":3,"unitPrice":20000,"amount":60000},"internet":100000,"garbage":30000}', 2368500, 2368500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000008', 'dd000000-0000-0000-0000-000000000008', 4, 2026, '{"rent":2000000,"electricity":{"consumed":39,"unitPrice":3500,"amount":136500},"water":{"consumed":4,"unitPrice":20000,"amount":80000},"internet":100000,"garbage":30000}', 2346500, 0, 3, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000009', 'dd000000-0000-0000-0000-000000000009', 4, 2026, '{"rent":3500000,"electricity":{"consumed":76,"unitPrice":3500,"amount":266000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 3996000, 3996000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000010', 'dd000000-0000-0000-0000-000000000010', 4, 2026, '{"rent":2000000,"electricity":{"consumed":74,"unitPrice":3500,"amount":259000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 2509000, 2509000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000011', 'dd000000-0000-0000-0000-000000000011', 4, 2026, '{"rent":2000000,"electricity":{"consumed":80,"unitPrice":3500,"amount":280000},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2510000, 2510000, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000012', 'dd000000-0000-0000-0000-000000000012', 4, 2026, '{"rent":3500000,"electricity":{"consumed":74,"unitPrice":3500,"amount":259000},"water":{"consumed":6,"unitPrice":20000,"amount":120000},"internet":100000,"garbage":30000}', 4009000, 0, 3, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000013', 'dd000000-0000-0000-0000-000000000013', 4, 2026, '{"rent":2000000,"electricity":{"consumed":43,"unitPrice":3500,"amount":150500},"water":{"consumed":5,"unitPrice":20000,"amount":100000},"internet":100000,"garbage":30000}', 2380500, 2380500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO invoices (id, room_id, contract_id, month, year, breakdown_json, total_amount, paid_amount, status, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000014', 'dd000000-0000-0000-0000-000000000014', 4, 2026, '{"rent":2000000,"electricity":{"consumed":37,"unitPrice":3500,"amount":129500},"water":{"consumed":7,"unitPrice":20000,"amount":140000},"internet":100000,"garbage":30000}', 2399500, 2399500, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000003', 'ee000000-0000-0000-0000-000000000012', 1, 'Sự cố tháng 4/2026', 'Đã báo cáo từ 4/2026', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'ee000000-0000-0000-0000-000000000004', 2, 'Sự cố tháng 4/2026', 'Đã báo cáo từ 4/2026', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000007', 'ee000000-0000-0000-0000-000000000006', 2, 'Sự cố tháng 4/2026', 'Đã báo cáo từ 4/2026', ARRAY[]::text[], 2, 1, false, '2026-01-01', '2026-01-01');
INSERT INTO tickets (id, room_id, tenant_id, category, title, description, photo_urls, status, priority, is_deleted, created_at, updated_at) VALUES 
        (gen_random_uuid(), 'cc000000-0000-0000-0000-000000000004', 'ee000000-0000-0000-0000-000000000004', 2, 'Sự cố tháng 4/2026', 'Đã báo cáo từ 4/2026', ARRAY[]::text[], 2, 0, false, '2026-01-01', '2026-01-01');
