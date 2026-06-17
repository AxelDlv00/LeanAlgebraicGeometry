# Mathlib Analogist Report

## Slug

phi-compatibility-morphisms-iter135

## Iteration

135

## Question

For each of the four scheme morphisms in piece (i.b) of
`Cotangent/GrpObj.lean` (`G.hom`, `η[G].left`, `(snd G G).left`,
`s.left`), what is the canonical Mathlib idiom for the compatibility
morphism `φ` that `PresheafOfModules.pullback` consumes?
Sub-questions (A)–(D) per the iter-135 directive.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (A) φ-shape: `schemeHomRingCompatibility` vs Mathlib idiom | ALIGN_WITH_MATHLIB | critical |
| (B) Intended-type Lean signatures | PROCEED (elaboration succeeds) | informational |
| (C) Home file for the 4 φ_* morphisms | ALIGN_WITH_MATHLIB | major |
| (D) Elaboration sanity check | PROCEED | informational |

## Findings

### (A) Shape of the φ-compatibility morphism

**`schemeHomRingCompatibility` is the WRONG shape for `PresheafOfModules.pullback`.**

Mathlib's `PresheafOfModules.pullback`
(`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:38–45`):
```
variable {C : Type u₁} [Category.{v₁} C] {D : Type u₂} [Category.{v₂} D]
  {F : C ⥤ D} {R : Dᵒᵖ ⥤ RingCat.{u}} {S : Cᵒᵖ ⥤ RingCat.{u}}
  (φ : S ⟶ F.op ⋙ R) [(pushforward.{v} φ).IsRightAdjoint]
noncomputable def pullback : PresheafOfModules.{v} S ⥤ PresheafOfModules.{v} R
```
For a scheme morphism `f : X ⟶ Y`, the φ for `PresheafOfModules.pullback` is
`Y.ringCatSheaf.obj ⟶ (Opens.map f.base).op ⋙ X.ringCatSheaf.obj`, i.e.
`f.c : Y.presheaf ⟶ f.base _* X.presheaf` whiskered with `forget₂ CommRingCat RingCat`.
This is a morphism of presheaves **on Y** (the base).

`schemeHomRingCompatibility` (`Cotangent/GrpObj.lean:417–419`) instead
returns the **adjunction transpose**
`((adj).homEquiv _ _).symm f.c : (TopCat.Presheaf.pullback f.base).obj Y.presheaf ⟶ X.presheaf`,
i.e. a morphism of presheaves **on X** (the total side). That is the
correct shape for `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`
in its `F = 𝟭 D` special case (`φ' : S' ⟶ R`), which is what
`relativeDifferentialsPresheaf` consumes — but it does **not** match
`PresheafOfModules.pullback`'s general `(φ : S ⟶ F.op ⋙ R)` shape.

**Mathlib already provides the right helper**: `Scheme.Hom.toRingCatSheafHom`
(`Mathlib/AlgebraicGeometry/Modules/Presheaf.lean:42–45`):
```
def Hom.toRingCatSheafHom (f : X ⟶ Y) :
    Y.ringCatSheaf ⟶ ((TopologicalSpace.Opens.map f.base).sheafPushforwardContinuous
      _ _ _).obj X.ringCatSheaf where
  hom := Functor.whiskerRight f.c _
```
Project then writes
```
(Scheme.Hom.toRingCatSheafHom f).hom :
  Y.ringCatSheaf.obj ⟶ (Opens.map f.base).op ⋙ X.ringCatSheaf.obj
```
(the `.hom` field unwraps the `InducedCategory.Hom` of a
`TopCat.Sheaf`). This is exactly the φ for `PresheafOfModules.pullback`.

Equivalently, the project could spell it directly as
`Functor.whiskerRight f.c (forget₂ CommRingCat RingCat.{u})`.

The iter-134 prover's directional handoff claim
(`f.c` itself with `forget₂` conversion is usable as φ) is **correct**.

### (B) Intended-type Lean signatures (literal Lean text)

The three iter-134 placeholder theorems should be refactored to the
following intended types. All three elaborate cleanly against
current Mathlib (verified via `lean_run_code`, see (D) below).

#### (B1) `relativeDifferentialsPresheaf_basechange_along_proj_two`

