# Blueprint Review Report

## Slug
rescope-iter063

## Iteration
063

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: true
- **notes**:
  - **GATE ITEM 1 — `lem:pushforward_slice_pullback_iso` rewrite: RESOLVED.** The `leftAdjointUniq`
    route is mathematically correct and complete for general `H` (not just the unit module). Step 1
    identifies `pullback ψ_r ≅ pushforward φ''` via `Adjunction.leftAdjointUniq` applied to
    `pullbackPushforwardAdjunction ψ_r` (left adjoint of pushforward ψ_r) and the new sub-lemma
    `lem:pushforward_slice_two_adjunction` (also left adjoint of same pushforward). Step 2 is a direct
    section identity: both sides have the same sections `Γ(H, φ.hom⁻¹ W)` over any slice open `W`
    of `Vᵢ`, since `W ⊆ Vᵢ = φ.inv⁻¹(Uᵢ)` makes the intersection trivial. The proof explicitly
    states (lines 10086–10090) that `pullbackObjUnitToUnit` is NOT used, and the argument covers all
    `H` at once via the functor-level isomorphism before evaluating.
  - **GATE ITEM 1 — `lem:pushforward_slice_two_adjunction` correction: RESOLVED.** The sub-lemma
    surfaces the `Over.postEquiv`-inverse correction explicitly: the inverse of
    `Over.postEquiv Uᵢ e_Opens` is NOT the bare `Over.post(Opens.map φ.hom.base)` but the corrected
    composite `Over.post(Opens.map φ.hom.base) ∘ Over.map(unitIso.inv)`. The reason (the open
    identity `φ.hom⁻¹(φ.inv⁻¹ Uᵢ) = Uᵢ` does not hold definitionally) is stated explicitly at lines
    10043–10049. The correction is baked into the definition of `φ'' = sliceStructureSheafHom(φ⁻¹, Vᵢ)`
    so that the H₁, H₂ compatibility squares for `pushforwardPushforwardAdj_mathlib` are satisfied.
    The blueprint proof gives enough detail for a prover: apply `pushforwardPushforwardAdj_mathlib`
    to the slice equivalence `Over.postEquiv`, verify H₁/H₂ hold with the corrected inverse, done.
  - **GATE ITEM 2 — `lem:pushPull_binary_coprod_prod` expansion: RESOLVED.** The full q_*-coherence
    assembly is present. The proof has three named components: (a) the mandatory canonical framing
    (`prod.lift(pushPullMap inl, pushPullMap inr)`, explicitly marked as non-negotiable); (b) the
    reference chain `(pushforward q)(coprodDecompMap M)` followed by product preservation and per-leg
    idiso; (c) matching the canonical map to the chain using `lem:pushPull_binary_leg_coherence`.
    The leaf `isIso_coprodDecompMap` is justified: sectionwise the coproduct splits disjointly, so
    each `coprodDecompMap M` component is an iso by `coprodPresheafObjIso`/`isProductOfDisjoint`.
    The overall structure is sound and adequate for formalization.
  - **GATE ITEM 2 — `lem:pushPull_binary_leg_coherence`: RESOLVED.** The sub-lemma statement and
    proof are adequate. The proof unfolds `pushPullMap` to its raw five-step form, applies the
    unit-intertwining identity of `Adjunction.unit_leftAdjointUniq_hom_app` to rewrite the
    restriction-adjunction unit, then cancels `restrictFunctorIsoPullback` against the matching
    inverse factor inside `idiso₀`, leaving a residual of proof-irrelevance of an open-set equality.
    All steps are named and the Lean targets are correctly identified.
  - **GATE ITEM 3 — new helper coverage: RESOLVED.** All six new Lean helpers are properly bundled
    in their parent `\lean{}` lists with no new isolated blueprint nodes created:
    - `isIso_coprodDecompMap`, `isIso_map_prodLift_of_isLimit`, `coprodDecompMap` → bundled in
      `lem:pushPull_binary_coprod_prod`.
    - `opensMapInvBase_isEquivalence`, `overPost_slice_isContinuous`,
      `sliceStructureSheafHom_pre_isRightAdjoint`, `sliceStructureSheafHom_isRightAdjoint` → bundled
      in `lem:slice_structureSheaf_hom`.

### Dependency & Isolation

- **`leandag build --json`**: `"unknown_uses": []` — zero broken `\uses{}` edges across the whole
  blueprint.
- **`archon blueprint-doctor --json`**: `"malformed_refs": []`, `"broken_refs": []`,
  `"axiom_decls": []`, `"covers_problems": []` — clean.
- **Isolated nodes (2 total, both `keep`)**:
  - `lem:pullbackObjUnitToUnit_mathlib` (blueprint node, `\mathlibok`): Isolated because the proof of
    `lem:pushforward_slice_pullback_iso` was rewritten away from this anchor. The blueprint explicitly
    documents at line 9778: *"Retained as an alternative/reference statement only; not an active build
    target and not on any live \\uses chain."* **keep** — intentional standalone reference anchor.
    The `\mathlibok` claim is faithful: `SheafOfModules.pullbackObjUnitToUnit` and
    `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` are real Mathlib declarations.
  - `lean:AlgebraicGeometry.CechAcyclic.affine` (lean_aux, has sorry): Explicitly documented at
    line 1348: *"intentionally left in place, unused, and is NOT a live obligation of this chapter."*
    **keep** — documented dead placeholder.

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

## Overall verdict

All three iter-062-review must-fix findings on `Cohomology_CechHigherDirectImage.tex` are resolved; the chapter is `complete: true` and `correct: true` with no open must-fix items. Gate clears: both `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean` may receive prover lanes this iter.
