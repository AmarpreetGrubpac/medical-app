# Medical Owner API Migration Design

## Status

APPROVED after user validation and structured review. The arbiter found no unresolved design blocker. Successful claim and direct-lock integration remain pending an assigned test box.

## Understanding summary

- Use `https://43.204.34.10/api/v1` as the current development base URL, supplied through configuration rather than embedded as an unconditional production endpoint.
- Migrate active delivery routes to the Medical Owner vertical at `/medical-mobile/owner`.
- Preserve existing box request and response models.
- Preserve the Flutter/GetX architecture and current screens where their behavior remains valid.
- Update delivery-driver wording in retained screens so the Medical Owner role, recovery guidance, box claim action, and lock action are described accurately.
- Replace QR registration with owner box claiming while retaining the scanner's `box_display_id` value.
- Replace the lock OTP flow with the Medical Owner direct lock/unlock flow.
- Migrate notification and support access used by current screens. Document dashboard, box location, bulk GrubLock, and support-answer contracts without adding unused repository methods.
- Do not add endpoints marked blocked in the supplied endpoint document.

## Verified API behavior

- Medical Owner login accepts the existing `{type, body, password}` payload and returns `auth_token`, `refresh_token`, and `is_password_set`.
- Health and config use the existing `{success, code, message?, data}` envelope.
- `/account/me` and `/profile` return the same owner profile object.
- `/boxes` returns an array in `data`; the test owner currently has no boxes.
- `/boxes/claim` accepts either `display_id` or `box_display_id`.
- Bulk GrubLock endpoints expect `{ids: [...]}`.
- `/support/answer` requires `id` or `faq_id`.
- Notification data contains `total`, `unread_count`, `data`, `current_page`, `total_pages`, and `context_box`.
- Error responses may include `error_toast_title` and `error_toast_description`.

## Assumptions

- Box list, detail, settings, connection, claim, removal, and lock request/response shapes remain compatible with the existing box model, as confirmed by the user. Owner-specific connection semantics must not infer disconnection merely because `driver_id` differs from the owner profile ID.
- Existing API latency and availability expectations remain unchanged. Owner accounts may contain more boxes than driver accounts, so client polling must not scale through overlapping per-box cycles in release.
- Bearer authentication and refresh-token behavior remain unchanged.
- Optional fields from profile, dashboard, location, notification, and support responses may be absent or null.
- Simulator endpoints remain outside the Medical Owner route prefix.

## Architecture

Define `/medical-mobile/owner` once in `AppConstants` and compose feature routes from it. Keep repository interfaces and response models stable for unchanged contracts. Update only routes and workflows that differ in the Medical Owner vertical.

Supply the API base URL through `--dart-define`. The provided IP URL is available only in a debug branch. A release build without an explicitly supplied trusted HTTPS URL must fail closed during configuration rather than silently use the IP. Never disable certificate validation in release builds. Any development-only certificate override must be guarded by `kDebugMode`; production requires a hostname and certificate chain trusted by the platform.

Repository changes:

- Point auth, profile, config, box, notification, and support routes to the Medical Owner prefix.
- Use `/boxes/claim` with `box_display_id` for the existing scanner flow. This is a verified new-endpoint exception to the otherwise unchanged box payloads; the old registration endpoint used `scanned_code`.
- Replace lock OTP repository calls with direct `PATCH /boxes/:box_id/lock` using `{action: "lock" | "unlock"}`, preserving the existing action field as requested. The successful response remains unverified until a test box is assigned.
- Do not add dashboard, box location, bulk GrubLock, or support-answer methods without an active consumer.
- Keep simulator health calls separate.
- Remove unconditional logging of tokens, authorization headers, passwords, OTPs, refresh tokens, and full response bodies. Diagnostic logging must be debug-only and redact sensitive fields.
- Add an explicit retry marker so an unauthorized request can refresh and retry at most once.
- Mark requests explicitly as public or authenticated. Only authenticated requests may refresh; retries must rebuild authorization from the newly stored token instead of reusing an explicit stale header.
- Build query strings through `Uri` query parameters rather than raw concatenation.
- Store access and refresh tokens in platform-backed secure storage. On first access, migrate and remove legacy token values from `SharedPreferences`; logout removes values from both stores.

## Behavior and data flow