Currently `Cotangent/GrpObj.lean:476` (placeholder).
Intended type (using `(fst G G).left` to view `(G ⊗ G).left` as a
`G.left`-scheme via the first projection, and pulling `Ω_{G/k}`
along the second projection):

```lean
theorem relativeDifferentialsPresheaf_basechange_along_proj_two
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    Nonempty
      (Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
        (PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
          (Scheme.relativeDifferentialsPresheaf G.hom))
```

#### (B2) `relativeDifferentialsPresheaf_restrict_along_identity_section`

Currently `Cotangent/GrpObj.lean:508` (placeholder). Intended type:

```lean
theorem relativeDifferentialsPresheaf_restrict_along_identity_section
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    Nonempty
      ((PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom
              (lift (𝟙 G) (toUnit G ≫ η[G])).left).hom).obj
          ((PresheafOfModules.pullback
              (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
            (Scheme.relativeDifferentialsPresheaf G.hom)) ≅
        (PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
          ((PresheafOfModules.pullback
              (Scheme.Hom.toRingCatSheafHom
                (CategoryTheory.CommaMorphism.left η[G])).hom).obj
            (Scheme.relativeDifferentialsPresheaf G.hom)))
```

#### (B3) `mulRight_globalises_cotangent`

Currently `Cotangent/GrpObj.lean:566` (placeholder). Intended type:

```lean
theorem mulRight_globalises_cotangent
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    Nonempty
      (Scheme.relativeDifferentialsPresheaf G.hom ≅
        (PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
          ((PresheafOfModules.pullback
              (Scheme.Hom.toRingCatSheafHom
                (CategoryTheory.CommaMorphism.left η[G])).hom).obj
            (Scheme.relativeDifferentialsPresheaf G.hom)))
```

(For all three: the `Nonempty` wrapper preserves the iter-134
`Iso.refl`-as-placeholder convention; the body becomes `sorry`/`⟨...⟩`
once the closure chain lands. Iter-135 may drop the `Nonempty` if the
target is a constructive iso — the iter-134 placeholders chose it to
match the original "Nonempty"-style for shear-iso ergonomics, but the
intended-type closure can be a `def` returning the iso directly.)

#### Optional local readability binding

To match the directive's `φ_str / φ_η / φ_pr_two / φ_section`
nomenclature, prover lanes may write the statements with local
`let`-bindings:

```lean
    -- inside a `def` / structure, or inlined in the statement via `let`
    let φ_str    := (Scheme.Hom.toRingCatSheafHom G.hom).hom
    let φ_η      := (Scheme.Hom.toRingCatSheafHom
                       (CategoryTheory.CommaMorphism.left η[G])).hom
    let φ_pr_two := (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom
    let φ_section := (Scheme.Hom.toRingCatSheafHom
                        (lift (𝟙 G) (toUnit G ≫ η[G])).left).hom
```

This is a stylistic convenience, not a separate `def`-level
abstraction (see (C)).

### (C) Home file for the 4 φ_* morphisms

**No new project-side `def`s are needed.** Mathlib already provides
`Scheme.Hom.toRingCatSheafHom`; the project should call it inline (or
bind `let φ_* := ...` for legibility). Rationale:

- Defining `φ_str / φ_η / φ_pr_two / φ_section` as project `def`s adds
  4 layers of trivial indirection above `toRingCatSheafHom` — pure
  overhead, no semantic content. The naming benefit is recovered by
  `let`-bindings local to each statement.
- The existing `schemeHomRingCompatibility` should remain in place
  (it's used by `relativeDifferentialsPresheaf`'s `relativeDifferentials'`
  call and is the **adjunction transpose** shape — a different
  convention from what `PresheafOfModules.pullback` wants). DO NOT
  attempt to "unify" the two; they serve distinct downstream consumers.
- A Mathlib PR is unnecessary: `Scheme.Hom.toRingCatSheafHom` already
  packages the desired wrapper.

### (D) Elaboration sanity check

**All three intended types in (B) elaborate cleanly** against the
current project/Mathlib state. Verified via `lean_run_code` with the
following snippet (output: `success: true`, only `declaration uses sorry`
warnings):

