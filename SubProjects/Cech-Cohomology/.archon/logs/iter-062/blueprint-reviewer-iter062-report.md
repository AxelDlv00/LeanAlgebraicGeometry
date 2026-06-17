# Blueprint Review Report

## Slug
iter062

## Iteration
062

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / `lem:slice_structureSheaf_hom`: statement does not specify the Lean **type** of `ψ_r` (= `sliceStructureSheafHom`). "A morphism of sheaves of rings ψ_r over the slice (over-category) picture" is prose that does not map to a Lean type. The declaration is a build target and the prover must write the signature from scratch — without knowing whether `ψ_r` is a morphism between `CommRingCat`-valued sheaves, a `RingedSpace` hom, a ring map to feed `restrictScalars`, or something else. This is a blocking ambiguity: `pullback ψ_r` is used as a functor on `SheafOfModules` in the proof of `lem:pushforward_iso_preserves_qcoh`, which constrains the type, but the statement leaves it implicit.

- `Cohomology_CechHigherDirectImage.tex` / `lem:pushforward_slice_pullback_iso`: "H.over W transported" uses an unnamed transport. The transport functor or equivalence carrying `H|_W` across the opens-equivalence is not identified anywhere in the chapter — no name, no `\uses{}` pointer. A prover cannot build the LHS of the iso without knowing what this transport is.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:pushforward_slice_pullback_iso`: The proof asserts "the opens-equivalence identification 'W corresponds to φ.inv⁻¹ W = V' holds **definitionally**." In Lean, "definitionally" means `rfl`; if it requires a simp/ext argument the proof collapses. No rfl-path is named and no fallback is given. The "pullback-unit isomorphism of the structure-sheaf pullback" cited in the proof is also unnamed with no `\uses{}` entry.

- `Cohomology_CechHigherDirectImage.tex` / `lem:slice_structureSheaf_hom`: Proof sketch says "the only non-definitional adjustment is the unit-isomorphism correction built into the over-category transport equivalence (the Over.map along the unit isomorphism)" — but `Over.map` in the context of a SheafOfRings category is not standard; this phrase may be mixing `Over`-category vocabulary with sheaf-of-rings vocabulary. The proof provides no named lemma to back this step and has an empty `\uses{}`.

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:slice_structureSheaf_hom`: No `\uses{}` at all. The proof invokes Beck–Chevalley identity, `Over.map`, and a unit-isomorphism correction. These are non-trivial steps that should point at named declarations. **wire-up** — add `\uses{}` pointing to the relevant Mathlib lemmas (e.g. the structure-sheaf morphism constructor, the over-category unit identity). This is a missing-edge finding on an active prover route.

