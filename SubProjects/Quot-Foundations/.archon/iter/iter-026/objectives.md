# Iter 026 — Objectives (per-lane detail)

## Lane 1 — FBC `inner_value_eq` (FlatBaseChange.lean) [fine-grained]

Target: de-sorry `base_change_mate_inner_value_eq` @1627, then `base_change_mate_gstar_transpose` @1810.
Blueprint: `Cohomology_FlatBaseChange.tex` (`lem:base_change_mate_inner_value_eq`,
`lem:base_change_mate_inner_eCancel` — new "Order of operations" paragraph).

Recipe (pre-subst route): apply `pullbackPushforward_unit_comp e.hom (Spec.map inclA)` to distribute the
`(g')`-unit WHILE `g'` is the free composite `e.hom ≫ Spec inclA` — before the codomain read substitutes
the literal `pullback.fst/snd` legs and locks the unit into `(pullbackSpecIso).hom ≫ Spec includeLeft`.
Cancel with the 3 already-closed atoms on the free-form factors; then read through `codomain_read`; then
Seam 1 (`base_change_mate_unit_value`) + the `inclA∘φ=inclR'∘ψ` transport lands on ρ. Fallback: positional
`conv`/congruence on the locked factor.

Prior dead ends (do not repeat): whole-goal `rfl`/`simp`; per-generator brute force; `rw`/`simp only` /
`have…rw` matching the atom LHS against the post-codomain-read locked goal (literal-form lock, memory
`fbc-subst-legs-literal-form-lock`). Do NOT route through `fstar_reindex`/`_legs` (dead @1421).

Success bar: `inner_value_eq` closed via pre-subst, ideally `gstar_transpose`. Partial OK (leave the
distributed-but-uncancelled state). Out of scope: affine @1983, FBC-B @2005.

## Lane 2 — QUOT G1-core (QuotScheme.lean) [mathlib-build]

Target: build `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent` (new decl).
Blueprint: `Picard_QuotScheme.tex` (`lem:qcoh_affine_section_localization`). Full route:
`analogies/quot-qcoh-affine-globalization.md` (G1-core + G1-assemble).

Statement: QC `M : (Spec R).Modules`, `f : R` ⟹ `Γ(M,⊤)→Γ(M,D(f))` is `IsLocalizedModule (powers f)` /R.
4 steps: (1) refine QuasicoherentData cover to basic opens (`PrimeSpectrum.isBasis_basic_opens`) + finite
subcover (`CompactSpace (PrimeSpectrum R)`); (2) local-tilde on each `D(g_a)` via
`isIso_fromTildeΓ_of_presentation` + `isLocalization_basicOpen`; (3) flat localization (`IsLocalization.flat`)
of the finite sheaf-equalizer `Γ(M,⊤)→∏N_a⇉∏Γ(M,D(g_a g_b))` matches the `Γ(M,D(f))` equalizer ⟹
`Γ(M,⊤)_f ≅ Γ(M,D(f))`; (4) conclude. No sorry; if blocked, hand off the precise sub-gap (likely the
finite-sheaf-equalizer packaging for `SheafOfModules`). Optionally chain gap1
(`isIso_fromTildeΓ_of_isQuasicoherent`) via the G1-assemble glue. Out of scope: 4 protected stubs, SNAP,
annihilator, Grassmannian nodes.

## Lane 3 — GR-glue (GrassmannianCells.lean) [mathlib-build]

Target: build `AlgebraicGeometry.Grassmannian.scheme` (new decl). Blueprint:
`Picard_GrassmannianCells.tex` (`def:gr_glued_scheme`).

Populate a `Scheme.GlueData` (Mathlib `AlgebraicGeometry/Gluing.lean`, extends `CategoryTheory.GlueData
Scheme`) from the DONE infra — index = `d`-subsets, objects = `affineChart`, overlaps `U^I_J`, transitions
= `transitionMap` `θ_{I,J}`, cocycle = `cocycleCondition` (`lem:gr_cocycle`) — then `Grassmannian.scheme :=
(…).glued`. No sorry; if a `GlueData` field obligation (open-immersion / pullback-compat / cocycle `t'`)
needs a bridge from the chart data, build it named axiom-clean. `lem:gr_separated`/`lem:gr_proper` are
next-iter follow-ons (not in scope unless budget remains after the glued scheme lands).
