# Recommendations for iter-052 (plan agent)

## TOP PRIORITY — closest-to-completion: discharge `htilde`, make both 02KG tops unconditional
Lane 1 closed the residual math core. The downstream consumer is a **small, ready lane** in
`AffineSerreVanishing.lean`: plug
`sectionCech_homology_exact_of_localizationAway (moduleSpecΓFunctor.obj F) (fun i => g i.down) f hcov p hp`
into `affine_cech_vanishing_qcoh_of_tildeVanishing` and `affine_serre_vanishing_of_tildeVanishing` to
discharge their explicit `htilde` hypothesis. Notes from the prover: `ι := ULift (Fin n)`;
`cechCohomology U F' p` is defeq `(sectionCechComplex U F').homology p`; `0 < p ↔ 1 ≤ p`.
This makes **both 02KG blueprint tops UNCONDITIONAL** — the input P5a/P5b gate on. Frontier-ready, low risk.
HARD GATE: `AffineSerreVanishing.lean` → consolidated chapter `Cohomology_CechHigherDirectImage.tex`;
confirm `complete+correct` before dispatch (it cleared iter-049/050; re-confirm given this iter's edits).

## Coverage debt — blueprint these new `lean_aux` nodes (`archon dag-query unmatched` = 10)
Doctrine: when there is Lean there must be tex. 9 new helpers need blueprint blocks (the 10th,
`CechAcyclic.affine`, is pre-existing dead — leave). I do not author prose; planner/dag-walker should:

**CechAcyclic.lean (Lane 1):**
1. `AwayComparison.isLocalizedModule_comp_away` — composite of two away-localizations. Deps: only
   Mathlib `IsLocalizedModule` API. **NB (lean-vs-blueprint major):** this is DISTINCT from the existing
   `lem:away_comparison_isLocalizedModule` (which `\lean{}`-pins `comparison_isLocalizedModule`, the
   `M_a → M_{ab}` lemma). Give it its own block or bundle into a sibling — do NOT just repoint the
   existing pin.
2. `SectionCechModule.dDiff_exact_of_localizationAway` — route-B module-complex exactness. Deps:
   `dDiff_exact` (`lem:section_cech_module_exact`), `isLocalizedModule_comp_away`, `IsLocalizedModule.iso`.
   Natural home: a sub-lemma of `lem:affine_cech_vanishing_tilde_subcover`. **Blueprint adequacy fix
   (lean-vs-blueprint major):** the current proof sketch says "instantiate that lemma over `R_f`" as if
   trivial; the Lean needed ~120 LOC (composite-localization instances, per-σ equivs `eσL`, naturality,
   ladder). Expand the sketch to name these steps.
3. `sectionCechAbExact_loc` (private) — bundle into `\lean{}` of `lem:affine_cech_vanishing_tilde_subcover`
   (private is NOT exempt from `unmatched`).

**CechHigherDirectImage.lean (Lane 2):**
4. `cechComplexOnX`, 5. `cechNervePointIso`, 6. `cechAugmentation`, 7. `cechAugmentation_comp_d`,
   8. `cechAugmentedComplex` — the augmented-complex object layer (see task_result for each one's deps).
   Bundle private `augmentation_comp_alternatingCofaceMap_objD_zero` into `cechAugmentation_comp_d`'s
   `\lean{}`. The planner should split `lem:cech_augmented_resolution` into **object (built, these 5) +
   exactness (pending)** — I added a `% NOTE (iter-051)` on that block flagging this.

Blueprinting these also unblocks the missing `\leanok` on `lem:affine_cech_vanishing_tilde_subcover`
(its proof-`\leanok` gate currently fails because deps #1/#2 are unblueprinted/mis-pinned — see summary).

## Lane 2 blocker — do NOT re-dispatch `cechAugmented_exact` directly
`cechAugmented_exact` is **missing-infrastructure-blocked**, not a proof-effort gap. Re-assigning it
as-is will fail again. Required structural prerequisite FIRST (separate mathlib-build lane, decomposition
in `task_results/AlgebraicJacobian_Cohomology_CechHigherDirectImage.md`):
- **Step 1:** `X.Modules` complex exact ⇐ exact on underlying `AddCommGrp` sheaves (forgetful exact+faithful).
- **Step 2 (the big piece, ~150-250 LOC):** `AddCommGrp`-sheaf complex exact iff stalkwise exact —
  assemble from `TopCat.Presheaf.stalkFunctor` + `exact_iff_degreewise_exact`-style packaging. Mathlib
  lacks this for `X.Modules`.
Steps 3-4 (stalk = localized extended complex; local exactness = contracting homotopy) reuse the
unconditional `qcoh_iso_tilde_sections` + P3 `sectionCech_affine_vanishing` already built.
**Action:** dispatch a mathlib-analogist (cross-domain) or dag-walker to scope the stalkwise-exactness
criterion before any prover touches `cechAugmented_exact`. Blueprint the criterion as its own chain.
Note Lane 2 ran but only PARTIAL this iter — this is honest progress (object layer), but the planner
should not count `cechAugmented_exact` as near-term without the step-1/2 lane.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **Composite away-localization** (`isLocalizedModule_comp_away`): localize twice (`powers f` then
  `powers (algebraMap R R_f a)` with `a^j = f·h`) ⇒ `R`-linear composite is `IsLocalizedModule (powers a)`.
  Direct `⟨map_units, surj, exists_of_eq⟩` constructor, clear `f^l` via `a^{jl}=f^l h^l`. Avoids the
  Mathlib-absent converse of `of_restrictScalars`.
- **Route-B change-of-ring exactness transport**: instantiate a base-polymorphic module-complex exactness
  over `R_f`, transport back via `Function.Exact.of_ladder_addEquiv_of_exact` with `IsLocalizedModule.iso`
  degreewise equivs; per-coface naturality via `IsLocalizedModule.ext`. Reuse the
  spanning-hypothesis-INDEPENDENT tilde bridge unchanged.
- **Cosimplicial augmentation `ε ≫ objD = 0`**: prove ABSTRACTLY (any augmented cosimplicial object) —
  the concrete whiskered nerve `whnf`-timeouts. `Augmented = Comma (const) (𝟭)` ⇒ `𝟭` on augmentation
  codomain pins the middle object; additive distribution lemmas need **`erw`** (defeq match), and final
  `f ≫ 0 = 0` needs `exact Limits.comp_zero` (not `rw [comp_zero]`). Pre-composition analogue of
  Mathlib's simplicial `AlternatingFaceMapComplex.ε`.
- **set_option ordering:** `set_option ... in` must immediately precede the decl, including its docstring
  — a comment line between two `set_option`s, or between `set_option` and the `/-- -/`, breaks parsing.

## Minor cleanups (non-blocking, auditor)
- Extract the duplicated `sq` proof block shared by `sectionCechAbExact` / `sectionCechAbExact_loc`
  (`CechAcyclic.lean` ~L1781/1811) into a `sectionCechCofaceSquare` lemma.
- Update the stale comment in `CechAcyclic.affine`'s `sorry` body (L84): "L1 STILL MISSING" — the
  tilde-case section side is now done; only the categorical `CechComplex ≅ sectionCechComplex` remains.
