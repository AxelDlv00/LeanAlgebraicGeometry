# Blueprint Review Report

## Slug
iter056

## Iteration
056

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp` proof step (2): the "change-of-scheme Serre vanishing for a general affine open" is described in prose (lines 8057–8063: "one transports the vanishing along the canonical isomorphism j⁻¹(V) ≅ Spec Γ(j⁻¹(V), O) using the naturality of absolute cohomology") but the chapter provides **no** auxiliary blueprint lemma, no `\lean{}` hint for the transport step, and no `\uses{}` edge pointing to `IsAffine.isoSpec` or a cohomology-naturality helper. The `rightDerivedNatIso` lean_aux helper (already proved, in `OpenImmersionPushforward.lean`) is the natural vehicle for this transport but has no blueprint entry. This is the dominant blocker for the `_acyclic` leaf; the prover cannot follow the proof sketch to Lean code.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp` proof step (2): same as above — the key sub-step "transport absolute cohomology across V ≅ Spec R'" is an unbacked "one transports" claim. Missing: a blueprint auxiliary lemma (or at minimum a `\uses{}` edge to a `\lean{}` target) naming `AlgebraicGeometry.IsAffine.isoSpec` (the scheme isomorphism) and explaining how `Ext^n(jShriekOU ⊤_V, F|_V) = 0` follows from `affine_serre_vanishing` over `Spec R'`. The lean_aux `rightDerivedNatIso` could play this role but is invisible to the blueprint.

### Dependency & isolation findings

**Isolated lean_aux nodes (all prover-created helpers, none are blueprint nodes):**

All 7 isolated nodes are `lean_aux` type — no isolated blueprint nodes.

- `lean:AlgebraicGeometry.isZero_homology_of_iso_homotopy_id_zero` (CechAugmentedResolution.lean, proved): iso-variant of `lem:isZero_homology_of_homotopy_id_zero` (takes `e : D ≅ D'` then transports). **keep** — intentional helper; belongs under the Sub-brick A section of `Cohomology_CechHigherDirectImage.tex`. A writer should add a compact blueprint entry so the DAG exposes it.

- `lean:AlgebraicGeometry.rightDerivedNatIso` (OpenImmersionPushforward.lean, proved): iso between right-derived functors induced by a functor iso `F ≅ G`. **keep** — needed for the change-of-scheme transport in the `_acyclic` leaf; see Incomplete parts above. A blueprint entry under `lem:open_immersion_pushforward_comp` (as an auxiliary lemma) would both expose it and discharge the proof-detail gap.

- `lean:AlgebraicGeometry.sectionsFunctorCorepIso` (OpenImmersionPushforward.lean, proved): the corepresentability iso `sectionsFunctor V ≅ preadditiveCoyoneda.obj (op (jShriekOU V))`. **keep** — internal infrastructure for the corepresentability chain in `_comp`; belongs under the AbsoluteCohomology/open-immersion pushforward section.

- `lean:AlgebraicGeometry.sectionsFunctor_additive` (OpenImmersionPushforward.lean, proved): instance `(sectionsFunctor V).Additive`. **keep** — prerequisite for right-derived functor machinery; belongs under open-immersion pushforward section.

- `lean:AlgebraicGeometry.toPresheafOfModules_additive` (OpenImmersionPushforward.lean, proved): instance `(Scheme.Modules.toPresheafOfModules X).Additive`. **keep** — similar; belongs under open-immersion pushforward section.

- `lean:AlgebraicGeometry.jShriekOU_homEquiv_nat` (OpenImmersionPushforward.lean, proved): naturality of the `jShriekOU` hom-equivalence. **keep** — private helper for `sectionsFunctorCorepIso`; belongs under the AbsoluteCohomology section.