- `lean:Alg…` (isolated lean_aux node, no chapter): uncovered Lean helper with no blueprint entry. **keep** — lean_aux isolated nodes are an expected "needs a blueprint entry" signal, not a removal candidate.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: partial
- **correct**: partial
- **notes**:

  **Active-iter focus (iter-062 HARD GATE)**

  **Question (1) — `lem:pushPull_binary_coprod_prod` NOTE adequacy.** PASS. The `% NOTE:` at lines 8054–8072 is comprehensive and actionable:
  - Obstacle (a) INSTANCE TRAP fully specified: the `toPresheaf ⋙ evaluation Ab` composite fails `PreservesLimitsOfShape`; fix is to use `SheafOfModules.evaluation V` and reduce iso-check via `Scheme.Modules.Hom.isIso_iff_isIso_app`, NOT `NatIso.isIso_of_isIso_app`. Specific Lean identifiers named.
  - Obstacle (b) Ab→ModuleCat BRIDGE fully specified: reflect the `TopCat.Sheaf.isProductOfDisjoint` Ab-limit into `ModuleCat` via `isLimitOfReflects`; cone legs match via `restrictAdjunction_unit_app_app` (rfl); `h₂`/`h₁` fields of `Scheme.coprodPresheafObjIso` cover the open identities. LOC estimate provided (~60–100).
  - Private helpers `isIso_prodLift_of_isLimit` and `coprodDecompMap` are documented and bundled in the `\lean{}` list.
  - A prover is not blind there. No writer action needed for this node.

  **Question (2) — `lem:pushforward_iso_preserves_qcoh` route coherence.** PASS on coherence, with one caveat flagged below.
  - `\uses{lem:slice_structureSheaf_hom, lem:pushforward_slice_pullback_iso, lem:pushforward_iso_qcoh_of_slice_qcoh, lem:presentation_map_mathlib, lem:presentation_ofIsIso_mathlib, lem:nonempty_quasicoherentData_mathlib, lem:isAffineOpen_image_of_iso_mathlib}` — all seven labels exist in the chapter (verified via grep). Zero dangling references.
  - `lem:pushforward_commutes_restriction` is NOT in this lemma's `\uses{}` (the demoted route is correctly excluded from the DAG).
  - The ψ_r gap is genuinely decomposed: `lem:slice_structureSheaf_hom` (construct ψ_r) feeds `lem:pushforward_slice_pullback_iso` (pullback≅restricted pushforward), which feeds `lem:pushforward_iso_preserves_qcoh` (QCoh preservation) via per-member transport. Three independently-stated, chained steps — not a monolith.
  - Route logic: extract quasi-coherence datum (cover + per-member presentations), form image cover via `pushforward_iso_qcoh_of_slice_qcoh`, per-member: construct ψ_r → apply pullback functor → transport presentation via `presentation_map_mathlib` → transfer via `presentation_ofIsIso_mathlib`. Coherent.

  **Question (3) — Sub-lemma statement precision.** FAIL on both new sub-lemmas.

  **(3a) `lem:slice_structureSheaf_hom` (lines 9752–9772):**
  - The statement reads "There is a morphism of sheaves of rings ψ_r over the slice (over-category) picture." This does not specify the Lean TYPE. In Lean's algebraic geometry, "morphism of sheaves of rings" could be: a `CommRingCat`-valued sheaf morphism, a `RingedSpace` hom component, a ring map for `restrictScalars`, or an `AlgebraMap`-level datum. The intended use (`pullback ψ_r` as a functor on `SheafOfModules`) in `lem:pushforward_slice_pullback_iso` requires a specific type; without it being named, the prover must reverse-engineer the type from the downstream use.
  - The phrase "over the slice (over-category) picture" mixes `Over`-category vocabulary with sheaf-of-rings vocabulary. `Over.map` applied to a SheafOfRings is non-standard Lean. The proof's reference to a "unit-isomorphism correction built into the over-category transport equivalence (the Over.map along the unit isomorphism)" conflates two different categorical structures and provides no fallback.
  - No `\uses{}` at all, despite the proof invoking non-trivial steps (Beck–Chevalley identity, Over.post/forget commutativity, unit iso). Missing edges on an active prover route.

  **(3b) `lem:pushforward_slice_pullback_iso` (lines 9774–9797):**
  - The LHS `(pullback ψ_r).obj(H.over W transported)` uses undefined notation: "H.over W transported" — transported across what, by which equivalence/functor? The opens-equivalence is not named in the chapter. The prover cannot construct the LHS without knowing the explicit transport.
  - The proof asserts "holds **definitionally**" for the opens-equivalence identification without citing a rfl-path. If this is not definitional in Lean, the proof fails entirely; no fallback is provided.
  - The "pullback-unit isomorphism of the structure-sheaf pullback" is cited in the proof but unnamed and not in `\uses{}`.
  - `\uses{lem:slice_structureSheaf_hom}` only — no reference to the pullback-unit lemma or the opens-equivalence transport.

  **Demoted lemma status:** `lem:pushforward_commutes_restriction` (lines 9679–9721) carries two contradictory `% NOTE:` annotations: "build target. The Lean declaration does not exist yet." AND "superseded — the pushforward_iso_preserves_qcoh route no longer depends on this lemma; retained as alternative/reference only." This is confusing. The `\lean{}` hint should be removed (or changed to `% formerly planned: ...`) since no active prover is being dispatched to build it. The annotation conflict is a documentation issue only — the active route correctly does not list it in any `\uses{}`.

  **All other nodes on active routes (CechSectionIdentification chain):**
  - `lem:isIso_modules_of_toPresheaf`: `\leanok`, complete, correct. `\uses{lem:forget_reflectsIso_mathlib}` — resolved. No issues.
  - `lem:pushPull_coprod_prod`: NOT yet `\leanok`. Proof sketch (induction on binary case) is clear and sufficient. `\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf, lem:pushPull_binary_coprod_prod}` — all resolved. No issues.
  - `lem:pushPull_sigma_iso`: `\leanok`. `\uses{def:push_pull_obj, lem:cech_backbone_left_sigma, lem:pushPull_coprod_prod}` — all resolved. No issues.

  **DAG summary (leandag build):**
  - `unknown_uses`: 0 — no broken `\uses{}` references anywhere.
  - `unmatched_lean`: large count — all from `\mathlibok` blocks whose `\lean{}` names are Mathlib declarations not present in the project scan. Expected behavior; none are project declarations.
  - 1 isolated node (`lean:Alg…`, lean_aux type, no chapter) — uncovered Lean helper; disposition: keep.

  **Blueprint-doctor:** Zero `malformed_refs`, zero `broken_refs`, zero `orphan_chapters`, zero `axiom_decls`, zero `covers_problems`. Rendering is clean.

