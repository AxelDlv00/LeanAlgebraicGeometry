# Recommendations — after iter-043 (for the iter-044 plan agent)

## §0 — Closest to completion: QUOT gap2 (one piece left)
gap2 is closed **modulo exactly Piece A**. Piece B (`isLocalizedModule_basicOpen_of_hP1`) landed
axiom-clean this iter. Once Piece A lands, the final `isLocalizedModule_basicOpen` is a one-liner:
`isLocalizedModule_basicOpen_of_hP1 M hU (isIso_fromTildeΓ_of_isQuasicoherent _) f`.

## §1 — Coverage debt (1-to-1 Lean↔tex restoration) — MUST do iter-044
`archon dag-query unmatched` = **1 node**:
- `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_hP1` (QuotScheme.lean ~2456,
  `lean_aux`, no blueprint block). Per the lean-vs-blueprint-checker (major) it should get its **OWN
  sub-lemma block**, NOT be folded into `lem:qcoh_section_localization_basicOpen` part (2): its signature
  takes `hP1 : IsIso (fromTildeΓ ((pullback hU.fromSpec).obj M))` as an explicit premise, so it is strictly
  weaker and will be cited directly once Piece A is proved. Its proof `\uses`:
  `lem:section_localization_hfr_aux_general`, `lem:fromSpec_image_top_section_coherence`,
  `lem:modules_restrict_basicOpen_linear`, `lem:isLocalizedModule_ringEquiv_semilinear`,
  `def:gamma_image_ring_equiv`, + Mathlib `IsAffineOpen.fromSpec_image_basicOpen`,
  `Scheme.Hom.image_top_eq_opensRange`. (Planner authors prose; review agent does not.)

## §2 — Piece A `isQuasicoherent_pullback_fromSpec` — dispatch as its OWN iter-044 lane
Mathlib-absent multi-helper slice-base-change build; NOT a one-shot. Cleanest = route 1 (5 steps):
(a) `overRestrictUnitIsoInv` — resolve the `↥V`/`↥↑V` coercion by stating `R`/`K` via
`V.toScheme.ringCatSheaf`'s ACTUAL space, mirroring how `overRestrictPullbackIso` threads it, and supply
the `Functor.IsContinuous` instance explicitly (it does not auto-synthesize inside
`unitToPushforwardObjUnit`); (b) `overRestrictPresentationInv` (geometric→slice Presentation);
(c) the `k`-restriction of `presentationPullbackιOfQuasicoherentData` via `pullbackComp` +
`presentationPullbackOfSchemeIso`; (d) `coversTop` for preimages; (e) assemble with
`IsQuasicoherent.of_coversTop`. The friction is now recorded in the blueprint `% NOTE:` on
`lem:qcoh_pullback_fromSpec`. **WATCH:** if a sub-step resists, STOP and flag the precise sub-step
immediately — do NOT silent-defer (the gap1 arc over-ran by deferring blockers). Consider an
effort-breaker on `lem:qcoh_pullback_fromSpec` if the 5-step block still reads as too large.

## §3 — GF-G1 becomes ready the iter after gap2 commits
`lem:gf_qcoh_fintype_finite_sections` `\uses{lem:qcoh_section_localization_basicOpen}` = gap2 (general X),
NOT G1-core. It needs `FlatteningStratification.lean` to import `QuotScheme.lean` first. Don't dispatch it
until gap2's final `isLocalizedModule_basicOpen` is in Lean (i.e. after Piece A).

## §4 — FBC: do NOT re-dispatch in-loop — escalation or dedicated build
**Blocked, alternatives exhausted (do not re-assign without a structural change).** The conjugate
`gstar_transpose` route was exhausted in-loop (037–041) AND the iter-042-planned "affine tilde-transport"
pivot is now verified ILLUSORY (collapses onto the same keystone `_legs_conj` @1848). Per the armed
escalation gate:
- Do NOT add `pushforward_base_change_mate_sections_direct` (any honest statement is sorry-backed through
  the keystone).
- Do NOT retry conjugate prover rounds, `ext`/`induction_on` on the geometric composite (iter-035 dead end),
  or another analogist round.
- The keystone `_legs_conj` needs a dedicated multi-hundred-LOC build (composite `conjugateEquiv adjL adjR`
  over 5 adjunction layers + assembled `β`, discharged by `conjugateEquiv_comp/_symm_comp/_whiskerLeft/
  _whiskerRight` + the proven conj-2b/2c/2d) — a focused subagent or user-driven session, OR park FBC.
  Surfaced on TO_USER.md; user steers via USER_HINTS.md. FBC `cancelBaseChange` is NOT a dependency of
  QUOT/GF/GR, so parking it does not block the live lanes.
- Cleanup-only (not blocking): the 2 dead conjugate sorries (@1848 `_legs_conj`, @2315 `gstar_transpose`)
  + @2496/@2518 downstream remain; a removal-refactor is a follow-up, not a prover lane.

## §5 — Minor / hygiene (lean-auditor + checker, non-blocking)
- **Dead helper:** `gammaPullbackTopIso` (QuotScheme.lean:1843) is `\leanok`-marked but never consumed (the
  chain uses `gammaPullbackImageIso f M ⊤` directly). Candidate for removal-refactor.
- **Stale docstring labels:** "iter-176/iter-177" iteration numbers in four docstrings are from the
  pre-extraction project — meaningless here; strip in a hygiene pass.
- **Orphaned `set…with` equation names** (`hresdef`, `hcomp`, `hN`×2, `hM'`, `hA`×2, `hS`, `hj`×2, `hii`,
  `hρ`): harmless; drop the unused `with` clauses if a refactor touches those lines.
- **Private `descent_*` pins:** `iSup_basicOpen_subtype_eq_top`, `descent_surj`, `descent_smul_eq_zero` are
  `private lemma`s with public-looking `\lean{...}` + `\leanok`; a `% NOTE:` on the descent subsection (like
  the one at blueprint line 500 for `IsRatHilb`) would document the visibility. (Planner/review follow-up.)

## §6 — Protected scaffold stubs (informational, NOT to assign)
The 4 lean-auditor "must-fix" (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
`Grassmannian.representable` @126/165/201/228) are the pre-existing PROTECTED iter-176 scaffold `sorry`s
acknowledged in the module header — not new holes, not in scope for a prover round until their upstream
foundations (sectionGradedRing etc., still on the frontier) land.
