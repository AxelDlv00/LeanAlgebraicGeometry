<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-07T03:55:32Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iteration 007

## Problem and motivation

Iteration 006 closed Phase A step 5 *main* (the eight-helper construction of `Scheme.toModuleKSheaf` for `C : Over (Spec (CommRingCat.of k))`) honestly, leaving the project at the post-iter-005 baseline of 10 sorries (9 protected + 1 deferred `representable`). Iter-007 plan-agent re-probes of Mathlib confirm:

- **No advance** on the multi-iteration tracks: `MonoidalCategory X.Modules` (gates `LineBundle` refinement and hence `representable`) and the Serre-finiteness API (no `Coherent`/`QuasiCoherent`/`Čech`/`SerreFiniteness` declarations).
- **One major upstream advance**: `HasWeakSheafify` and `HasSheafify` for `Scheme.etaleTopology.{u}` and its `.over (Spec k)` lift, valued in `AddCommGrpCat.{u+1}`, are now both inferable in current Mathlib. Track C step 3 *proper* (étale-sheafifying `PicardFunctorAb`) is therefore reachable. Caveat: the value-category universe is `AddCommGrpCat.{u+1}`, one level above the iter-004 `PicardFunctorAb`'s `.{u}`. Resolving the universe pinning requires either (a) re-defining `PicardFunctorAb` at `.{u+1}` or (b) a careful universe-lift functor composition (`AddCommGrpCat.uliftFunctor`'s morphism universe does not align under naive composition). Track 2 work for iter-008+.

Iter-007 is therefore a small **polish iteration**: three consumer-facing helpers, each probe-confirmed at a one-line body. They build the bridge between the iter-006 `ModuleCat k`-valued cohomology and the iter-004 `AddCommGrpCat`-valued cohomology (useful for downstream consumers transporting between $H^i$ flavours), and complete the simp-lemma surface around the iter-005 `forgetCompare` for `PicardFunctorAb`.

## Mathematical justification

Two of the three helpers (the simp lemmas) are pure unfolding identities — the underlying-functor / underlying-set agreements they record are already used implicitly in downstream proofs (e.g.\ in iter-006 `toModuleKPresheaf_isSheaf`). Tagging them `@[simp]` and giving them stable names makes that machinery available to consumers without re-deriving the unfolding each time.

The third helper (`toModuleKSheaf_forgetCompare`) is the analogue, on the iter-006 side, of the iter-005 `PicardFunctorAb.forgetCompare` natural iso. The same definitional identity holds: $\sheafCompose\,J\,(\forget_2\,(\ModuleCat\,k)\,\AddCommGrpCat)\,(\toModuleKSheaf\,C)$ has $(\AddCommGrpCat.\mathrm{of}\,(\Gamma(C, U)))$ at every $U$ and the underlying $C.\mathrm{left}.\mathtt{presheaf}.\mathrm{map}$ on morphisms — exactly the data of $\toAbSheaf\,C.\mathrm{left}$. Probe-confirmed (`lean_run_code`, iter-007 plan-agent): the closure body `Iso.refl _` typechecks against current Mathlib.

The natural iso enables a downstream pattern: any cohomology lemma proved on $\toAbSheaf$ transfers to $\toModuleKSheaf$ via the forget functor, modulo the standard `sheafCompose`-with-$\forget_2$ Ext-comparison. This is the formal handle that bridges the iter-004 abelian-group-level cohomology to the iter-006 $k$-module-level cohomology. The bridge is needed for the eventual `genus` definition: a future `genus` proof using $H^1$-of-the-`AddCommGrpCat`-sheaf (perhaps imported from a parallel result on $\toAbSheaf$) needs `toModuleKSheaf_forgetCompare` to push that result onto the $\Module k$ side.

## Changes to make

All three changes are local to existing files; no new files are needed.

### Change 1 — `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`: add `toModuleKSheaf_forgetCompare`

Append the following at the end of the existing `namespace AlgebraicGeometry.Scheme` block (after `toModuleKSheaf` at line 154, before the `end AlgebraicGeometry.Scheme` at line 156):

```lean
/-- Phase A step 5 polish (iter-007): forget-and-recover natural iso between
the iter-006 `ModuleCat k`-valued structure sheaf and the iter-004
`AddCommGrpCat`-valued structure sheaf. The two sheaves agree on the nose at
the underlying-presheaf level: forgetting from `ModuleCat k` to `AddCommGrpCat`
via `forget₂` recovers the iter-004 `toAbSheaf C.left`. Closure body
`Iso.refl _`; probe-confirmed (`lean_run_code`, iter-007 plan-agent). -/
noncomputable def toModuleKSheaf_forgetCompare
    (C : Over (Spec (CommRingCat.of k))) :
    (sheafCompose (Opens.grothendieckTopology C.left.toTopCat)
        (forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u})).obj (toModuleKSheaf C)
      ≅ toAbSheaf C.left :=
  sorry
```

Notes:
- Place this declaration after `toModuleKSheaf` but before `end AlgebraicGeometry.Scheme`.
- Use `noncomputable` (the body uses noncomputable Mathlib API even though the iso itself is `Iso.refl _`).
- The `.{u}` on `ModuleCat.{u} k` and `AddCommGrpCat.{u}` is required to pin the universe to the iter-006 / iter-004 conventions; matches `toAbSheaf`'s universe `.{u}`.
- The expected closure body is `Iso.refl _` (probe-confirmed). Document any deviation in `task_results/Cohomology_StructureSheafModuleK.lean.md`.

