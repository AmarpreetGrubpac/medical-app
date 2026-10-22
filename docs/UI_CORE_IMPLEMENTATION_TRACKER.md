# UI and functionality implementation tracker

Updated 22 October 2026. UI repairs were implemented first, followed by app-side functional repairs. Server changes are a handoff only, per your instruction: [server requirements](SERVER_FIX_REQUIREMENTS.md). Historical findings remain in the [original audit](../reports/preprod-2026-10-22/README.md).

**Validation:** 47 automated tests pass, all 14 captured live-payload model checks pass, and the Android development APK builds and installs. Analyzer: 0 errors, 35 warnings, 59 information findings; this is not a clean lint run. Both boxes still match their original complete snapshots.

Evidence: [screenshots](../reports/ui-core-repair/index.html), [suite](../reports/preprod-2026-10-22/repair-suite.log), [live-model checks](../reports/preprod-2026-10-22/live-contract-repair.log), [build](../reports/preprod-2026-10-22/repair-build.log), [analyzer](../reports/preprod-2026-10-22/repair-analysis.log), [box verification](../reports/ui-core-repair/box-state-verification.json).

DONE means the stated app change is implemented and checked. It does not imply server completion or full Figma visual sign-off. PARTIAL means repairs exist but the entire journey remains open.

## Phase 1: UI first

| Item | Status | Completed | Left |
|---|---|---|---|
| U01 baseline | DONE in code | App and journey harness use 390x844; login image adapts to longer reference text. | Matched device-scale visual comparisons. |
| U02 palette | DONE for captured light assets | OTP/trip and active carousel indicator use lavender. | Other uncaptured themes/pages need references. |
| U03 copy | DONE | Four reference carousel themes/order and empty-state wording restored. Existing login journey layouts pass. | Final design review of wording/artwork. |
| U04 tracking appearance | DONE for light journey | Theme colors, readable header, default light map, responsive lower panel. | Valid-GPS rendering and dark-map platform review. |
| U05 unknown battery | DONE | Null retained; unavailable aggregate/cells; neutral unknown status; removed fabricated defaults and runtime estimate. Heartbeat can clear previous readings. | Physical battery-loss/recovery test. |
| U06 zone-card fit | DONE for reproduced cases | Compact and expanded cards fit negative values and 200% text in narrow widget checks. | Broad accessibility/readability and physical viewports. |
| F13 profile | DONE | Initials/photo-error fallback, wrapped email, actual department/facility, honest unavailable fields. Owner runtime captured. | Owner and driver runtime profiles captured; remaining device/reference review. |
| Medical support labels | DONE | CALL FACILITY / ALERT FACILITY. | Contact and alert services below. |
| Exact design sign-off | LEFT | Captured references retained. | All reachable states need matched captures; owner-specific references and blocked OTP states remain. No pixel-match percentage claimed. |

## Phase 2: core app behavior

| Item | Status | Completed | Left |
|---|---|---|---|
| F05 alerts | DONE in app | Live body/severity/identity mapping; resolve known box names; stable fallback. Captured payload assertions all pass. | Seeded multi-box paging/push validation. |
| F10 context | DONE in app | Management/details Logs carry box ID; ID filtering and reset tested. Details Help opens main Help. | Complete runtime navigation sweep. |
| F06 OTP | PARTIAL / SERVER BLOCKED | Removed premature success and silent failure; 404 produces actionable error; loading resets. Regression proves no requested-success toast. | Request/verify/resend contract and complete recipient/OTP entry, expiry and replay flow. |
| F03 targets | PARTIAL / SERVER BLOCKED | Target and measurement separated; only changed target fields sent. Runtime displays target 4 degrees C vs measured 25 degrees C. | Server rejects target writes and omits targets in some reads. |
| F04 range | PARTIAL / SERVER BLOCKED | Rejects outside existing slider bounds (-20 to 70) and non-finite input. 999 sends no command in regression. | Backend enforcement and approved medical/device limits; UI bounds are not medical policy. |
| F19 rollback | DONE for reproduced failure | Previous target captured before edit; changes coalesced; writes blocked while pending; rejection restores previous state; heartbeat avoids pending edits. | Prolonged, interrupted and out-of-order network tests. |
| F07 zone status | PARTIAL / SERVER BLOCKED | Toggles now request persistence, serialize by field and roll back rejection. | Server acceptance/persistence and physical readback. |
| F08 lock | DONE for app defect | Removed unreliable per-box fallback; command success requires actual lock-state readback. Failure issues no second command. | Delayed hardware acknowledgment and service fallback contract. |
| F09 tracking | PARTIAL | Uses actual selected box ID/coordinates; polls while active; rejects invalid/missing/placeholder GPS; no phone/default-city substitution or fabricated sensor freshness. Missing-GPS actions disabled. Maps opens selected coordinates; Share composes email. | Sensor fix timestamps and physical valid-GPS/map/email tests. Email is implemented; a native share sheet is not claimed. |
| F11 facility actions | PARTIAL / SERVER BLOCKED | Removed example phone. Configured contact opens dialer; absent contact and unavailable alert show explicit feedback. No silent SOS no-op. | Real per-facility contact and emergency delivery/acknowledgment contract. |
| F01 refresh / F02 TLS | SERVER BLOCKED | Exact failures/acceptance in handoff. No new TLS bypass added. | Implement refresh and trusted preproduction certificate chain. |
| F14 FAQs | SERVER BLOCKED | Empty state retained. | Seed actual medical support content. |
| F12 token policy | DECISION NEEDED | Local logout coverage passes; API behavior recorded. | Agree expiry/revocation policy, then server implementation if needed. |
| F16/F17/F18 | DECISION NEEDED | Explicit in audit/handoff. | Pagination/email rules, driver password permissions, disconnected diagnostics. |

## Phase 3: verification and acceptance

- DONE: 47-test suite, including 15 new repair regressions. Mocked widget journeys do not prove hardware end-to-end behavior.
- DONE: original live-payload model checks improved from 6/14 to 14/14. This verifies model interpretation, not server write repair.
- DONE: Android development APK built and installed; build-tool compatibility warnings remain. No toolchain upgrade was attempted.
- DONE: rebuilt owner and driver profiles, driver logout, Help, target/measurement separation and unavailable-battery captures. Runtime testing caught the tracking display-name-versus-ID navigation bug and led to its correction.
- DONE: read-only final verification confirms both full box snapshots unchanged. No box settings, readings, locks, pairing, connection or external emergency mutations were needed during this repair pass.
- LEFT: matched visual review across all 71 references, actual OTP, valid GPS/maps/email, configured facility contact, BLE/camera, iOS, push/background, prolonged shift, accessibility/device sizes and foreign-organization/disposable ownership fixtures.
- LEFT: triage remaining analyzer warnings/info. The analyzer has zero errors, but is not lint-clean.

Use the [178-scenario inventory](../reports/preprod-2026-10-22/scenario-matrix.csv) for the subsequent full acceptance run. Its historical statuses were not overwritten as if every scenario had been retested. Physical BLE/GPS/OTP and iOS cannot be closed using mock/emulator coverage alone.

When a real facility number is supplied, builds may use `--dart-define=FACILITY_PHONE=<actual-number>`. This is a deployment fallback until a per-facility API contact contract exists. No example phone, password or token is committed.

Detailed logs and screenshots are local artifacts under `reports/`, which this repository ignores. This handoff and tracker are stored separately in `docs/` so they can be versioned with the app.