Authentication keeps its current screens and coordinated refresh behavior. Tokens move to secure storage behind a small token-store abstraction so repositories do not depend on storage details. Box claim parses the response with `BoxInfo`. Existing box list, details, settings, connection, and removal flows continue to use their current models.

Lock and unlock controls state the pending action explicitly (`Lock` or `Unlock`) and show a confirmation containing the box name/display ID before sending the command. Confirmation sends one direct request, prevents duplicate taps while pending, refreshes authoritative box data on success, and does not request an OTP. OTP state, timers, methods, and OTP-specific bottom sheets must be removed or disconnected consistently from `HomeController`, `BoxDetailsController`, and `BoxManagementController`.

The scanner remains the claim input, but its copy explains that scanning claims a box already assigned to the owner's organization. Success copy says the box was claimed. Invalid or unassigned codes preserve the scanner and show the normalized backend error.

`ApiClient` normalizes API errors without string-prefix inspection. Error priority is `error_toast_description`, `error`, `message`, then HTTP status text; controllers consume the normalized status text. A protected-request 401 triggers one coordinated refresh and one request retry. A definitive refresh rejection such as 401/403 clears the session; connectivity failures, timeouts, malformed responses, and 5xx responses preserve the session and return a retryable error.

Notification pagination appends pages without replacing previously loaded alerts and shows a visible loading-more state. Local filters describe results as applying to loaded alerts while additional pages exist; a final “no matching alerts” state appears only after all pages are loaded. The repository exposes encoded page and limit parameters, and the controller prevents overlapping page requests.

Boxes and support screens model loading, loaded-empty, loaded-data, and failed states separately. A failed initial request shows its error with a retry action and never falls through to the add-box or no-results state. Loading flags are cleared in `finally` paths on both success and failure.

Simulator heartbeat polling is development-only. It pauses when the app is not active, permits only one polling cycle at a time, and uses bounded concurrency. Release builds do not call simulator endpoints. This avoids per-box background traffic and overlapping timer cycles for owner accounts with many boxes.

## Edge cases

- Treat an empty box list as a successful empty state.
- Never present a fetch failure as an empty box or support result.
- Do not add a box locally when claim fails or returns an invalid body.
- Prevent duplicate box commands while a request is pending.
- Refresh box data after successful claim, lock, connection, removal, or settings changes.
- Preserve the last valid box state when simulator health polling fails.
- Preserve the authenticated session during transient refresh failures.
- Never call endpoints marked blocked for this vertical.
- Do not mark an owner-visible box disconnected solely because it is connected to a different employee.
- Do not send a physical lock command until the owner confirms an explicitly named lock or unlock action.

## Validation

- Format modified Dart files and run static analysis.
- Add focused repository tests for paths, methods, and payloads where the project test structure supports them.
- Validate profile, dashboard, notification, and support parsing against captured authenticated response shapes.
- Search for active `/delivery-mobile` and `/delivery/support` references after migration.
- Manually verify login, token refresh, config, profile, support, notifications, and the empty box state against the live IP API.
- Mock successful box mutations using the user-confirmed unchanged box contracts. Record that successful claim and direct-lock integration remain unverified until a test box is assigned.
- Verify release builds do not install the permissive certificate override and logs do not contain credentials or tokens.
- Verify a repeated 401 performs no more than one refresh and one retry.
- Verify public auth requests never trigger refresh and authenticated retries use the new access token.
- Verify transient refresh failures retain stored tokens while a refresh 401/403 clears them.
- Verify legacy plaintext tokens migrate to secure storage and are removed from `SharedPreferences`.
- Verify query values are URI encoded and page/limit appear in the outgoing notification URL.
- Verify simulator polling is disabled in release, does not overlap, and pauses outside the active app lifecycle.
- Verify owner wording replaces driver/delivery wording in migrated screens and recovery messages.
- Verify lock/unlock labels and confirmation reflect the current box state on home, management, and detail screens.
- Verify claim copy explains ownership claiming and failed claims keep the scanner usable.
- Verify failed initial box/support loads show retry states while successful empty responses show empty states.
- Verify notification pages append once, concurrent loads are prevented, and filtered empty text remains qualified until the last page.

## Decision log

