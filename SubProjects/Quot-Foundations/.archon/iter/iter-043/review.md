# Iter 043 — Review (Quot-Foundations)

## Verdict
Build GREEN — both prover-touched files compile clean. `QuotScheme.lean`: +1 axiom-clean decl
`isLocalizedModule_basicOpen_of_hP1` (gap2 Piece B), `lean_verify` = `{propext, Classical.choice,
Quot.sound}` (re-checked this phase; the line-2025 "opaque" warning is a docstring word). `FlatBaseChange.lean`:
0 decls added (correctly — see FBC reversal), 0 errors. blueprint-doctor: **0 findings**. sync_leanok
(iter 43, sha 061213c): **+4 `\leanok`, 0 removed** (Picard_QuotScheme). leandag gaps=0, frontier=7,
unmatched=1.

**CONVERGING (QUOT) + STOP-FLAG (FBC) iter: net 0 active sorry (QUOT 4→4, FBC 4→4); +1 axiom-clean decl.
QUOT gap2 is now closed MODULO exactly Piece A. FBC's mandatory pivot returned a verified REVERSAL — the
"affine tilde-transport" route is illusory and collapses onto the same open keystone `_legs_conj`; the
prover correctly added nothing and the route is recorded as a Known Blocker for user escalation.**

## Overall progress this iter (active `sorry` per file)
- **QUOT 4 → 4 (gap2 Piece B LANDED; Piece A blocked+flagged).** +1 axiom-clean non-private decl
  `isLocalizedModule_basicOpen_of_hP1` (~2456) — the full mechanical eqToHom bridge from the gap2-core
  `section_localization_hfr_aux_general` to the consumer-facing `restrictBasicOpenₗ`, the bulk of the gap2
  assembly. gap2 final `isLocalizedModule_basicOpen` left ABSENT (no sorry; mathlib-build discipline), gated
  on **Piece A** `isQuasicoherent_pullback_fromSpec` (Mathlib-absent QC-under-pullback; the prover made a
  bounded gateway attempt, pinned the `↥V`/`↥↑V` coercion + `Functor.IsContinuous` non-synth friction,
  removed the draft to stay green, flagged the precise 5-step route). Honors the lane's no-silent-defer WATCH.
- **FBC 4 → 4 (REVERSAL — 0 decls, route blocked).** The iter-042-planned affine-tilde-transport pivot does
  NOT bypass the section mate: the concrete square's inner unit is the `g'=pullback.fst` unit (no element
  normal form), so `Γ(α)` must transit the tilde dictionaries = the conjugate intertwining. Both routes
  funnel through `_legs_conj` @1848. Prover attacked the keystone directly (4 entry tactics, all "no match");
  the 5-layer composite-`conjugateEquiv` + assembled `β` is the genuine 5-iter wall (037–041). Correctly
  added nothing. Escalation gate fired.
- **GR 0 (untouched).** GF 1 (untouched), gated on gap2 + the iter-044 QuotScheme import.

## Strategic state
- **QUOT:** genuinely one piece from closing the gap2 endgame. Piece A is a distinct Mathlib-absent
  slice-base-change sub-build — dispatch as its own iter-044 lane (route-1, 5 steps), watch for resistance.
  The arc has been long (~16 iters since the section-localization arc opened) but converges cleanly.
- **FBC:** in-loop options are exhausted. Both the conjugate route (037–041) and the pivot are walled on the
  same keystone. This is now a user-escalation / dedicated-build item, NOT a prover lane. Parking FBC does
  not block QUOT/GF/GR (no dependency).

## Critic / auditor dispositions (this review phase)
- **lean-auditor `quot-iter043`** (4 must-fix / 2 major / 10 minor): new decl honest + axiom-clean + genuine
  transport, the `letI compHom + show…from restrictₗ` idiom legitimate, all `Subsingleton.elim`/`eqToHom`
  steps sound. The 4 "must-fix" are the pre-existing PROTECTED scaffold stubs (not new holes — see
  recommendations §6). Majors (dead `gammaPullbackTopIso`, stale iter-176/177 docstrings) → recommendations
  §5. Report: `logs/iter-043/lean-auditor-quot-iter043-report.md`.
- **lean-vs-blueprint-checker `quot-iter043`** (0 must-fix / 2 major): (1) `isLocalizedModule_basicOpen_of_hP1`
  needs its OWN sub-lemma block (not folded) → recommendations §1; (2) `lem:qcoh_pullback_fromSpec` sketch
  under-specified re the coercion friction → **`% NOTE:` ADDED this phase**. Minor: private `descent_*` pins
  → recommendations §5. Report: `logs/iter-043/lean-vs-blueprint-checker-quot-iter043-report.md`.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:qcoh_pullback_fromSpec`: added `% NOTE:` recording the iter-043
  `↥V`/`↥↑V` coercion + `Functor.IsContinuous` non-synthesis friction at the `overRestrictUnitIsoInv`
  gateway (so the iter-044 Piece A prover doesn't re-discover it).
- No `\leanok` override; no `\mathlibok`; no `\lean{...}` rename this iter.

## Coverage debt (leandag unmatched = 1)
- `isLocalizedModule_basicOpen_of_hP1` → recommendations §1 (own sub-lemma block; planner authors prose).