---

## Severity summary

**must-fix-this-iter:**

1. `Cohomology_CechHigherDirectImage.tex` / `lem:slice_structureSheaf_hom` — TYPE of `ψ_r` unspecified; prover cannot write the Lean signature without guessing. Writer must add explicit type annotation (domain, codomain categories/objects) to the lemma statement and add `\uses{}` entries for the key categorical steps in the proof. Active prover route: `OpenImmersionPushforward.lean` via `lem:modules_isoSpec_ext_transport → lem:pushforward_iso_preserves_qcoh → lem:slice_structureSheaf_hom`.

2. `Cohomology_CechHigherDirectImage.tex` / `lem:pushforward_slice_pullback_iso` — "H.over W transported" undefined; "definitionally" claim unverified. Writer must (a) name the transport functor/equivalence in the statement and (b) replace "definitionally" with either a rfl-path name or a concrete simp/ext argument, and (c) add `\uses{}` entry for the pullback-unit isomorphism. Same active route as above.

**Chapter-level consequence:** `Cohomology_CechHigherDirectImage.tex` is `complete: partial, correct: partial`. Per the HARD GATE rule, **both `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean` are blocked from prover dispatch** until this chapter clears the gate. The two must-fix items above are the writer's targets. Once patched, a scoped same-iter re-review of `Cohomology_CechHigherDirectImage.tex` (focused on the two sub-lemmas) may clear the gate this iter without burning another iteration.

**soon:**

3. `Cohomology_CechHigherDirectImage.tex` / `lem:pushforward_commutes_restriction` — contradictory `% NOTE:` annotations ("build target" + "superseded"). Remove the `\lean{}` hint or convert the block to a `% formerly planned:` comment. Not blocking (the active route does not use it), but will confuse any prover who reads the chapter linearly.

4. `Cohomology_CechHigherDirectImage.tex` / `lem:slice_structureSheaf_hom` — empty `\uses{}` despite proof invoking Beck–Chevalley identity and Over-category unit morphisms. Wire-up: add `\uses{}` entries for relevant Mathlib categorical lemmas. Not blocking for the prover (the construction is standard enough), but creates a missing-edge in the dependency graph.

**informational:**

5. One isolated lean_aux node (`lean:Alg…`) — uncovered Lean helper, no blueprint entry. Disposition: keep. Not a removal candidate.

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `complete: partial, correct: partial` due to underspecified type signature and undefined notation in the two new build-target sub-lemmas (`lem:slice_structureSheaf_hom`, `lem:pushforward_slice_pullback_iso`); both active files are blocked at the HARD GATE. Dispatch a blueprint-writer for the two must-fix items, then run a scoped same-iter re-review to unblock provers this iter.