```lean
import AlgebraicJacobian.Cotangent.GrpObj
import Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj
open AlgebraicGeometry

universe u

namespace TestGrp
variable {k : Type u} [Field k]
variable (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]

-- (B3): mulRight_globalises_cotangent intended type
noncomputable example : Scheme.relativeDifferentialsPresheaf G.hom ≅
    (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
      ((PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom (CategoryTheory.CommaMorphism.left η[G])).hom).obj
        (Scheme.relativeDifferentialsPresheaf G.hom)) := sorry

-- (B1): relativeDifferentialsPresheaf_basechange_along_proj_two intended type
noncomputable example :
    Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
    (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
      (Scheme.relativeDifferentialsPresheaf G.hom) := sorry

-- (B2): relativeDifferentialsPresheaf_restrict_along_identity_section intended type
noncomputable example :
    (PresheafOfModules.pullback
        (Scheme.Hom.toRingCatSheafHom (lift (𝟙 G) (toUnit G ≫ η[G])).left).hom).obj
      ((PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
        (Scheme.relativeDifferentialsPresheaf G.hom)) ≅
    (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
      ((PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom (CategoryTheory.CommaMorphism.left η[G])).hom).obj
        (Scheme.relativeDifferentialsPresheaf G.hom)) := sorry
end TestGrp
```

**No hidden universe / typeclass / `forget₂` issues**:
- The `pushforward φ).IsRightAdjoint` instance fires automatically
  via the Mathlib instance at `Pullback.lean:97–99` (which works for
  any `SmallCategory C, D` in `Type u`); `Opens X.toTopCat` for
  `X : Scheme.{u}` satisfies this.
- The `forget₂ CommRingCat RingCat.{u}` whiskering is hidden inside
  `Scheme.Hom.toRingCatSheafHom`; the `.hom` projection exposes the
  resulting nat trans without further unfolding hints.
- `Scheme.relativeDifferentialsPresheaf` returns
  `X.PresheafOfModules = PresheafOfModules X.ringCatSheaf.obj`, which
  matches the implicit `S = Y.ringCatSheaf.obj` and `R = X.ringCatSheaf.obj`
  expected by `PresheafOfModules.pullback` in our application.

## Must-fix-this-iter

- **(A) φ-shape**: iter-135 placeholder bodies in `Cotangent/GrpObj.lean`
  lines 476, 508, 566 should be refactored to use
  `(Scheme.Hom.toRingCatSheafHom <morphism>).hom` for each `φ_*`, per
  the intended types in (B). The iter-134 placeholders' use of
  `Iso.refl`-as-conclusion does not yet ship the divergent φ-shape
  (no `schemeHomRingCompatibility` call appears in the placeholder
  bodies), so this is a forward-looking "do this in iter-135" not a
  "refactor shipped wrong code". Still **must-fix-this-iter** because
  the iter-135 refactor MUST NOT propagate `schemeHomRingCompatibility`
  to the new `PresheafOfModules.pullback` use sites.

- **(C) Home file**: do not introduce any new project-side `def`s for
  `φ_str / φ_η / φ_pr_two / φ_section`. Inline `(Scheme.Hom.toRingCatSheafHom
  <morphism>).hom` or use local `let`-bindings. **must-fix-this-iter**
  to prevent iter-135 from creating gratuitous wrappers that future
  iters would need to refactor away.

## Major

(None — see Must-fix.)

## Informational

- **(B) Intended types**: the three Lean signatures in (B1)–(B3) above
  are ready-to-drop for the iter-135 refactor. The `Nonempty` wrapper
  is inherited from the iter-134 placeholder convention; iter-135 may
  choose to drop it (and refactor to a `def`-level iso) since the
  closure is by construction a concrete iso, not an existential.

- **(D) Elaboration**: clean — the iter-135 refactor of the 3
  placeholder theorems to intended-type + `sorry` is unblocked at the
  type-elaboration level.

- **`schemeHomRingCompatibility` retention**: keep as-is for use by
  `relativeDifferentialsPresheaf` (different consumer convention).
  Consider adding a docstring sentence clarifying it is **NOT** the
  φ for `PresheafOfModules.pullback`, to prevent future iters from
  attempting the wrong wiring.

## Persistent file

- `analogies/phi-compatibility-morphisms.md` — full design rationale
  with Mathlib citations, the 4-decision breakdown, and the iter-135
  refactor recommendation.

## Overall verdict

**PROCEED-WITH-INTENDED-TYPES-AS-WRITTEN** (with one substitution:
replace every prose `φ_*` reference with the literal
`(Scheme.Hom.toRingCatSheafHom <morphism>).hom`, not a new project
`def`).