| Decision | Alternatives considered | Rationale | Objections | Resolution |
|---|---|---|---|---|
| Use one Medical Owner path prefix | Replace every route independently; create a parallel API module | Reduces missed routes without duplicating the data layer | A hardcoded production IP and global TLS bypass are unsafe | Configure the base URL; limit any bypass to debug; require trusted TLS in release |
| Preserve box models and payloads | Create new medical box models | The user confirmed the contracts remain unchanged | `BoxInfo` embeds delivery-driver connection semantics | Preserve fields but remove the owner-invalid `driver_id == profile user` disconnection inference |
| Reuse the scanner for box claim | Build a separate manual claim flow | The claim endpoint accepts the scanner's existing `box_display_id` | Old register used `scanned_code`, so the payload is not literally unchanged | Treat claim as a verified new endpoint and send `box_display_id` |
| Replace lock OTP with direct lock | Retain blocked OTP endpoints | The Medical Owner API explicitly provides direct lock/unlock | Direct-lock success contract is not observable without a box; OTP UI exists in three flows | Preserve the existing `action` field, remove all three OTP flows consistently, and record the integration-test limitation |
| Keep simulator APIs separate | Move them under the owner prefix | Simulator endpoints are not part of the mobile vertical | None | Accepted |
| Add new APIs only when consumed | Implement every listed route immediately | Limits scope to current app behavior and avoids unused code | Dashboard, location, bulk GrubLock, and support-answer have no active consumers | Document their contracts but do not implement unused methods |
| Normalize API errors centrally | Keep controller-specific `message`/`error` parsing | Makes new toast metadata consistently visible | Existing string-prefix checks and controller parsing bypass normalized status | Parse map keys directly and make controllers use normalized status text |
| Permit one refresh retry | Keep recursive retry behavior | Prevents infinite retry on audience, role, or scope failures | Current retry has no bound | Pass an explicit no-refresh-on-retry marker |
| Paginate notifications incrementally | Retain only the first page; preload all pages | Keeps network work bounded while preventing silent replacement | Local filters can misrepresent partial data as complete | Append pages, disclose partial filtering while more pages exist, and show final no-match only after the last page |
| Redact network diagnostics | Keep full debug logs | Credentials and tokens must not enter logs | Current code prints tokens, headers, bodies, and responses | Remove sensitive logs and keep only redacted debug metadata |
| Fail closed for release API configuration | Use the development IP as a universal default | Prevents accidental release traffic to an untrusted development endpoint | Missing defines could silently ship the IP and encourage TLS bypass | Permit the IP default only in debug; require an explicit trusted release URL |
| Store tokens securely | Retain plaintext `SharedPreferences` | Medical Owner bearer tokens expose profile and box-control access | Current tokens are readable from application preferences | Introduce a secure token store, migrate legacy values once, and clear both stores on logout |
| Classify refresh failures | Logout after every failed refresh | Avoids destroying valid sessions during outages | Timeouts and 5xx currently cause forced logout | Logout only on definitive 401/403 refresh rejection; preserve tokens on transient failures |
| Make request authentication explicit | Infer refresh behavior from status and URI | Prevents refresh attempts on public auth calls and stale-header retries | Arbitrary explicit headers can retain an old token | Add request authentication/retry options and rebuild auth headers on retry |
| Bound simulator polling | Preserve the four-second per-box timer in all builds | Prevents overlapping cycles and release traffic amplification | Owner accounts can contain more boxes and async timers can overlap | Make polling debug-only, lifecycle-aware, single-flight, and bounded |
| Encode query parameters centrally | Concatenate query strings in repositories | Handles search text and pagination safely and predictably | Current `getData(query:)` ignores its query map | Construct request URIs with encoded query parameters and test outgoing URLs |
| Audit owner-facing copy | Preserve delivery-driver wording | The app now represents a different role and vertical | Current recovery, role, delivery, link, and success text misleads owners | Update strings used by migrated screens and claim/lock flows |
| Confirm direct lock actions | Send the command immediately after a tap | Physical lock state changes need clear intent after OTP removal | Current icon and “GRUBLOCK” label do not identify the resulting action | Show explicit lock/unlock labels and a confirmation with box identity, without OTP |
| Separate loading outcomes | Keep list emptiness as the only screen-state signal | Prevents outages from appearing as valid empty accounts | Box and support failures can show empty content or endless loading | Add explicit loading, data, empty, and retryable failure states and clear flags in `finally` |