- `lean:AlgebraicGeometry.CechAcyclic.affine` (CechAcyclic.lean, **has sorry**): a superseded alternative formulation of the Čech-acyclicity result using a different signature. **keep (dormant)** — this is the old `CechAcyclic.affine` sorry that STRATEGY.md calls "dead (superseded)"; it has no DAG path to the main theorem and `rdep_count = 0`. The blueprint does not need to cover it, but the `sorry` in a non-blueprint-covered declaration is noise; a future cleanup pass should delete it.

**Note on `\uses{lem:cech_acyclic_affine}` in `lem:cechSection_contractible`:**

The statement and proof blocks both list `lem:cech_acyclic_affine` in their `\uses{}`. The proof prose reads: "the dependent-coefficient combinatorial Čech engine — `depDiff`, `depHomotopy`, `depHomotopy_spec`, `depDiff_exact` **of Lemma~\ref{lem:cech_acyclic_affine}** — then supplies the prepend-`i_fix` contracting homotopy."

This is intentionally using `lem:cech_acyclic_affine` as a **Lean-location pointer** — the `dep*` declarations are bundled in that lemma's `\lean{}` list. However, it misleadingly implies that `lem:cechSection_contractible` has a mathematical dependency on the standard-cover Čech vanishing result. The actual mathematical dependency is only on the `dep*` combinatorial engine, which is a *prerequisite* of `lem:cech_acyclic_affine`, not its conclusion. Since P3 is fully proved, no dispatch-ordering risk arises, but the prose gives a wrong impression of the dependency direction. A writer should add a parenthetical: "(the `dep*` engine declarations bundled into `lem:cech_acyclic_affine` as infrastructure — the math conclusion of that lemma is NOT a dependency here)."

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **MUST-FIX (active prover route — `OpenImmersionPushforward.lean`)**: `lem:open_immersion_pushforward_comp` proof step (2) provides a prose strategy for the change-of-scheme Serre transport but no Lean-level anchor. Required: add a compact auxiliary blueprint lemma (e.g. `lem:rightDerivedNatIso`) with `\lean{AlgebraicGeometry.rightDerivedNatIso}` and a `\uses{}` edge pointing to it from the proof; add a sentence naming `AlgebraicGeometry.IsAffine.isoSpec` as the scheme isomorphism + how the transport reduces to `affine_serre_vanishing`. Without this, the prover cannot bridge the prose to Lean code.
  - **SOON**: `lem:affine_serre_vanishing` body prose at lines 3244–3248 reads "it is currently formalized in the reduced `_of_tildeVanishing` form pending the residual" — this is STALE (a NOTE at lines 3217–3223 already flags it as stale; the lemma is now proved and axiom-clean). A writer should delete the stale paragraph. Low priority since the NOTE flags it, but a reader without context could be misled.
  - **SOON**: 6 isolated `lean_aux` nodes in the covered files have no blueprint entries; file locations and recommended chapters listed in Dependency & isolation findings above. All are proved helpers (except `CechAcyclic.affine` with sorry which is dormant). Priority: `rightDerivedNatIso` is directly needed by the `_acyclic` proof and should get a blueprint entry this iter as part of the must-fix writer pass.
  - **INFORMATIONAL**: `lem:cechSection_contractible` `\uses{lem:cech_acyclic_affine}` is a Lean-location pointer (the `dep*` engine declarations live in that lemma's `\lean{}` bundle), NOT a mathematical dependency on the Čech vanishing result. The prose should clarify this (see Dependency & isolation findings above). Does not block dispatch since P3 is proved.
  - **INFORMATIONAL**: `leandag build` reports 58 `unmatched_lean` entries — all correspond to `\mathlibok` blocks (Mathlib declarations not scanned in the project source). This is normal behavior; no action needed.
  - **INFORMATIONAL**: `leandag show gaps` shows 4 nodes missing `\lean{}` hints (`lem:cech_free_eval_sectionwise`, `lem:cech_free_eval_engine_iso`, `lem:tile_section_localization`, `lem:isIso_fromTildeΓ_of_quasicoherent`). These are on non-active prover routes this iter; can defer.

## Severity summary

### must-fix-this-iter

1. **`lem:open_immersion_pushforward_comp` / `_acyclic` — change-of-scheme Serre transport proof detail gap**: The proof sketch for step (2) names the strategy ("transport across V ≅ Spec R' using naturality of absolute cohomology") but provides no Lean-level target, no auxiliary blueprint lemma, and no `\uses{}` edge to any transport helper. The `rightDerivedNatIso` lean_aux already in the Lean file is the natural tool but has no blueprint entry. A writer must add: (a) a compact blueprint lemma `lem:rightDerivedNatIso` with `\lean{AlgebraicGeometry.rightDerivedNatIso}` and proof sketch; (b) a note in `lem:open_immersion_pushforward_comp` step (2) naming `AlgebraicGeometry.IsAffine.isoSpec` (the canonical affine isomorphism) and explaining the transport chain to `affine_serre_vanishing`. Without this fix the `_acyclic` leaf is unformalizeable from the blueprint alone. This finding makes the chapter `complete: partial`, which via the hard gate blocks both `OpenImmersionPushforward.lean` AND `CechSectionIdentification.lean` from this iter's prover dispatch — see Hard Gate below.

### soon

2. `lem:affine_serre_vanishing` body prose (lines 3244–3248) is stale ("currently formalized in reduced form pending residual") — lemma is now proved. Delete the stale paragraph.
3. 6 isolated `lean_aux` nodes (`rightDerivedNatIso`, `sectionsFunctorCorepIso`, `sectionsFunctor_additive`, `toPresheafOfModules_additive`, `jShriekOU_homEquiv_nat`, `isZero_homology_of_iso_homotopy_id_zero`) have no blueprint entries; `rightDerivedNatIso` is especially urgent given it resolves the must-fix item.
4. `lem:cechSection_contractible` `\uses{lem:cech_acyclic_affine}` misleading as math dependency — add prose clarification.

---

## Hard Gate verdict

**`CechSectionIdentification.lean` (Sub-brick A chain — 6 lemmas)**

The Sub-brick A section itself is well-formed: all 6 lemmas (`lem:cech_backbone_left_sigma`, `lem:pushPull_sigma_iso`, `lem:pushPull_leg_sections`, `lem:pushPull_eval_prod_iso`, `lem:cechSection_complex_iso`, `lem:cechSection_contractible`) have detailed statements and proof sketches, all `\uses{}` labels resolve, and no must-fix finding touches the Sub-brick A section's own content. However, the consolidated chapter is `complete: partial` due to the `OpenImmersionPushforward` proof-detail gap, and the gate rule is per-chapter. **Technically blocked.**

**Recommended action:** Dispatch a blueprint-writer NOW with the directive to: (a) add `lem:rightDerivedNatIso` blueprint entry, (b) fill step (2) of `lem:open_immersion_pushforward_comp` with a `\lean{}` hint and `\uses{}` to the transport helper, (c) delete the stale `affine_serre_vanishing` prose paragraph. This is a small targeted write (< 50 LOC in the blueprint). Then re-dispatch me scoped to `Cohomology_CechHigherDirectImage.tex`. If the scoped re-review returns `complete: true`, `correct: true`, dispatch BOTH provers this same iter via the fast path.

**`OpenImmersionPushforward.lean` (`lem:open_immersion_pushforward_comp` + `_acyclic` leaf)**

**BLOCKED** — must-fix finding (1) directly concerns this file's target. Do not dispatch until the writer pass and scoped re-review clear the gate.

---

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `complete: partial` due to one must-fix proof-detail gap (change-of-scheme Serre transport in `lem:open_immersion_pushforward_comp`); the Sub-brick A chain is internally clean but technically gated by the same chapter; fast-path writer + scoped re-review can unblock both provers within this iter.
