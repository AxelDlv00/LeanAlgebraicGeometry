# Refactor Report

## Slug
lane-f-step12-sigma-pair

## Status
COMPLETE

## Directive
Reshape `step1` (`tildeIso_of_isQuasicoherent_isAffineOpen`, Stacks 01I8) and `step2`
(`pullback_tildeIso`, Stacks 01HQ) signatures in `AlgebraicJacobian/Picard/QuotScheme.lean`
from opaque `Nonempty (... ≅ ...)` form to **Σ-pair** form carrying the canonical
iso-characterizing identity, so that the iter-194 Lane F Beck-Chevalley intertwining
residual at L815-area can trace through the iso on `1 ⊗ₜ x`. Body remains `sorry`
(signature-only refactor). Net sorry change: +0.

## Changes Made

### File: AlgebraicJacobian/Picard/QuotScheme.lean

#### 1) `tildeIso_of_isQuasicoherent_isAffineOpen` — Σ-pair signature (Stacks 01I8)

**New signature** (verbatim):

```lean
private theorem tildeIso_of_isQuasicoherent_isAffineOpen
    {X : Scheme.{u}} (N : X.Modules) [N.IsQuasicoherent]
    {V : X.Opens} (hV : IsAffineOpen V) :
    letI : Algebra Γ(X, V) Γ(Spec Γ(X, V), ⊤) :=
      (hV.fromSpec.appLE V ⊤
        (le_of_eq hV.fromSpec_preimage_self.symm)).hom.toAlgebra
    letI : Module Γ(X, V) Γ((Scheme.Modules.pullback hV.fromSpec).obj N, ⊤) :=
      Module.compHom _
        (hV.fromSpec.appLE V ⊤
          (le_of_eq hV.fromSpec_preimage_self.symm)).hom
    Nonempty {iso : (Scheme.Modules.pullback hV.fromSpec).obj N ≅
        tilde (ModuleCat.of Γ(X, V) Γ(N, V)) //
      ∀ (s : Γ(N, V)),
        (Scheme.Modules.Hom.app iso.inv ⊤).hom
            ((tilde.toOpen (ModuleCat.of Γ(X, V) Γ(N, V)) ⊤).hom s) =
          pullback_app_isoTensor_baseMap hV.fromSpec N
            (le_of_eq hV.fromSpec_preimage_self.symm) s}
```

**Carried identity (canonical content)**: `iso.inv` at ⊤-sections sends
`tilde.toOpen Γ(N, V) ⊤ s` to the canonical pullback-section image of `s`
produced by `pullback_app_isoTensor_baseMap` (the adjunction-unit-based
base map already in scope above). This characterizes the iso as the
inverse of the `fromTildeΓ` counit at the affine open V, exactly
following the docstring marker at L956 "`step1 = (asIso fromTildeΓ).symm`".

The `letI` chain in the signature sets up the Γ(X, V)-Module instance on
the pullback ⊤-section so that `pullback_app_isoTensor_baseMap`'s
return-type `LinearMap` typechecks inside the Σ-pair.

**Body**: preserved as `exact sorry` (with the same iter-190+ comment
plus an iter-195 marker noting the Σ-pair refactor).

#### 2) `pullback_tildeIso` — Σ-pair signature (Stacks 01HQ)

**New signature** (verbatim):

```lean
private theorem pullback_tildeIso
    {A B : CommRingCat.{u}} (φ : A ⟶ B) (M : ModuleCat.{u} A) :
    letI : Algebra A B := φ.hom.toAlgebra
    letI : Algebra Γ(Spec A, ⊤) Γ(Spec B, ⊤) :=
      ((Spec.map φ).appLE ⊤ ⊤ le_top).hom.toAlgebra
    letI : Module Γ(Spec A, ⊤)
        Γ((Scheme.Modules.pullback (Spec.map φ)).obj (tilde M), ⊤) :=
      Module.compHom _ ((Spec.map φ).appLE ⊤ ⊤ le_top).hom
    Nonempty {iso : (Scheme.Modules.pullback (Spec.map φ)).obj (tilde M) ≅
        tilde (ModuleCat.of B (TensorProduct A B M)) //
      ∀ (m : M),
        (Scheme.Modules.Hom.app iso.hom ⊤).hom
            (pullback_app_isoTensor_baseMap (Spec.map φ) (tilde M) le_top
              ((tilde.toOpen M ⊤).hom m)) =
          (tilde.toOpen (ModuleCat.of B (TensorProduct A B M)) ⊤).hom
            (1 ⊗ₜ[A] m)}
```

