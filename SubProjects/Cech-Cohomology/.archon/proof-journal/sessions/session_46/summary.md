# Session 46 (iter-046) — review summary

## Metadata
- **Sorry count:** 2 → 2 (no regression). Both frozen/superseded: `CechHigherDirectImage.lean:679`
  (frozen P5b), `CechAcyclic.lean:110` (dead `affine`). Prover file `QcohTildeSections.lean` is 0-sorry.
- **Build:** GREEN. Independently re-verified by review: fresh `lake env lean …
  QcohTildeSections.lean` EXIT 0 (only pre-existing `CategoryTheory.Sheaf.val` deprecation warnings,
  lines 732/741/758). `#print axioms` for `tile_section_localization`, `tileReconcileEquiv` =
  `{propext, Classical.choice, Quot.sound}`; `isScalarTower_restrictScalars_obj` = `{propext, Quot.sound}`.
  No `sorryAx`.
- **Lanes planned 1, ran 1** (`mathlib-build`). **+5 axiom-clean decls, 0 new sorries.** Named target
  `tile_section_localization` **SOLVED**.

## Headline — the LAST keystone leaf is closed, axiom-clean
The planner dispatched the final keystone-feeding leaf `tile_section_localization` with the
restrictScalars-carrier recipe (`analogies/tile-descent-instance-shape.md`, produced by the iter-046
mathlib-analogist consult). The recipe **worked exactly as scoped**: the prover built the target plus 4
supporting decls, all axiom-clean. The iter-045 W1/W2/W3 Lean-engineering walls (noncomputable-aux hoist /
`SMul R` unsynthesised / `isDefEq` timeout) were dissolved, not papered. This was the single remaining
ingredient of the 01I8 keystone; the downstream chain (kernel comparison → keystone → Route B → 02KG tops)
is now unblocked. The keystone route has landed axiom-clean decls every prover iter (040:+4, 041:+3,
042:+1, 043:+2, 044:+5, 045:+5, 046:+5).

## Target: `tile_section_localization` (SOLVED)

**Statement (Lean, line 1079):**
`(F : (Spec R).Modules) (U) (P : (F.over U).Presentation) (f g : R) (hg : specBasicOpen g ≤ U) :`
`IsLocalizedModule (Submonoid.powers f) ((modulesSpecToSheaf.obj F).presheaf.map (homOfLE (D(gf) ≤ D(g))).op).hom`

Matches the blueprint claim (`Γ(D(g),F) → Γ(D(gf),F)` exhibits its target as the localisation of its
source at the powers of `f`; equivalently `Γ(D(g),F)_f ≅ Γ(D(gf),F)`). The `\lean{}` pin is correct
(lean-vs-blueprint `qts` confirmed).

**Proof skeleton (as built):**
1. `Ptile := presentationModulesRestrictBasicOpen F U P g hg`; `hσ := section_isLocalizedModule_of_presentation
   (R := CommRingCat.of (Localization.Away g)) … (algebraMap R R_g f)` — `IsLocalizedModule (powers f̄) σ` over `R_g`.
2. **Re-type `σ` between the bundled `(ModuleCat.restrictScalars (algebraMap R R_g)).obj _` carriers**
   (`let σ' := …; have hσ' : … := hσ`). All `Module R` / `Module R_g` / `IsScalarTower R R_g` then
   `inferInstance`-structural — the Prop instance `isScalarTower_restrictScalars_obj` supplies the tower
   (no codegen ⇒ no W1; `SMul R` present ⇒ no W2). The carrier defeq through `modulesSpecToSheaf ∘ restrict`
   is `rfl` only under `maxHeartbeats 1000000` (W3 staged, not papered).
3. `hdesc := isLocalizedModule_powers_restrictScalars_of_algebraMap (A := Localization.Away g) f σ' hσ'`.
4. **Layer A (reconcile, no opens transport):** `of_linearEquiv`/`of_linearEquiv_right` with
   `eSrc := (tileReconcileEquiv F g ⊤).symm`, `eTgt := tileReconcileEquiv F g D(f̄)`; `key` closed by
   `LinearMap.ext; simp [reconcile applies, restrictScalars_apply]; exact tile_restrict_map_apply …`.
   Yields `hμ : IsLocalizedModule (powers f)` for `F`'s restriction over the IMAGE opens `ι ''ᵁ D(f̄) ≤ ι ''ᵁ ⊤`.
5. **Layer B (opens transport):** conjugate `hμ` by `mapIso (eqToIso (congrArg op hop))` equivs via a second
   `of_linearEquiv` pair; `keyB` closed at the uniform `ModuleCat.Hom.hom` level:
   `rw [← ModuleCat.hom_comp, ← Functor.map_comp]; exact congrArg (F.presheaf.map ·).hom (Subsingleton.elim _ _)`.