### Change 2 — `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`: add `toModuleKPresheaf_obj` simp lemma

Append the following directly after the existing `toModuleKPresheaf` definition (around line 138, before `lemma toModuleKPresheaf_isSheaf` at line 142):

```lean
/-- Object-evaluation simp lemma for `toModuleKPresheaf`. Definitionally true
by construction; tagged `@[simp]` so consumers can rewrite without unfolding
the constructor. Phase A step 5 polish (iter-007). -/
@[simp] lemma toModuleKPresheaf_obj (C : Over (Spec (CommRingCat.of k)))
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    (toModuleKPresheaf C).obj U = ModuleCat.of k (C.left.presheaf.obj U) :=
  sorry
```

Notes:
- Expected closure body: `rfl`. Probe-confirmed.
- The lemma should be tagged `@[simp]` for downstream rewriting.
- Keep `noncomputable` off (the lemma is propositional).

### Change 3 — `AlgebraicJacobian/Picard/FunctorAb.lean`: add `PicardFunctorAb_forget_obj` simp lemma

Append the following at the end of the existing `namespace AlgebraicGeometry.Scheme` block, *after* the `forgetCompare` definition (line 73 of the current file), and before `end AlgebraicGeometry.Scheme`:

```lean
/-- Object-evaluation simp lemma for `PicardFunctorAb` along the forgetful
functor. The `Additive` wrapper inside the iter-004 `PicardFunctorAb` is
type-equal to its underlying multiplicative quotient, so applying
`forget AddCommGrpCat` recovers `(PicardFunctor C).obj S` on the nose. Tagged
`@[simp]` for downstream rewriting. Phase C step 4 polish (iter-007). -/
@[simp] lemma PicardFunctorAb_forget_obj (C : Over (Spec (CommRingCat.of k)))
    (S : (Over (Spec (CommRingCat.of k)))ᵒᵖ) :
    (CategoryTheory.forget AddCommGrpCat).obj ((PicardFunctorAb C).obj S)
      = (PicardFunctor C).obj S :=
  sorry
```

Notes:
- Expected closure body: `rfl`. Probe-confirmed.
- The lemma should be tagged `@[simp]`.
- The `Field k` typeclass already in scope (from `variable {k : Type u} [Field k]` at line 40 of the current file) is sufficient.

## Verification

After the refactor:

1. Run `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" AlgebraicJacobian/ --format=summary`. Expected sorry count: `10 → 13` (3 new scaffold sorries: 2 in `Cohomology/StructureSheafModuleK.lean`, 1 in `Picard/FunctorAb.lean`).
2. `lean_diagnostic_messages` on each modified file should return only `declaration uses sorry` warnings on the three new sites (no errors).
3. The eight iter-006 closures and the two iter-005 closures inside `Cohomology/StructureSheafModuleK.lean` must remain untouched. Their line numbers may shift due to Change 2's insertion; the bodies and signatures must be unchanged.
4. `archon-protected.yaml` is unchanged.
5. `leanblueprint checkdecls` should still pass (the three new blueprint blocks are added with corresponding `\lean{...}` references in the blueprint chapters).

## Forbidden shortcuts (do not introduce)

- New `axiom` declarations.
- Closing `toModuleKSheaf_forgetCompare` with a non-natural iso between unrelated functors. The probe confirms `Iso.refl _` works directly; deviations should be documented but mathematically equivalent.
- Closing the simp lemmas with anything other than `rfl` or a defeq tactic. They are pure unfolding identities.
- Renaming `kToSection`, `algebraSection`, `algebraMap_eq_kToSection`, `kToSection_naturality`, `algebraMap_naturality`, `toModuleKPresheaf`, `toModuleKPresheaf_isSheaf`, `toModuleKSheaf` (or any iter-005 declaration).
- Reordering existing declarations or namespaces in `Cohomology/StructureSheafModuleK.lean` or `Picard/FunctorAb.lean`.

## Out of scope (do not touch)

- The 9 protected sorries in `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`.
- `PicardFunctor.representable` in `Picard/Functor.lean` (deferred).
- Any other file (`Rigidity.lean`, `Picard/LineBundle.lean`, `Cohomology/SheafCompose.lean`, `Cohomology/StructureSheafAb.lean`, `Picard/Functor.lean`).
- Track 1 (Phase A step 6 / Serre finiteness) and Track 2 (étale sheafification of `PicardFunctorAb`) — both deferred to iter-008+; documented in `task_pending.md`.

## Expected post-refactor state

- Sorry count: 10 → 13 (three new scaffolds).
- File sizes: `Cohomology/StructureSheafModuleK.lean` ~157 LOC (+ ~25 LOC for two scaffolds), `Picard/FunctorAb.lean` ~95 LOC (+ ~10 LOC for one scaffold).
- All eight iter-006 closures and the two iter-005 closures intact.
- `archon-protected.yaml` unchanged.
- Blueprint already updated by the plan agent: `Cohomology_StructureSheafModuleK.tex` carries the two new `\lean{...}` blocks (`def:Scheme_toModuleKSheaf_forgetCompare`, `lem:Scheme_toModuleKPresheaf_obj`); `Picard_FunctorAb.tex` carries the one new block (`lem:PicardFunctorAb_forget_obj`). The prover round (next) will then close the three sorries with their probe-confirmed one-liners.
