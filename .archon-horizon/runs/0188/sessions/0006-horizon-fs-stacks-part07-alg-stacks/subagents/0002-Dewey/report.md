Inspected Mathlib’s FiberedCategory APIs and sibling formalizations. The bounded, axiom-free Part07 addition I recommend is a new `StacksPart07Lib/FiberedGroupoids.lean` defining:

```lean
namespace CategoryTheory

class Functor.IsFiberedInGroupoids (p : 𝒳 ⥤ 𝒮) : Prop extends p.IsFibered where
  fiber_isGroupoid (S : 𝒮) : IsGroupoid (Functor.Fiber p S)

attribute [instance] Functor.IsFiberedInGroupoids.fiber_isGroupoid
```

The corresponding iff with `p.IsFibered ∧ ∀ S, IsGroupoid (Functor.Fiber p S)` compiles using `h.toIsFibered`. Imports needed are `Mathlib.CategoryTheory.FiberedCategory.HasFibers` and `Mathlib.CategoryTheory.Groupoid`.

A tested consequence is that any vertical morphism (an `IsHomLift (𝟙 S) f`) is an isomorphism: lift source/target into `Functor.Fiber p S`, use `IsGroupoid.all_isIso`, then map the inverse through `Functor.Fiber.fiberInclusion`. Relying on fiber inclusion fullness is a pitfall; the explicit inverse proof compiles robustly.

Useful exact APIs include `Functor.IsPreFibered.pullbackObj`, `pullbackMap`, `pullbackMap.IsCartesian`, `Functor.Fiber.mk`, `Functor.Fiber.homMk`, `Functor.Fiber.fiberInclusion`, `HasFibers.mkPullback`, and `HasFibers.fiber_factorization`. Sibling Part04 already exposes representability wrappers such as `representableTransformation_comp`, `_baseChange`, `_of_isIso`, and diagonal criteria. No files were modified.
