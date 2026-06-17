# Recommendations — next plan iter (post iter-054)

## TOP (CRITICAL/HIGH — from subagent reports)

1. **[MUST-FIX, prover/refactor — review cannot edit `.lean`] Stale docstring in `genericFlatnessAlgebraic`.**
   `FlatteningStratification.lean:1957` "Surviving residue (`sorry` this iter)" bullet falsely claims the
   dévissage is open — the theorem (L1988-2142) is COMPLETE + axiom-clean. Have the GF prover (or a refactor
   pass) fix the label when it next touches the file. (lean-auditor `iter054`.)

2. **[HIGH] GF close — closest-to-done win is `gf_common_basicOpen_basis` step 3.** The narrow localization
   realisation (`∃ḡ, D(g)=D(ḡ)`) is fully routed in-code (~25-40 lines): `g|_{D(b)}=ḡ'/bⁿ` via
   `IsAffineOpen.isLocalization_basicOpen`+`IsLocalization.surj`; `ḡ:=b·ḡ'`; `Scheme.basicOpen_mul`. Closing it
   drops B2.4 to axiom-clean. Dispatch a focused `prove` on this FIRST — it is the cheapest GF declaration-sorry
   drop and unblocks the assembly.

3. **[HIGH] GF `genericFlatness` close (deadline iter-055).** After B2.4 lands, build (A) `gf_flat_locality_assembly`
   over `Module.flat_of_isLocalized_span` (base R=Γ(S,U), source B=Γ(X,W), away-loc Γ(F,D(g_k)) from B2.2/B2.4,
   per-piece flatness from per-patch freeness + B2.3 + B1) + (B) the `genericFlatness` cover scaffold (steps 1-4).
   **This is the make-or-break for the GF route at its deadline.** Effort-break the assembly + cover before
   dispatch (both are large `Module.compHom`-instance builds — see KB `quot-gap1-closed-opaque-immersion`).

4. **[HIGH] GR — close `pullbackObjUnitToUnit_comp` to drop `functor`.** Documented conjugate route (do NOT
   retry `Iso.eq_inv_comp`/`simp [pullbackComp]` — whnf timeout): from the `comp_homEquiv`-factored goal, handle
   the `(pullbackComp b a).hom.app unit` leg with `unit_conjugateEquiv (adj_a.comp adj_b) (adj (b≫a))
   (pullbackComp b a).inv unit` + `conjugateEquiv_pullbackComp_inv`, defeq-bridged exactly as the `_id` lemma
   bridged `conjugateEquiv_pullbackId_hom`, keeping `pullbackComp` OPAQUE. Then add `pullbackFreeIso_comp`
   (free cofan over the composite — universe trap does NOT bite for the composite form) and finish `map_comp`
   mechanically. `functor` then drops sorry-free.

## MEDIUM — blueprint coverage / mismatch (planner → blueprint-writer)

5. **Reconcile B2.3 type.** `lem:gf_base_localization_comparison` prose claims `IsLocalization`; Lean proves
   `Module.Flat`. `% NOTE:` added this iter. Either downgrade the prose to flatness (flatness is all the
   assembly consumes) or strengthen the Lean. (lvb-flat MAJOR.)

6. **Blueprint the new GF helper.** Add a `\lean{AlgebraicGeometry.gf_common_basicOpen_basis}` block (the genuine
   geometric crux for B2.4) with the `IsLocalization.surj` cross-chart construction sketch and the NOTE that
   `g|_O=ḡ|_O` is not achievable (basic-open equality only). (lvb-flat MAJOR; coverage debt below.)

7. **Reconcile the 3 blueprinted-but-absent GF decls** (lvb-flat MAJOR):
   - `lem:gf_stalk_flat_over_base` (G3.2): the stalk route is DEAD (`SheafOfModules.stalk` Mathlib-absent);
     replaced by source-span descent. Either reduce to a conceptual-only block with a route-change note, or
     remove the `\lean{}` ref.
   - `lem:gf_section_localization_flat_descent` (B2 assembly): blueprinted, no Lean. Either add the assembling
     Lean decl or fold its content into `lem:gf_flat_locality_assembly`.
   - `lem:gf_flat_locality_assembly` (G3): blueprinted, no Lean — this IS item (A) of the genericFlatness close
     (rec 3); will exist once that lands.

8. **Blueprint the GR helper `pullbackFreeIso_id`.** Closed + load-bearing in `functor.map_id` but has no
   `\lean{}` block (only descriptive prose). Add a formal lemma block. (lvb-grquot MAJOR.)

9. **B2.2/B2.4 prose cleanup.** Per the `% NOTE:`s added this iter, drop the "agree over the overlap" /
   "restrict to the same section over O" phrasing in `lem:gf_section_localization_twoleg` (proof) and
   `lem:gf_crossChart_spanning_cover` in favour of basic-open equality. (B2.2's *statement* already uses the
   basic-open phrasing; only the proof/B2.4 need it.)

## SNAP — route-stall flag (NOT just another helper round)

10. **SNAP produced NO committed `.lean` output this iter** (`SectionGradedRing.lean` untouched). Combined with
    iter-051 (dropped by no-op filter), SNAP has had 0 declaration-sorry change across the two iters it was
    "active." Before re-planning the lane, VERIFY (a) the prover lane actually dispatches and (b) the filename
    line carries a scaffold keyword (KB `scaffold-keyword-same-line`). The presheaf-promotion crux is the
    make-or-break; do NOT keep adding objectwise/coverage helpers — if the crux is not constructible in 1 iter,
    escalate (effort-break or route change), per the iter-053 progress-critic standing corrective.

## Coverage debt (dag-query unmatched = 8 — planner to blueprint)

- **NEW this iter:**
  - `AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_id` (GrassmannianQuot) — closed; free-cofan upgrade of
    `pullbackObjUnitToUnit_id`. See rec 8.
  - `AlgebraicGeometry.gf_common_basicOpen_basis` (FlatteningStratification, HAS sorry) — geometric crux for
    B2.4. See rec 6.
- **Carryover (SNAP, iter-053):** `RelativeTensorCoequalizer.{actLmap_tmul, actRmap_tmul, descHom_tmul,
  piMor_apply, projL_tmul}` — 5 objectwise-coequalizer helpers, all proved, unblueprinted.
- **Intentionally private (iter-053 note):** `Scheme.Modules.opensTopology` (impl detail) — leave unmatched.

## Do NOT retry (blocked — needs structural change first)

- **GR `pullbackComp` non-opaquely** (`Iso.eq_inv_comp`, `simp [pullbackComp]`, `Iso.app …symm`): whnf/isDefEq
  heartbeat timeout (200000). Only `conjugateEquiv_pullbackComp_inv` touches it opaquely.
- **GR cofan over `Scheme.Modules.pullback (𝟙 T)`** (vs the `SheafOfModules.pullback φ` form): universe trap in
  `PreservesColimit` search. Use the `SheafOfModules.pullback` form + defeq bridge.
- **GF restriction-matched pair** `g|_O=ḡ|_O`: not constructible in general; use basic-open equality.
- **FBC keystone `base_change_mate_gstar_transpose`** (FlatBaseChange.lean:2416): parked since iter-043, off
  critical path. Auditor flags the park-vs-escalate status should be explicit in the handoff — it un-parks only
  if GF+QUOT+GR all close with it still open (then it is the sole merge-back blocker).
