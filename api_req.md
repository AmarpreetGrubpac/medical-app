# API Audit and Requirements 

---

## 1. Authentication & Account Resources

### Endpoint Mapping

| Action | HTTP Method | Path | Description |
|---|---|---|---|
| **Check Account Status** | `POST` | `/api/v1/delivery-mobile/auth/check-account` | Checks if phone number or email is registered. |
| **Send OTP** | `POST` | `/api/v1/delivery-mobile/auth/send-otp` | Sends/resends a OTP code to phone/email. |
| **Verify OTP (Login)** | `POST` | `/api/v1/delivery-mobile/auth/verify-otp` | Validates OTP and returns an authentication token. |
| **Set Password (First Setup)** | `POST` | `/api/v1/delivery-mobile/auth/set-password` | Configures password for first-time account initialization. |
| **Login with Password** | `POST` | `/api/v1/delivery-mobile/auth/login` | Authenticates existing user with phone/email and password. |
| **Logout** | `POST` | `/api/v1/delivery-mobile/auth/logout` | Revokes the current session's token. |
| **Forgot Password - Send OTP** | `POST` | `/api/v1/delivery-mobile/auth/forget-password/otp/send` | Initiates forgot password flow by sending an OTP. |
| **Forgot Password - Verify OTP** | `POST` | `/api/v1/delivery-mobile/auth/forget-password/otp/verify` | Verifies the forgot password verification OTP code. |
| **Forgot Password - Set Password** | `POST` | `/api/v1/delivery-mobile/auth/forget-password/set-password` | Sets the new password after successful OTP verification. |
| **Update Password** | `PATCH` | `/api/v1/delivery-mobile/account/password` | Changes the password for an authenticated user. |
| **Delete Account** | `DELETE` | `/api/v1/delivery-mobile/account` | Permanently deletes the authenticated user's account. |

---

## 2. Profile Resource

### Endpoint Mapping

| Action | HTTP Method | Path | Description |
|---|---|---|---|
| **Get Profile Details** | `GET` | `/api/v1/delivery-mobile/profile` | Fetches the authenticated user's profile details. |
| **Update Profile** | `PATCH` | `/api/v1/delivery-mobile/profile` | Updates fields like first name, last name, or profile photo. |

### Payload Contract (GET /profile Response)
```json
{
  "success": true,
  "code": 200,
  "data": {
    "employee_id": "01KPD-1234",
    "first_name": "Amarpreet",
    "last_name": "Singh",
    "email": "amarkounsal@gmail.com",
    "mobile_number": "1234567890",
    "country_code": "+91",
    "role": "driver",
    "joining_date": "2026-06-24T12:00:00Z",
    "profile_pic": "https://grubpac.s3.ap-south-1.amazonaws.com/profile/driver_1.jpg"
  }
}
```

---

## 3. Box Management & Operations (Telemetry / Control)

Currently, the app implements box management and detailed controls (such as temperature sliders, ioniser toggles, lock/unlock OTP dialogs, connection error states) using client-side mock data inside `BoxManagementController`, `BoxDetailsController`, and `ScanBoxController`.

We define a resource-oriented REST specification for `/boxes` below.

### Endpoint Mapping

| Action | HTTP Method | Path | Description |
|---|---|---|---|
| **List Boxes** | `GET` | `/api/v1/delivery-mobile/boxes` | Lists all boxes registered/assigned to the current driver. |
| **Register Box (Add Box)** | `POST` | `/api/v1/delivery-mobile/boxes` | Registers a box to the driver (typically via scanned QR/barcode string). |
| **Get Box Details** | `GET` | `/api/v1/delivery-mobile/boxes/{box_id}` | Retrieves real-time status and telemetry of a specific box. |
| **Remove Box (Unlink)** | `DELETE` | `/api/v1/delivery-mobile/boxes/{box_id}` | Unlinks the box from the driver. |
| **Update Box Settings** | `PATCH` | `/api/v1/delivery-mobile/boxes/{box_id}/settings` | Updates target temperatures or toggles peripherals (advert, ioniser, light). |
| **Connect Box** | `POST` | `/api/v1/delivery-mobile/boxes/{box_id}/connection` | Starts connection (Bluetooth/active state link on backend). |
| **Disconnect Box** | `DELETE` | `/api/v1/delivery-mobile/boxes/{box_id}/connection` | Stops the connection state. |
| **Request Lock OTP** | `POST` | `/api/v1/delivery-mobile/boxes/{box_id}/lock/otp` | Requests a new security OTP to trigger unlock mechanism. |
| **Verify Lock OTP** | `POST` | `/api/v1/delivery-mobile/boxes/{box_id}/lock/verify` | Submits the 4-digit code to execute physical lock/unlock. |

---

### REST Resource Contracts (Box Operations)

#### A. Register Box (`POST /api/v1/delivery-mobile/boxes`)
**Request Body**:
```json
{
  "scanned_code": "GP-BOX-556102"
}
```
**Response**:
```json
{
  "success": true,
  "code": 201,
  "message": "Box registered successfully",
  "data": {
    "box_id": "GP-BOX-556102",
    "name": "Box #556102",
    "is_connected": false,
    "battery_level": 100,
    "is_locked": true
  }
}
```

#### B. Update Box Settings (`PATCH /api/v1/delivery-mobile/boxes/{box_id}/settings`)
**Request Body**: (all fields optional for partial updates)
```json
{
  "is_dual_zone": true,
  "zone_1_temp": -5,
  "zone_2_temp": 25,
  "advert_display_enabled": true,
  "ioniser_enabled": false,
  "light_enabled": true
}
```
**Response**:
```json
{
  "success": true,
  "code": 200,
  "message": "Box settings updated successfully",
  "data": {
    "box_id": "GP-BOX-556102",
    "settings": {
      "is_dual_zone": true,
      "zone_1_temp": -5,
      "zone_2_temp": 25,
      "advert_display_enabled": true,
      "ioniser_enabled": false,
      "light_enabled": true
    }
  }
}
```

#### C. Request Lock OTP (`POST /api/v1/delivery-mobile/boxes/{box_id}/lock/otp`)
**Request Body**:
```json
{
  "action": "unlock"
}
```
**Response**:
```json
{
  "success": true,
  "code": 200,
  "message": "Unlock OTP sent successfully"
}
```

#### D. Verify Lock OTP (`POST /api/v1/delivery-mobile/boxes/{box_id}/lock/verify`)
**Request Body**:
```json
{
  "code": "1111",
  "action": "unlock"
}
```
**Response**:
```json
{
  "success": true,
  "code": 200,
  "message": "Grublock unlocked successfully"
}
```

---

## 4. Alerts & Notifications Resource

### Endpoint Mapping

| Action | HTTP Method | Path | Description |
|---|---|---|---|
| **List Alerts** | `GET` | `/api/v1/delivery-mobile/alerts` | Fetches the logs and alert notifications history (battery alerts, temp deviation). |

---

## 5. Support & FAQ Resources

### Endpoint Mapping

| Action | HTTP Method | Path | Description |
|---|---|---|---|
| **List Categories** | `GET` | `/api/v1/delivery/support/categories` | Lists FAQ categories (e.g. Box, Payments, App). |
| **List FAQs** | `GET` | `/api/v1/delivery/support/faqs` | Fetches answers. Filterable by `category_id` (via query parameter). |

