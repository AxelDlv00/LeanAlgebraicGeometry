# Mathlib Analogist Directive — φ-compatibility morphisms for piece (i.b)

## Slug

phi-compatibility-morphisms-iter135

## Design question

For each of the four scheme morphisms in piece (i.b) of
`AlgebraicJacobian/Cotangent/GrpObj.lean`:

  - `π_G : G.left ⟶ Spec (.of k)` (structure map / `G.hom`)
  - `η_G.left : Spec (.of k) ⟶ G.left` (identity-section underlying
    scheme map of the `GrpObj` `η`)
  - `pr_2 : (G ⊗ G).left ⟶ G.left` (second projection in
    `Over (Spec (.of k))`)
  - `s.left : G.left ⟶ (G ⊗ G).left` (canonical section
    `s := lift (𝟙 G) (terminal-toUnit ≫ η_G)` of the first projection)

what is the canonical Mathlib idiom for the compatibility morphism `φ`
that `PresheafOfModules.pullback` consumes? Specifically:

(A) **Signature of `φ`**. For a scheme morphism `f : Y ⟶ Z`,
`PresheafOfModules.pullback` (in
`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`) takes a
compatibility morphism on `RingCat`-valued presheaves
`φ : S ⟶ F.op ⋙ R` where `S` lives on `Z` and `R` on `Y` and `F`
is the underlying continuous map. The project already exposes
`schemeHomRingCompatibility` at
`AlgebraicJacobian/Cotangent/GrpObj.lean:417-419` as
`((adj).homEquiv _ _).symm f.c` for `RingCat`-valued sheaves — IS
THIS THE RIGHT SHAPE for `PresheafOfModules.pullback`? Or does the
latter want a different functor target (`CommRingCat` vs `RingCat`),
a different direction, or a forgotten `forget₂` coercion?

(B) **Elaboration of the intended-type signatures**. For each of the 3
iter-134 placeholder theorems, give the **literal Lean text** of the
intended type using `PresheafOfModules.pullback` and the
`schemeHomRingCompatibility`-shaped φ. The 3 intended types are:

  1. `lem:GrpObj_omega_basechange_proj` (current iter-134 placeholder at
     `AlgebraicJacobian/Cotangent/GrpObj.lean:476`):

     ```
     relativeDifferentialsPresheaf
         (CategoryTheory.Limits.prod.fst : (G ⊗ G).left ⟶ G.left).⋯ ≅
       (PresheafOfModules.pullback (φ_pr_two G)).obj
         (relativeDifferentialsPresheaf G.hom)
     ```

     where the LHS uses `pr_1` as the *G*-scheme structure morphism
     and the RHS is `pr_2^* Ω_{G/k}`. The "⋯" elides the structural
     bookkeeping (`Over.hom` extraction, fibre-product universal property,
     etc.) that you should pin down concretely.

  2. `lem:GrpObj_omega_restrict_to_identity_section` (current iter-134
     placeholder at `AlgebraicJacobian/Cotangent/GrpObj.lean:508`):

     ```
     (PresheafOfModules.pullback (φ_section G)).obj
         ((PresheafOfModules.pullback (φ_pr_two G)).obj
           (relativeDifferentialsPresheaf G.hom))  ≅
       (PresheafOfModules.pullback (φ_str G)).obj
         ((PresheafOfModules.pullback (φ_η G)).obj
           (relativeDifferentialsPresheaf G.hom))
     ```

  3. `lem:GrpObj_mulRight_globalises` (current iter-134 placeholder at
     `AlgebraicJacobian/Cotangent/GrpObj.lean:566`):

     ```
     relativeDifferentialsPresheaf G.hom  ≅
       (PresheafOfModules.pullback (φ_str G)).obj
         ((PresheafOfModules.pullback (φ_η G)).obj
           (relativeDifferentialsPresheaf G.hom))
     ```

(C) **Home file for the 4 `φ_*` definitions**. Should the four
`φ_str G`, `φ_η G`, `φ_pr_two G`, `φ_section G` definitions live as
in-file helpers in `Cotangent/GrpObj.lean`, as utilities in
`AlgebraicJacobian/Differentials.lean` (where the parent
`relativeDifferentialsPresheaf` already lives and where the
`schemeHomRingCompatibility` pattern is generic), or as a Mathlib PR
candidate (a packaging utility around `pullbackPushforwardAdjunction`
applied to `f.c`)?

(D) **Elaboration sanity check**. Do the intended-type Lean signatures
in (B) *actually elaborate cleanly* in the current Mathlib /
project state? I.e., would the iter-135 refactor of the 3
placeholder theorems to intended-type + `sorry` succeed at the
type-elaboration level, or are there hidden universe / typeclass /
forget₂ issues the iter-134 prover ran into?

