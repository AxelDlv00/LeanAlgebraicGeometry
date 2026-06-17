# Iter 044 — Review (Quot-Foundations)

## Verdict
Build GREEN — `QuotScheme.lean` `lake build` exit 0 (**8317 jobs**; only style / long-line /
`maxHeartbeats`-comment warnings + the 4 pre-existing protected iter-176 scaffold `sorry`s).
`FlatBaseChange.lean` compiles 0 errors (open `_legs_conj` sorry + benign scaffolding lints only). All 11
new QUOT decls `#print axioms` = `{propext, Classical.choice, Quot.sound}` (re-confirmed by lean-auditor).
blueprint-doctor: **0 findings**. sync_leanok (iter 44, sha e3ade4a): **+9 `\leanok`, 0 removed**
(Picard_QuotScheme only). leandag: gaps=0, frontier=7, unmatched=2.

**LANE-DEFINING CLOSE — QUOT gap2 FULLY CLOSED axiom-clean.** `isLocalizedModule_basicOpen`
(`lem:qcoh_section_localization_basicOpen`) lands kernel-clean, ending the ~16-iter QUOT
section-localization arc. The final input **Piece A** (`isQuasicoherent_pullback_fromSpec`, Mathlib-absent
QC-under-pullback) built via the route-1 chain **L1–L6** + 2 helpers — 11 axiom-clean decls total, **zero
new sorries**. **FBC `_legs_conj`** re-engaged (factored-conjugate route): verified partial scaffolding
(`adjL`/`hunitL`, depth-2 correction) baked in but keystone NOT closed — now an **8-iter wall (037–044)**.

## Overall progress this iter (active `sorry` per file)
- **QUOT 4 → 4 (gap2 CLOSED — +11 axiom-clean decls; the 4 sorries are only the frozen protected stubs).**
  `overRestrictUnitIsoInv` (L1, equivalence-transport), `pullbackOpenImmersionUnitIso` (helper),
  `overRestrictPresentationInv` (L2), `pullbackPreimageιIso` (L3 helper), `presentationPullbackιPreimage`
  (L3), `isQuasicoherent_over_preimage` (L4), `coversTop_preimage` (L5),
  `isQuasicoherent_pullback_of_isOpenImmersion` (L6), `isQuasicoherent_pullback_fromSpec` (Piece A target),
  `isLocalizedModule_basicOpen` (gap2 keystone). The iter-043 gateway friction
  (`unitToPushforwardObjUnit`/IsContinuous/`↥V`-coercion) was **bypassed**, not fought, via
  equivalence-transport — recorded as canonical.
- **FBC 4 → 4 (PARTIAL — 0 new decls; `adjL`/`hunitL` baked into the keystone proof).** Verified depth-2
  correction (Spec-φ layer enters via `gammaPushforwardIso φ`, not a 3rd `Adjunction.comp`); factor-3
  positional-collapse dead end pinned (instance-path divergence); `pullbackPushforward_unit_comp` ruled
  out. Remaining = `adjR` + `β` + the `conjugateEquiv` discharge.
- **GR 0 / GF 1 (untouched).** GF-G1 now UNBLOCKED by gap2 (needs the QuotScheme import) — iter-045 lane 1.

## Strategic state
- **QUOT:** the long section-localization arc is DONE. The route's remaining QUOT items (annihilator reverse
  inclusion, P2) and the 4 protected stubs are separate, deferred. gap2 closing is the unblock for GF.
- **FBC:** in-loop wall persists. The factored-conjugate route is now the live hypothesis with verified
  first rungs (`adjL`/`hunitL`); iter-045 gets ONE more round (build `adjR`+`β`) then escalate if it still
  resists. Parking FBC does not block QUOT/GF/GR (no dependency). TO_USER flags it as the longest blocker.

## Critic / auditor dispositions
- **lean-auditor `quot-iter044`** (0 must-fix / 0 critical / 0 major / 3 minor): 11 new QUOT decls
  axiom-clean + honest + correct infra; FBC `adjL`/`hunitL` genuine verified progress. Minors = historical
  status comments + unconsumed scaffolding (both expected). Report archived to
  `logs/iter-044/lean-auditor-quot-iter044-report.md`.
- **lean-vs-blueprint-checker `quot-iter044`** (0 must-fix / 2 minor): 8/8 gap2 decls match blueprint;
  2 helpers need blocks (recs §1); stale `\uses` in `def:over_restrict_unit_iso_inv` (recs §2). Report:
  `logs/iter-044/lean-vs-blueprint-checker-quot-iter044-report.md`.
- **lean-vs-blueprint-checker `fbc-iter044`** (4 "must-fix" / 2 major): **4 must-fix are FALSE POSITIVES**
  (statement-block `\leanok` on sorry-backed decls is legitimate per the marker vocabulary; first-hand
  line-scan confirms NO proof-block `\leanok` — no marker changed). 1 valid major (`sections_direct`
  illusory) → `% NOTE:` added to blueprint. Report:
  `logs/iter-044/lean-vs-blueprint-checker-fbc-iter044-report.md`.

## Blueprint markers updated (manual)
- `Cohomology_FlatBaseChange.tex`, `lem:pushforward_base_change_mate_sections_direct`: added
  `% NOTE: (review iter-044)` — route illusory/abandoned (collapses to `_legs_conj`; Lean target correctly
  never added).
- No `\leanok` added/removed manually (the 4 lvb-FBC "must-fix" were statement-level, legitimate — left
  untouched with justification in summary.md).
