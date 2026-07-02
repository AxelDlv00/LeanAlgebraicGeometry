# Analogy: `ModuleCat.Hom.hom` vs `ConcreteCategory.hom` coercion bridge for threading `εInv_apply`

## Mode
api-alignment

## Slug
dualcoerce309

## Iteration
309

## Question
The `sliceDualTransport` round-trip goals (`left_inv`/`right_inv`, `DualInverse.lean` L726/L749)
reduce to element identities whose `inv ε` applications are spelled `ModuleCat.Hom.hom (inv ε) s`,
while the helper `Scheme.Modules.εInv_apply` (and Mathlib's `ModuleCat.restrictScalars_η`) are
stated with `ConcreteCategory.hom (inv ε) s`. `rw`/`simp only` report no-progress. What is the
Mathlib-idiomatic bridge, and is a separate unit-object identification lemma needed?

## Project artifact(s)
- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`:186 — `εInv_apply` (`ConcreteCategory.hom` form).
- `…/DualInverse.lean`:726, 749 — `left_inv`/`right_inv` element residual sorries (goal carries `ModuleCat.Hom.hom`).

## Decisions identified

### Decision: how to fire a `ConcreteCategory.hom`-stated lemma at a `ModuleCat.Hom.hom`-spelled goal

- **Root cause (verified).** For `ModuleCat R` the `ConcreteCategory` instance defines its `hom`
  field to *be* `ModuleCat.Hom.hom`, so `ConcreteCategory.hom f` and `ModuleCat.Hom.hom f` are
  **reducibly defeq but distinct head constants**. `rw`/`simp only` match the head constant
  syntactically → "Tactic rewrite failed: did not find pattern `ConcreteCategory.hom …`" /
  "simp made no progress" (both reproduced at L726). A `rfl`-bridge rewrite
  `rw [show ModuleCat.Hom.hom h = ConcreteCategory.hom h from rfl]` ALSO fails to find its own
  pattern (reproduced) — there is no usable syntactic rewrite between the two spellings.
- **Mathlib idiom = `erw`.** `erw` matches up to reducible/instance transparency, so it bridges the
  defeq gap. VERIFIED at L726: `erw [Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply,
  Scheme.Modules.εInv_apply]` fires on **all three** `inv ε` in one shot — outer (`X.presheaf.map
  (eqToHom)`), and the two nested inside `(restrictScalars …).map (… ≫ inv ε)` (erw even punches
  through the `.map`/`ModuleCat.ofHom` collapse-legs). Result: the three `inv ε` become
  `(RingEquiv.ofBijective g _).symm`, leaving the math residual (two `appIso` swaps cancel +
  `φ.naturality` reindex). Each `erw` spins off one `Function.Bijective ⇑g` side-goal; all close
  with `exact CategoryTheory.ConcreteCategory.bijective_of_isIso _` (proof-irrelevant, so the
  `?hg` metavars in the RHS `RingEquiv.ofBijective g ?hg` resolve to it).
- **Gap**: divergent-equivalent (tactic idiom, not API shape). Mathlib itself states
  `restrictScalars_η` in `ConcreteCategory.hom` form while its `.hom`-normal-form simp lemmas
  (`ModuleCat.hom_comp`, `LinearMap.comp_apply`) produce `ModuleCat.Hom.hom`; the project's
  `εInv_apply` faithfully mirrors `restrictScalars_η`, so the spelling mismatch is intrinsic to
  Mathlib's own API, not a project defect.
- **Optional cleanliness twin** (only if `erw` fragility is later a concern): add a `.hom`-spelled
  twin `εInv_hom_apply … (s) : (inv (ε (restrictScalars g))).hom s = (RingEquiv.ofBijective g hg).symm s
  := εInv_apply g hg s` (proof is defeq). NOTE: plain `rw` on a twin still defers `hg`/the `IsIso`
  instance as metavars exactly as `erw` does, so this buys robustness, not a `rw` upgrade — `erw`
  remains the simplest working path.
- **Verdict**: PROCEED (use the `erw` recipe; twin is DIVERGE_INTENTIONALLY-optional).

### Decision: unit-carrier direction matching (`𝟙_{𝒪_X(fP)}` vs `restrictScalars (β.app P) 𝟙_X`)

- **No separate lemma needed (verified).** `εInv_apply` is generic over `g : R →+* S`; the
  lax-monoidal unit `ε (restrictScalars g) : 𝟙_(ModuleCat R) ⟶ (restrictScalars g).obj 𝟙_(ModuleCat S)`
  has a type that already bridges the two unit spellings, so `erw` unifies the unit objects of all
  three `inv ε` by defeq automatically (all three fired). The directive's feared mismatch never
  surfaces at the element level.
- **Verdict**: PROCEED.

## Recommendation
Thread the helper with `erw`, not `rw`/`simp only`. Concretely at both L726 and L749:
```
erw [Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply, Scheme.Modules.εInv_apply]
all_goals try exact CategoryTheory.ConcreteCategory.bijective_of_isIso _
```
This collapses every `inv ε` to `(RingEquiv.ofBijective g _).symm` and discharges the three
`Function.Bijective` side-goals, leaving exactly the worked-out math residual (two `appIso`
hom/inv swaps cancel; then `φ.naturality` across the slice morphism, with the `eqToHom`/down-set
relabel absorbed). The cause is the reducible-defeq gap between Mathlib's `ConcreteCategory.hom`
(lemma LHS) and the `.hom`-normal-form `ModuleCat.Hom.hom` (goal head); `erw` is the canonical
bridge. Reserve a `.hom`-spelled twin only if `erw` later proves brittle.
