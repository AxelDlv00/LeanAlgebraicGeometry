# Directive — refactor `lane-f-step12-sigma-pair`

## Goal

Reshape `step1` (`tildeIso_of_isQuasicoherent_isAffineOpen`, Stacks
01I8) and `step2` (`pullback_tildeIso`, Stacks 01HQ) signatures in
`AlgebraicJacobian/Picard/QuotScheme.lean` from the current opaque
`Nonempty (... ≅ ...)` form to **Σ-pair** form carrying the
canonical iso-characterizing identity.

This unblocks the iter-194 Lane F Beck-Chevalley intertwining
residual at L815-area (`pullback_app_isoTensor_baseMap_sectionLinearEquiv`
body) — the current opaque iso bodies prevent consumers from
reasoning about the iso's action on `1 ⊗ₜ x` (the substantive content
of Beck-Chevalley).

## Files to edit

ONLY `AlgebraicJacobian/Picard/QuotScheme.lean`.

## Specific edits

### Reshape `tildeIso_of_isQuasicoherent_isAffineOpen` (line 616-624)

CURRENT:

```lean
private theorem tildeIso_of_isQuasicoherent_isAffineOpen
    {X : Scheme.{u}} (N : X.Modules) [N.IsQuasicoherent]
    {V : X.Opens} (hV : IsAffineOpen V) :
    Nonempty ((Scheme.Modules.pullback hV.fromSpec).obj N ≅
      tilde (ModuleCat.of Γ(X, V) Γ(N, V))) := by
  exact sorry
```

NEW (Σ-pair form carrying the canonical identity — the iso is the
inverse of the `fromTildeΓ` canonical map):

```lean
private theorem tildeIso_of_isQuasicoherent_isAffineOpen
    {X : Scheme.{u}} (N : X.Modules) [N.IsQuasicoherent]
    {V : X.Opens} (hV : IsAffineOpen V) :
    Nonempty {iso : (Scheme.Modules.pullback hV.fromSpec).obj N ≅
        tilde (ModuleCat.of Γ(X, V) Γ(N, V)) //
      ∀ (s : Γ(N, V)),
        (iso.inv ≫ (Scheme.Modules.pullback hV.fromSpec).map (𝟙 _)).app _ _ =
          fromTildeΓ_inv_apply N hV s} := by
  exact sorry
```

Actually — read the file FIRST to understand what canonical identity
the iso must carry. The substantive content is: the iso's inverse
acts as the `fromTildeΓ` morphism on sections (because the iso IS
`(asIso fromTildeΓ).symm` morally, per the docstring at L956
"`step1 = (asIso fromTildeΓ).symm`"). Adapt the exact form of the
Σ-pair identity to what is actually needed at the consumer call
site (the Beck-Chevalley intertwining at L948-960 names the missing
hooks).

**Preserve the body as `sorry`** — this refactor is signature-only,
NOT a proof landing. The point is to make the iso's identity
expose-able to consumers; the body remains a Mathlib gap.

### Reshape `pullback_tildeIso` (line 562-571)

CURRENT:

```lean
private theorem pullback_tildeIso
    {A B : CommRingCat.{u}} (φ : A ⟶ B) (M : ModuleCat.{u} A) :
    letI : Algebra A B := φ.hom.toAlgebra
    Nonempty ((Scheme.Modules.pullback (Spec.map φ)).obj (tilde M) ≅
      tilde (ModuleCat.of B (TensorProduct A B M))) := by
  letI : Algebra A B := φ.hom.toAlgebra
  exact sorry
```

NEW (Σ-pair form carrying the section-level action — the iso's
inverse maps `tilde`-sections to pullback-sections via the
`TensorProduct` `1 ⊗ₜ` formula):

```lean
private theorem pullback_tildeIso
    {A B : CommRingCat.{u}} (φ : A ⟶ B) (M : ModuleCat.{u} A) :
    letI : Algebra A B := φ.hom.toAlgebra
    Nonempty {iso : (Scheme.Modules.pullback (Spec.map φ)).obj (tilde M) ≅
        tilde (ModuleCat.of B (TensorProduct A B M)) //
      ∀ (m : M), iso.hom.app_section <some_canonical_test_section> =
        <TensorProduct.mk 1 m>} := by
  letI : Algebra A B := φ.hom.toAlgebra
  exact sorry
```

Again — the EXACT form of the Σ-pair identity matters; read the
consumer at L944-960 (the docstring block documenting what
identities the consumer needs) and tailor the carried identity to
match.

**Preserve the body as `sorry`** — signature-only refactor.

### Update consumers

The consumers of `step1` + `step2` at L850-877 (and any others)
currently `obtain ⟨step1⟩ := ...` from the `Nonempty` form. Update
to `obtain ⟨step1, step1_apply⟩ := ...` extracting both the iso
and the carried identity.

The consumers' downstream Beck-Chevalley body (L948-960 docstring
material) currently sits behind a `sorry` block; LEAVE THAT BODY
UNCHANGED (it's a separate prover lane this iter). Just make the
identity AVAILABLE to consumers via the Σ-pair.

## What you may NOT do

- DO NOT close the bodies of `step1` / `step2`. They remain
  `sorry` (signature-only refactor).
- DO NOT modify any other file.
- DO NOT remove or rename declarations.
- DO NOT change `private` access modifiers.
- DO NOT touch `archon-protected.yaml`.

## Success criteria

- `lake build AlgebraicJacobian.Picard.QuotScheme` succeeds.
- `step1` + `step2` carry Σ-pair signatures with the
  iso-characterizing identity.
- Consumer obtain-patterns updated.
- Net sorry count change: +0 (signature-only).
- Build GREEN.

## Verification

After your edit:

```
lake build AlgebraicJacobian.Picard.QuotScheme
```

If this fails, repair the consumer site (the only legitimate
consumer is `pullback_app_isoTensor_baseMap_sectionLinearEquiv`
at L815-area). Do not introduce new sorries.

## Output

Write a brief task_results report:
- New signatures verbatim.
- Consumer changes summary.
- Build status (GREEN/RED).
- Net sorry-count change (must be 0).
