# Mathlib Analogist: fbcb-sig
**Mode:** api-alignment | **Iter:** 081

## TL;DR
Signature is statable. **VERIFIED TO ELABORATE** via `lean_run_code` (full def + `sorry` body,
warning `declaration uses 'sorry'` only). Two design answers, both ALIGN with existing idiom.

## Verdicts
- **`B`-action on RHS**: ALIGN. `groundRing X' ≠ B` (no canonical equality/iso to state with).
  Use `ModuleCat.restrictScalars` along the ring hom `B → groundRing X'` — same idiom the
  project already uses to build `gammaModA` (restrictScalars along `rhoU`). Do NOT chase
  `groundRing X' = B` (that's the theorem at `F = O_X`, a consequence not a hypothesis).
- **Parametrization**: ALIGN. Take `B` directly as flat `[Algebra (groundRing X) B]` (mirrors
  `baseChangeGammaEquiv`, whose LHS = capstone LHS verbatim); build `X'`,`g'` in-statement.
  Abstract `IsPullback` route costs 3 extra equation hyps (`S=Spec A`, `f=X.toSpecΓ`, `S'=Spec B`)
  because `IsPullback`'s tensor base is `groundRing S`, not `groundRing X`.

## Canonical `B → groundRing X'` map (the crux)
`f' : X' ⟶ Spec B` is `pullback.snd`. Ring hom:
`f'.appTop.hom.comp (Scheme.ΓSpecIso (CommRingCat.of B)).inv.hom : B →+* groundRing X'`.

## Recommended header (elaborates as-is; drop in next iter)
```lean
open CategoryTheory Limits AlgebraicGeometry
open scoped TensorProduct
namespace AlgebraicGeometry.Modules

/-- Canonical algebra map `B → Γ(X', O)` for the base-change pullback `X' = X ×_{Spec A} Spec B`,
from the projection `X' ⟶ Spec B`. -/
noncomputable def pullbackGroundRingAlg {X : Scheme.{u}} (B : Type u) [CommRing B]
    [Algebra (groundRing X) B] :
    B →+* groundRing (pullback X.toSpecΓ
      (Spec.map (CommRingCat.ofHom (algebraMap (groundRing X) B)))) :=
  ((pullback.snd X.toSpecΓ
      (Spec.map (CommRingCat.ofHom (algebraMap (groundRing X) B)))).appTop).hom.comp
    (Scheme.ΓSpecIso (CommRingCat.of B)).inv.hom

/-- thm:fbcb_global_direct — `Γ(X,F) ⊗_A B ≃ₗ[B] Γ(X', F')`, `A = groundRing X`,
`X' = X ×_{Spec A} Spec B`, `F' = (g')^* F`. -/
noncomputable def baseChangeGammaPullbackEquiv {X : Scheme.{u}} (F : X.Modules)
    (B : Type u) [CommRing B] [Algebra (groundRing X) B] [Module.Flat (groundRing X) B] :
    let sp := Spec.map (CommRingCat.ofHom (algebraMap (groundRing X) B))
    let g' : pullback X.toSpecΓ sp ⟶ X := pullback.fst X.toSpecΓ sp
    TensorProduct (groundRing X) B (gammaModA F (⊤ : X.Opens)) ≃ₗ[B]
      (ModuleCat.restrictScalars (pullbackGroundRingAlg B)).obj
        (gammaModA ((Scheme.Modules.pullback g').obj F) ⊤) :=
  sorry

end AlgebraicGeometry.Modules
```
Notes for scaffolder:
- `g' = pullback.fst X.toSpecΓ sp : X' ⟶ X`; `f' = pullback.snd … : X' ⟶ Spec B`.
- LHS is LITERALLY `baseChangeGammaEquiv F U hU B`'s domain → proof starts there, then transports
  the RHS eqLocus to `gammaModA F' ⊤` via `gammaTopEquivEqLocus` on `F'`/the base-changed cover.
- RHS `B`-module is `restrictScalars` (RingHom form) — needs NO `Algebra B (groundRing X')` instance.
- Alt spelling if a `let` in the return type bothers a consumer: inline `pullback.fst X.toSpecΓ sp`
  for `g'` (both elaborate; tested).

## Mathlib decls cited (all verified present)
- `AlgebraicGeometry.Scheme.toSpecΓ` — `X ⟶ Spec Γ(X)` (`Mathlib/…/GammaSpecAdjunction.lean`).
- `AlgebraicGeometry.Scheme.ΓSpecIso (R : CommRingCat)` — `Γ(Spec R) ≅ R`.
- `AlgebraicGeometry.Scheme.Hom.appTop` — `f.appTop : Γ(Y) ⟶ Γ(X)`.
- `AlgebraicGeometry.Spec.map` ; `CommRingCat.ofHom` ; `algebraMap`.
- `CategoryTheory.Limits.pullback` / `pullback.fst` / `pullback.snd`.
- `ModuleCat.restrictScalars` (RingHom form) ; `Scheme.Modules.pullback` (`F' = (g')^* F`).
- (optional) `RingHom.toAlgebra (pullbackGroundRingAlg B)` if an `Algebra` instance is wanted.

## Persistent file
- `analogies/fbcb-pullback-equiv-sig.md` written.

Overall verdict: PROCEED with the header above — statable, idiom-aligned, elaboration-verified.