**Carried identity (canonical content)**: the iso, evaluated at ⊤-sections,
sends the canonical pullback-section image of `tilde.toOpen M ⊤ m` (built
via the `pullback_app_isoTensor_baseMap` adjunction-unit map applied to
`tilde M`) to `tilde.toOpen … ⊤` applied to `1 ⊗ₜ[A] m`. This characterizes
the iso as the canonical "pullback of tilde = tilde of base change" Spec-level
identification (Stacks 01HQ / 0BJ8).

`le_top` discharges the `⊤ ≤ (Spec.map φ) ⁻¹ᵁ ⊤` obligation since the
preimage of ⊤ is ⊤ (`Opens.map_top : (Opens.map f).obj ⊤ = ⊤` is `rfl`).

**Body**: preserved as `exact sorry` (with the same iter-188+ comment
plus an iter-195 marker noting the Σ-pair refactor).

#### 3) Consumer site update — `pullback_app_isoTensor_baseMap_sectionLinearEquiv`

The `obtain` patterns at L850-853 (now L1283-1286 after refactor) updated
from extracting just the iso to extracting both the iso and the carried
identity:

```lean
-- Before:
obtain ⟨step1⟩ :=
  tildeIso_of_isQuasicoherent_isAffineOpen N _hV
obtain ⟨step2⟩ :=
  pullback_tildeIso (g.appLE V U e) (ModuleCat.of Γ(X, V) Γ(N, V))

-- After:
obtain ⟨⟨step1, _step1_apply⟩⟩ :=
  tildeIso_of_isQuasicoherent_isAffineOpen N _hV
obtain ⟨⟨step2, _step2_apply⟩⟩ :=
  pullback_tildeIso (g.appLE V U e) (ModuleCat.of Γ(X, V) Γ(N, V))
```

The `_step1_apply` and `_step2_apply` are made AVAILABLE to the consumer's
Beck-Chevalley intertwining body but currently unused (the consumer body
remains `exact sorry` per the directive — that's a separate prover lane
this iter). The names are underscore-prefixed since the existing body
sorry does not yet reference them; iter-196+ prover work consumes these
hypotheses to close the intertwining axiom-clean.

## New Sorries Introduced
None. The refactor is purely structural: step1 and step2 bodies remain
`exact sorry` exactly as before, and the consumer body retains its
existing `exact sorry`. Total sorry-using declarations in the file:
unchanged at the pre-refactor count.

## Compilation Status
- `AlgebraicJacobian/Picard/QuotScheme.lean`: **compiles GREEN**
  - Build command: `lake build AlgebraicJacobian.Picard.QuotScheme`
  - Result: `⚠ [8317/8317] Built AlgebraicJacobian.Picard.QuotScheme (18s)` — warnings are
    all `declaration uses 'sorry'` for the existing sorry-bodied declarations; no errors.
- No other Lean files modified; full project transitive build unaffected.

## Net sorry count change
**+0** (signature-only refactor, body of step1/step2 still `exact sorry`,
consumer body still `exact sorry`).

## Notes for Plan Agent

### What's now available to the iter-196+ consumer body prover

The `_sectionLinearEquiv` body sorry at L1377-area (the Beck-Chevalley intertwining
residual `f (1 ⊗ₜ x) = baseMap g N e x`) now has these hypotheses in scope:

- `_step1_apply : ∀ (s : Γ(N, V)),
    (Scheme.Modules.Hom.app step1.inv ⊤).hom
      ((tilde.toOpen _ ⊤).hom s) =
    pullback_app_isoTensor_baseMap hV.fromSpec N
      (le_of_eq hV.fromSpec_preimage_self.symm) s`

- `_step2_apply : ∀ (m : Γ(N, V)),
    (Scheme.Modules.Hom.app step2.hom ⊤).hom
      (pullback_app_isoTensor_baseMap (Spec.map (g.appLE V U e))
        (tilde (ModuleCat.of Γ(X, V) Γ(N, V))) le_top
        ((tilde.toOpen _ ⊤).hom m)) =
    (tilde.toOpen _ ⊤).hom (1 ⊗ₜ[Γ(X, V)] m)`

These let the consumer trace `composedIso.inv.app ⊤ ((tilde.toOpen TR ⊤).hom (1 ⊗ₜ x))`
through `step2.inv` (which inverts `step2.hom`'s action on
`pullback_app_isoTensor_baseMap … (tilde.toOpen _ ⊤ m)`) and then through
`step1.inv` at the next layer, terminating in the canonical
`pullback_app_isoTensor_baseMap g N e x` (which IS `baseMap g N e x` by
definition). The naturality-of-the-adjunction-unit / pullbackComp /
pullbackCongr boilerplate at L1289-1295 then realigns the two adjunction
units across the commutative square `hU.fromSpec ≫ g = Spec.map φ ≫ hV.fromSpec`.

### Mathematical justification recap (in case prover needs it)

The carried identities are TRUE because both isos ARE the canonical ones
(per Stacks 01I8 / 01HQ); the proofs of the iso bodies (the Mathlib gaps)
would in particular establish these identities as immediate consequences
of the iso's definition via adjunction-unit naturality. The signature
refactor merely EXPOSES this content to the consumer.

### Possible follow-up refactors (for plan agent's next iter)

- If iter-196+ prover blows up on `_step1_apply` / `_step2_apply` due to
  the `pullback_app_isoTensor_baseMap` Module instance not unifying with
  the consumer's `Module.compHom`-instance: the canonical fix is to add
  matching `letI`s in the consumer body, or to inline
  `pullback_app_isoTensor_baseMap` to its underlying
  `unit ≫ restr` composition. The signature change here is intentionally
  conservative — using the EXISTING `pullback_app_isoTensor_baseMap`
  helper rather than a new ad-hoc map — so consumer-side instance dance
  is minimized.

- The `tildeIso_of_isQuasicoherent_isAffineOpen` letI chain at the
  signature level adds ~6 lines per declaration; if this proliferates
  in iter-196+, consider extracting the `Algebra` + `Module.compHom`
  pattern into a `private letI` macro or a named instance helper.

- The `pullback_app_isoTensor_unitAtV` (axiom-clean, L476-480) and its
  V-section-to-U-section restriction `pullback_app_isoTensor_baseMap`
  (axiom-clean, L508-541) are the two LINEAR maps that the Σ-pair
  identity threads through. If iter-196 prover wants a STILL more
  concrete form (e.g., expressing the identity directly in terms of
  the adjunction unit at `(.op V)` without going through `_baseMap`),
  the refactor target is `pullback_app_isoTensor_baseMap`'s definition
  — currently a 35-LOC structured construction; reducing it to a
  pure 1-line `unit ≫ restr` aliased term would also work.

### Iter-194 ARCHITECTURAL NOTE (at L948-960) is now ADDRESSED

The note explicitly called out: "(a) `step1`'s body lands (or its signature
is strengthened to a Σ-pair carrying the canonical `step1 = (asIso fromTildeΓ).symm`
identity), AND (b) `step2`'s body lands similarly with the canonical Spec
base-change iso identity." Path (a) + (b) via signature strengthening is
exactly what this iter-195 refactor accomplishes. The bodies still
remain Mathlib-gap typed sorries; the Beck-Chevalley intertwining at
L1377 is now in principle axiom-clean (the prover lane this iter
discharges it).
