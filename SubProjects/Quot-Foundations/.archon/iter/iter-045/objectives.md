# Iter 045 — Objectives (per-lane detail)

## Lane 1 — GF-G1 build · `Picard/FlatteningStratification.lean` [mathlib-build]
- **Structural edit:** add `import AlgebraicJacobian.Picard.QuotScheme` (1st cross-leaf import; acyclic — verified).
- **Floor:** `gf_qcoh_fintype_finite_sections` (Stacks 01PB). Consumes gap2 `isLocalizedModule_basicOpen`.
  Algebraic gluing = `Module.Finite.of_localizationSpan` [verified, `Mathlib.RingTheory.Localization.Finiteness`].
- **Stretch (same lane):** G3 `gf_flat_locality_assembly` (consumes G1) → close `genericFlatness` @2264.
- Blueprint blocks: `lem:gf_qcoh_fintype_finite_sections` (L1513), `lem:gf_flat_locality_assembly` (L1560),
  `thm:generic_flatness` (L1597). HARD GATE: iter-044 full review ✓complete/✓correct.
- Verdict input: progress-critic UNCLEAR (fresh, legitimate unblock — watch result).

## Lane 2 — FBC keystone `_legs_conj` · `Cohomology/FlatBaseChange.lean` [mathlib-build] · FINAL round
- Build `adjR` (extendRestrictScalarsAdj∘tilde composite matching `read_param` 6-iso chain) + `β` comparison
  nat-iso; `adjL`/`hunitL` DONE (baked @1880-1890, depth-2). Close via `(conjugateEquiv adjL adjR).injective`
  + conj-2b/2c/2d chained by `conjugateEquiv_symm_comp`/`_whiskerLeft`/`_whiskerRight`/`_associator_hom`.
- Recipe: `analogies/fbc-composite-mate-recognition.md`. Edit @1815+. NO positional rw/simp (factor-3
  instance-path divergence — iter-044 item 1). NO monolithic β.
- **KILL-CRITERION (progress-critic-endorsed, no second reprieve):** if no standalone `adjR` decl lands →
  partial-progress handoff (mathlib-build discipline) + PARK + escalate via TO_USER. Do NOT re-dispatch FBC.

## Deferred (iter-046, documented — not under-dispatch)
- QUOT annihilator reverse-incl (`lem:modules_annihilator_ideal`, frontier-ready) + P2 — same file as the
  GF-G1 import target; edit-vs-import race ⟹ 1-iter defer (progress-critic: acceptable, bounded).
- SNAP `Picard_SectionGradedRing.tex` blueprint prep; GR-quot/repr new-file scaffolds.