### Significant attempt-level findings (from `attempts_raw.jsonl`)
- **`tile_restrict_map_eq` (bundled-LinearMap form) FAILED → renamed `tile_restrict_map_apply` (applied form).**
  The bundled equation `(…map h).hom = (…map himg).hom` does NOT typecheck: LHS lives over `R_g`, RHS over `R`.
  Only the underlying functions coincide (`rfl`). Must be stated at the `⇑`-value / applied level with a
  section argument `(y : …)`.
- **`rw [← hop.1, ← hop.2]` on the GOAL FAILED** ("motive is not type correct"). `ι ''ᵁ ⊤` *contains*
  `specBasicOpen g` (rw/simp loops) and the goal's `homOfLE` proof (`PrimeSpectrum.basicOpen_mul`) makes the
  motive ill-typed. Fix: keep basic opens in the goal; put the opens transport in `keyB`'s RHS.
- **`rw [← ModuleCat.comp_apply]` FAILED to match** when `ModuleCat.Hom.hom` mixes with `ConcreteCategory.hom`
  (from `Iso.toLinearEquiv_apply`). Fix: normalise coercions via `Iso.toLinearMap_toLinearEquiv` and fold with
  `← ModuleCat.hom_comp` (the `∘ₗ` form).
- **Final morphism equality** closed by explicit `congrArg (… .hom) (Subsingleton.elim _ _)`, NOT a bare
  `congr`/`ext` — the documented kernel-soundness trap (lean-auditor `iter046` confirmed the safe form was used).

## Supporting decls (4, all axiom-clean)
- `isScalarTower_restrictScalars_obj` (instance) — `IsScalarTower R S ((restrictScalars (algebraMap R S)).obj M)`
  via `IsScalarTower.of_algebraMap_smul` + `restrictScalars.smul_def'`. A Prop ⇒ no codegen ⇒ no W1.
- `tileReconcileEquiv` (noncomputable def) — id-on-carrier `≃ₗ[R]`, `map_smul' := (tile_scalar_compat' …).symm`.
- `tileReconcileEquiv_apply`, `tileReconcileEquiv_symm_apply` (`@[simp]` private) — `rfl`.
- `tile_restrict_map_apply` (private) — `rfl` at applied level.

## Reviewer findings (both highly-recommended, dispatched)
- **lean-auditor `iter046`** (`task_results/lean-auditor-iter046.md`): axiom-clean, 0 critical / 0 major / 8 minor.
  Confirmed `tile_section_localization`'s `keyB` close uses the documented SAFE form
  (`congrArg … (Subsingleton.elim _ _)`), NOT the bare-tactic kernel-soundness trap; `key` uses `LinearMap.ext`
  (safe). All `rfl`-bodied lemmas genuine, not type-mismatch covers. Minors: the 5 `maxHeartbeats` explanatory
  comments are placed BEFORE `set_option` instead of AFTER (Mathlib linter fires); 3 pre-existing `Sheaf.val`
  deprecations (lines 732/741/758).
- **lean-vs-blueprint-checker `qts`** (`task_results/lean-vs-blueprint-checker-qts.md`): statement matches
  blueprint, `\lean{}` pin correct, 0 must-fix. 2 **major** coverage debt (public `tileReconcileEquiv` and
  `isScalarTower_restrictScalars_obj` lack blueprint blocks); 2 **minor** stale `\uses{}` edges on
  `lem:tile_section_localization` (see recommendations).

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:tile_section_localization`: replaced the stale iter-045
  statement-block `% NOTE` (claimed the decl was absent / blocked on W1–W3) with an iter-046 `% NOTE`
  recording it LANDED axiom-clean via the restrictScalars-carrier recipe. `\leanok` (added by sync this iter,
  sha b31330c) is the genuine verdict — left untouched.
- `Cohomology_CechHigherDirectImage.tex`, `lem:tile_section_localization` proof block: replaced the stale
  iter-045 "proof \leanok REMOVED — decl absent" `% NOTE` with an iter-046 LANDED note.
- No `\leanok` added/removed by review. No `\mathlibok` (project theorems, not Mathlib re-exports). No
  `\lean{}` rename (pin already correct).

## Coverage debt (unmatched = 6)
1 pre-existing dead (`CechAcyclic.affine`) + 5 new this iter (`isScalarTower_restrictScalars_obj`,
`tileReconcileEquiv`, `tileReconcileEquiv_apply`, `tileReconcileEquiv_symm_apply`, `tile_restrict_map_apply`).
Listed for the planner in `recommendations.md`.

## Notes (LOW)
- The 5 `maxHeartbeats` blocks each carry their explanatory comment one line ABOVE `set_option …` rather than
  immediately after — the Mathlib style linter wants it after. Cosmetic; non-blocking.

## Blueprint doctor
No structural findings (every chapter `\input`'d, every `\ref`/`\uses` resolves, no `axiom` decls).
