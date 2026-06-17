# Mathlib-analogist directive — iter-061

## Mode: api-alignment

## Question
We must build `AlgebraicGeometry.pushforward_commutes_restriction` (no Lean decl yet). Confirm
whether Mathlib already provides this commutation (under any name / as a colimit-exchange or
base-change instance), and whether the project's intended route is the canonical idiom or a
parallel API we should replace.

## The declaration we intend to build
For `φ : X ≅ Y` an isomorphism of schemes, `Φ = Scheme.Modules.pushforwardEquivOfIso φ :
X.Modules ≌ Y.Modules`, `H : X.Modules`, an open `U_i : Opens X` and `V_i = φ.inv ⁻¹ᵁ U_i : Opens Y`,
and `e_i` the homeomorphism-induced restricted-module-category equivalence, we need:
```
e_i.functor.obj (H.over U_i)  ≅  (Φ.functor.obj H).over V_i
```
where `Scheme.Modules.over W` is the restriction of a sheaf of modules to the slice site `Over W`
(equivalently `SheafOfModules.pushforward (𝟙)` over `Over W`). Intuitively this is
`(f_* H)|_{V} ≅ (f|_{f⁻¹V})_* (H|_{f⁻¹V})` — direct image commutes with open restriction — for the
special case where `f = φ` is an isomorphism.

## The project's intended route
Build it from `SheafOfModules.pushforwardPushforwardEquivalence` (Mathlib — the iso for a commuting
square of continuous site functors) applied to the square
`Over U_i → Opens X`, `Over V_i → Opens Y`, `φ`, together with `Scheme.Modules.pushforward_obj_obj`
(rfl on sections). The prover reported "no Mathlib lemma provides this pushforward/`over`
commutation" after checking `PushforwardContinuous.lean`, `Quasicoherent.lean`.

## What I need from you
1. **Does Mathlib already carry this?** Search for direct-image / pushforward commuting with
   restriction-to-an-open (slice-site pushforward), base-change for `SheafOfModules.pushforward`
   along a commuting square of continuous functors, or a restriction-vs-pushforward exchange. Names
   like `pushforwardPushforwardEquivalence`, `pushforwardComp`, `restrictScalars`/`over` interactions,
   `SheafOfModules.restrict`, Grothendieck-topology functor-pushforward composition.
2. **Is `pushforwardPushforwardEquivalence` the canonical tool here**, or is there a slicker idiom
   (e.g. a single `pushforwardComp` / associativity instance) that avoids the ~100–150 LOC site-square
   assembly the prover estimated?
3. **Is `Scheme.Modules.over W` the right abstraction**, or does Mathlib model "restrict a sheaf of
   modules to an open" differently (so our `over` route is a parallel API)?

Output the canonical Mathlib path (with citations) and a concrete recommendation: PROCEED with the
`pushforwardPushforwardEquivalence` route, or ALIGN WITH MATHLIB <named idiom>. Persist the rationale
under `analogies/pushforward-commutes-restriction.md`.
