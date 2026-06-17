# Session 44 (iter-044) — Review Summary

## Metadata
- Sorry count: QUOT 4→4 (all 4 protected iter-176 stubs @126/165/201/228), FBC 4→4 (@1891 keystone,
  @2358 gstar_transpose, @2539 affineBaseChange_pushforward_iso, @2561 flatBaseChange_pushforward_isIso).
  Net active project sorry unchanged; **+11 axiom-clean decls** (all in QuotScheme.lean).
- Build: `lake build AlgebraicJacobian.Picard.QuotScheme` → **success (8317 jobs)**. FBC compiles 0 errors.
- Targets attempted: **QUOT gap2 close** (lane 1, mathlib-build) — SOLVED; **FBC `_legs_conj`** (lane 2,
  re-engaged conjugate) — PARTIAL.
- sync_leanok (iter 44, sha e3ade4a): **+9 `\leanok`, 0 removed** (Picard_QuotScheme only).
- blueprint-doctor: **0 findings**. leandag: gaps=0, frontier=7, unmatched=2.

## HEADLINE — QUOT gap2 FULLY CLOSED axiom-clean
The ~16-iter QUOT section-localization arc is **complete**. `isLocalizedModule_basicOpen`
(`lem:qcoh_section_localization_basicOpen`) — section-localization descent for QC modules on a general
scheme, general affine open `U` — now proved kernel-clean. The last missing input, **Piece A**
(`isQuasicoherent_pullback_fromSpec`, QC preserved under pullback along `hU.fromSpec`, Mathlib-absent),
landed via a 6-lemma **route-1 chain L1–L6** plus 2 helpers. `#print axioms` on all = `{propext,
Classical.choice, Quot.sound}` (re-confirmed by lean-auditor this phase).

### The 11 new decls (all `namespace AlgebraicGeometry.Scheme.Modules`)
| decl | line | role |
|------|------|------|
| `overRestrictUnitIsoInv` | 2554 | L1: slice-unit inv via **equivalence-transport** |
| `pullbackOpenImmersionUnitIso` | 2586 | helper: pullback sends unit→unit along open immersion (Final via open-map adjunction) |
| `overRestrictPresentationInv` | 2566 | L2: geometric presentation → slice presentation |
| `pullbackPreimageιIso` | 2603 | L3 helper: pseudofunctoriality square iso |
| `presentationPullbackιPreimage` | 2624 | L3: presentation of pullback restricted to preimage member |
| `isQuasicoherent_over_preimage` | 2643 | L4: per-member QC |
| `coversTop_preimage` | 2662 | L5: preimage family covers source |
| `isQuasicoherent_pullback_of_isOpenImmersion` | 2680 | L6: general QC-under-pullback |
| `isQuasicoherent_pullback_fromSpec` | 2700 | Piece A target |
| `isLocalizedModule_basicOpen` | 2712 | **gap2 keystone** |

