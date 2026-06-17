# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
fbc-qc

## Design question

The file `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` is trying to prove
`pushforward_spec_tilde_iso` / `affineBaseChange_pushforward_iso` (Stacks 02KH,
the `i = 0` flat base change of `Rⁱf_*`). The current route reduces to a residual
`hloc(a)`: showing that, for an **affine** morphism `Spec φ : Spec R' ⟶ Spec R`
(`φ : R ⟶ R'` a ring hom) and a module `M` over `R'`, the pushforward-side
restriction map of the pushed-forward tilde sheaf `(Spec φ)_* (M^~)` is an
`IsLocalizedModule (powers a)` localization. This route keeps hitting (4th iter)
a **carrier wall**: viewing the `R'`-module sections as `R`-modules via
`Module.compHom _ φ.hom` is not picked up by `LinearMap.restrictScalars R`
(instance-not-found / defeq-not-syntactic mismatch against the
`modulesSpecToSheaf`-supplied `R`-action and the `restrictScalars` functor's
module instance).

**The real question:** does Mathlib already have a direct, idiomatic statement
that **the pushforward of a quasi-coherent sheaf along an AFFINE morphism is
quasi-coherent** (equivalently: `(Spec φ)_* (M^~) ≅ (the tilde of M viewed as an
R-module via φ)^~`, the "affine pushforward = tilde of restriction-of-scalars
module" dictionary), which would let us conclude the localization /
quasi-coherence of the pushforward WITHOUT the manual `hloc` per-`D(a)`
`IsLocalizedModule` transport that keeps hitting the carrier wall?

Equivalently: is there a Mathlib idiom for the whole goal
`affineBaseChange_pushforward_iso` (base change of `f_*` for `i=0` along a flat
base change of affines) that avoids reconstructing the localization by hand?

## Project artifact(s) under question
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:~395` — `pushforward_spec_tilde_iso_of_isLocalizedModule` (the conditional, axiom-clean).
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:~470` — `affineBaseChange_pushforward_iso` (open sorry).
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:~535` — `pushforward_spec_tilde_iso` / `hloc` (the carrier-wall residual).
- New axiom-clean bricks just built: `gammaPushforwardIsoAt` (open-indexed `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))`), `tildeRestriction_isLocalizedModule`.

## Why now
This lane is STUCK (4 iters, same carrier wall). Before spending a 5th iter on
the manual `IsLocalizedModule` transport, I need to know whether Mathlib has a
higher-level result (affine pushforward preserves quasi-coherence / the
`(Spec φ)_* (M^~) ≅ (restrictScalars φ M)^~` dictionary) that makes the manual
`hloc` discharge unnecessary — i.e. a route pivot, not another carrier-wall
attempt.

## Hints (optional)
Search for, with real `Mathlib.X.Y:line` citations verified via LSP:
- `AlgebraicGeometry.Scheme.Hom.IsAffine` / `IsAffineHom` + pushforward / `f_*`
  preserving `IsQuasicoherent` / quasi-coherence.
- `ModuleCat.tildeFunctor` / `Spec` / `Modules.tilde` and any
  `(Spec φ)_* ∘ tilde ≅ tilde ∘ restrictScalars φ` style dictionary.
- `QuasicoherentSheaf`, `Scheme.Modules`, `Modules.pushforward`, `Spec.map`.
- `IsLocalizedModule.powers_restrictScalars`, `algebraMapSubmonoid`,
  `Module.compHom` — and whether Mathlib's idiom for restrict-scalars +
  `IsLocalizedModule` transport uses `IsScalarTower` / `Algebra` instances
  rather than a `Module.compHom` `letI` (the thing that keeps failing).

## Severity expectation
high-stakes

(This decides whether the FlatBaseChange engine lane pivots its whole
decomposition or keeps grinding the carrier wall. A wrong "no idiom exists"
answer costs many iters.)