The iter-134 prover's task-result records under "Next iter (iter-135+)
handoff" that "The structure-sheaf comorphism `f.c` has type
`Z.presheaf ⟶ f.base _* Y.presheaf` which is the C → D op shape expected
by `PresheafOfModules.pullback (φ : S ⟶ F.op ⋙ R)` — so `f.c` itself
(with the `forget₂ CommRingCat RingCat` conversion) should be usable as
the φ." Verify whether this directional claim is correct.

## Project artifact(s) under question

- `AlgebraicJacobian/Cotangent/GrpObj.lean:417-419` —
  `schemeHomRingCompatibility` (the iter-134 packaging helper around
  `((adj).homEquiv _ _).symm f.c` for `CommRingCat`-valued presheaves).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:449-572` — the 3 iter-134
  placeholder theorems (`relativeDifferentialsPresheaf_basechange_along_proj_two`
  at line 476, `relativeDifferentialsPresheaf_restrict_along_identity_section`
  at line 508, `mulRight_globalises_cotangent` at line 566) and their
  docstrings with intended types spelled out.
- `AlgebraicJacobian/Differentials.lean:51-54` — the parent
  `relativeDifferentialsPresheaf` definition with its `φ'` packaging.
- `blueprint/src/chapters/RigidityKbar.tex:298-441` — pinned signature
  stubs for all 3 placeholder theorems, with the 4 `φ_*` morphisms
  named in prose.
- `analogies/mulright-globalises-cotangent.md` — the iter-133 mathlib-
  analogist verdict (Decision 4: sheaf-level RHS; Decisions 2+4 reference
  `PresheafOfModules.pullback`).

## Mathlib precedents to check

- `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback` — the home of
  `PresheafOfModules.pullback`, `pullbackComp`, `pullbackId`. Read the
  module docstring + `def pullback` signature to pin (A) and the
  composition / identity lemmas needed for the iter-136+ Step 3 body.
- `Mathlib.Topology.Sheaves.Pullback` — `TopCat.Presheaf.pullback` and
  `TopCat.Presheaf.pullbackPushforwardAdjunction`. The latter's
  `homEquiv` is what `schemeHomRingCompatibility` uses; confirm the
  direction matches what `PresheafOfModules.pullback`'s `φ` wants.
- `Mathlib.Algebra.Category.ModuleCat.Presheaf.Differentials` — used
  by the project's `relativeDifferentials'` construction. Look for any
  existing pullback-compatibility helpers there.
- `Mathlib.RingTheory.Kaehler.TensorProduct` —
  `KaehlerDifferential.tensorKaehlerEquiv` is the algebra-side base-
  change-of-Ω iso the project wants to upgrade for Step 2 (out of scope
  for THIS analogist call; this iter's focus is φ-compatibility, not
  Step 2's body).

## Decisions you must render

For each of (A), (B), (C), (D) above, render a clear verdict:

- (A) Compatibility-morphism shape: does `schemeHomRingCompatibility`
  match what `PresheafOfModules.pullback` wants? If not, what's the
  fix (different functor target / direction / adjunction transpose)?
- (B) Intended-type Lean signatures: provide the **literal Lean text**
  for each of the 3 intended types, ready to drop into the refactor.
- (C) Home file for the 4 `φ_*` morphisms: in-file helper in
  `Cotangent/GrpObj.lean`, or `Differentials.lean`, or Mathlib PR
  candidate. Trade-offs.
- (D) Elaboration sanity check: do the (B) signatures elaborate cleanly,
  or are there hidden universe / typeclass / `forget₂` issues?

## Final overall verdict

PROCEED-WITH-INTENDED-TYPES-AS-WRITTEN / PROCEED-WITH-MODIFIED-TYPES /
ALIGN-WITH-MATHLIB-DIFFERENT-IDIOM / BLOCKED-ON-MATHLIB-GAP-FIRST.

If BLOCKED-ON-MATHLIB-GAP-FIRST: name precisely which Mathlib gap fills
must precede the intended-type signatures elaborating, and rough LOC
envelope of each.

## Persistent file

Save your design rationale to
`analogies/phi-compatibility-morphisms.md` (a new file). Future iters
re-read this. Save your report to
`.archon/task_results/mathlib-analogist-phi-compatibility-morphisms-iter135.md`.

## Out of scope

- The Step 2 body (`tensorKaehlerEquiv` upgrade to presheaf level).
  That's the next mathlib-analogist call, after this one settles φ.
- The Step 3 body chain. That's iter-136 prover lane work.
- The piece (i.c) chart-localisation bridge from sheaf-level RHS to
  `cotangentSpaceAtIdentity G`. Iter-137+ work.
- The `shearMulRight` shape. Already closed iter-134.