### Key proof techniques (reusable — recorded to Knowledge Base)
1. **L1 equivalence-transport bypass.** The iter-043 gateway friction (`unitToPushforwardObjUnit` /
   `Functor.IsContinuous` non-synth / `↥V` vs `↥↑V` coercion fight) is sidestepped entirely:
   `(overRestrictEquiv V).inverse.mapIso (overRestrictUnitIso V).symm ≪≫ (overRestrictEquiv V).unitIso.symm.app _`.
   The directive's direct `unitToPushforwardObjUnit_of_isIso'` route is a **dead end** — record
   equivalence-transport as canonical.
2. **Open-immersion pullback unit-iso via Final.** `Opens.map k.base` is a right adjoint
   (`IsOpenMap.adjunction`, since `k.base` open map), hence `Final` (`final_of_isRightAdjoint`), making
   `pullbackObjUnitToUnit` an iso. Generalizes `pullbackSchemeIsoUnitIso` (isos) to open immersions.
3. **Dot-notation universe pin.** State a QC conclusion as `(... .over ...).IsQuasicoherent`, NOT the bare
   `SheafOfModules.IsQuasicoherent (...)` — the bare form **defaults universes to 0** and fails to unify
   (see milestone L4 attempt 1 error).
4. **`q.shrink` for `of_coversTop`.** `IsQuasicoherent.of_coversTop` needs the index in the site universe
   `Type u`; `QuasicoherentData.shrink` lands it there. `Nonempty M.QuasicoherentData` ascription pins the
   universe before `obtain`.
5. Slice-site machinery (`over`, `of_coversTop` bind, presentation transport) needs heartbeat headroom:
   `maxHeartbeats 1600000–2000000` + `synthInstance.maxHeartbeats 800000` (+ `backward.isDefEq.
   respectTransparency false` for L3's presentation transport).

## FBC `_legs_conj` — PARTIAL (verified scaffolding, keystone still open; 8-iter wall)
Re-engaged per the iter-044 plan (analogist's factored-`conjugateEquiv` route, not the abandoned
monolithic-β). **0 new declarations**; in-proof scaffolding `adjL` + `hunitL` baked above the `sorry`
@1891, both axiom-clean (`lean_goal` @1891 confirms in context; goal = the cross-layer crux).
- **Verified depth correction (the iter's main structural finding):** `adjL` is **depth-2**
  (`(tilde⊣Γ_A).comp (pullback g'⊣push g')`), NOT depth-3 — the `(Spec φ)` layer enters via the
  `gammaPushforwardIso φ` natural iso, not a third `Adjunction.comp`. The recipe's "two layers deeper"
  was wrong.
- **Dead end pinned (saves ~½ iter):** factor-3 `(pushforwardComp g' (Spec φ)).hom` is **un-collapsible
  by any positional tactic** (`rw`/`simp`/`conv`/`change`/`erw`) — even a char-identical explicit
  `have h3 := gammaMap_pushforwardComp_hom_eq_id …; rw [h3]` fails *"did not find an occurrence"*. Root
  cause = `X.Modules` instance-path divergence (`simp only [Functor.map_comp]` produces a defeq-but-not-
  syntactic factor). It must be absorbed into the conjugate recognition, never collapsed.
- **Ruled out:** `pullbackPushforward_unit_comp` for the g'-unit (shape mismatch — its middle is
  `P_b(unit_a.app(pullback b N))` but the keystone's `unit_{g'}` applies to `tilde M`).
- **Remaining:** build `adjR` (the `extendRestrictScalarsAdj inclA` composite matching `read_param`'s
  6-iso chain) + comparison `β`, then `(conjugateEquiv adjL adjR).injective` discharged by the proven
  conj-2b/2c/2d legs via `conjugateEquiv_symm_comp`/whiskering.

## Subagent dispositions (this review phase)
- **lean-auditor `quot-iter044`** (0 must-fix / 0 critical / 0 major / 3 minor): all 11 new QUOT decls
  axiom-clean, honest statements, correct infra (`Presentation.ofIsIso`/`.map`, `q.shrink`, dot-notation,
  heartbeat options sound). FBC `adjL`/`hunitL` = genuine verified progress. Minors: historical
  iter-039/041 status comments @1808–1811; `adjL`/`hunitL` not yet syntactically consumed by the `sorry`
  (expected for scaffolding). Report: `logs/iter-044/lean-auditor-quot-iter044-report.md`.
- **lean-vs-blueprint-checker `quot-iter044`** (0 must-fix / 2 minor): 8/8 gap2 decls match blueprint;
  2 helpers (`pullbackOpenImmersionUnitIso`, `pullbackPreimageιIso`) need blueprint blocks (→ recs §1);
  stale `\uses{lem:isIso_unitToPushforwardObjUnit_of_isIso}` in `def:over_restrict_unit_iso_inv` (proof
  bypassed it via equivalence-transport) (→ recs §2). Report:
  `logs/iter-044/lean-vs-blueprint-checker-quot-iter044-report.md`.
- **lean-vs-blueprint-checker `fbc-iter044`** (4 "must-fix" / 2 major): **the 4 "must-fix" are FALSE
  POSITIVES** — see Blueprint markers section. 1 valid major (`sections_direct` route illusory) →
  **`% NOTE:` ADDED this phase**. Report: `logs/iter-044/lean-vs-blueprint-checker-fbc-iter044-report.md`.

## Blueprint markers updated (manual)
- `Cohomology_FlatBaseChange.tex`, `lem:pushforward_base_change_mate_sections_direct`: added
  `% NOTE: (review iter-044)` recording the route as **illusory/abandoned** (iter-043 reversal — it
  collapses onto `_legs_conj`; the Lean target was correctly never added). Resolves the lvb-FBC major.

### FBC `\leanok` false-positive disposition (NO change made — justified)
The lvb-FBC checker flagged 4 "must-fix": `\leanok` present on `lem:base_change_mate_fstar_reindex_legs_conj`,
`lem:base_change_mate_gstar_transpose`, `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`
while their Lean decls have `sorry`. **First-hand audit:** all four `\leanok` sit on the **statement
block** (`\begin{lemma}\leanok` / immediately after), NOT the proof block — and per the marker vocabulary
statement-`\leanok` correctly means "declaration formalized, ≥ a sorry present". Their **proof blocks carry
NO `\leanok`** (verified by line-scan of each proof region). These are legitimate, pre-existing, and were
NOT touched by this iter's sync (which only changed Picard_QuotScheme). **No marker removed.** The checker
conflated statement-level `\leanok` with proof closure.

## Notes (LOW)
- 2 leandag `unmatched` lean_aux nodes (the 2 new QUOT helpers) — listed in recommendations for the planner
  to blueprint.
