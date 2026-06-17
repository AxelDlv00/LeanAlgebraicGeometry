# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
rigidity-affineconst

## Design question
Does Mathlib have an idiom for the **relative** statement "a proper morphism with
geometrically-connected fibres into an affine target is constant along fibres", expressed as a
**scheme-morphism equality**, that we can use to close the agreement equation of the Rigidity
Lemma? Concretely we must prove, on the open `U = X × V ⊆ (X ⊗ Y).left`:

```
U.ι ≫ f.left = U.ι ≫ (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left
```

i.e. on `U` the map `f` agrees with "collapse the `X`-axis to `x₀` then apply `f`". The
mathematical content: for each `y ∈ V`, the proper connected slice `X × {y}` maps under `f` into
the affine `U₀ ∋ z₀`, hence to a SINGLE point `f(x₀, y)`; so `f` factors through the second
projection on `U`. This is Stein-factorization / "proper-into-affine is constant on fibres"
content, but needed as a morphism equality, not just a set-theoretic image statement.

## Project artifact(s) under question
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:181` — the agreement-equation sorry (bridge 2)
  inside `rigidity_eqOn_dense_open`.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:111-181` — enclosing lemma; `U₀` is an affine
  open nbhd of `z₀pt`, `V = Y∖G`, `U = p₂⁻¹V`, `s` the slice section; all set up by L138-176.
- Located ABSOLUTE facts (not yet assembled into the relative equality):
  `AlgebraicGeometry.isField_of_universallyClosed` (`Γ(X,⊤)` is a field for `X` integral
  universally closed over a field `K`), `AlgebraicGeometry.finite_appTop_of_universallyClosed`
  (under `LocallyOfFiniteType`).

## Why now
This is described by the iter-158 prover as "the hardest residual input of the chain" and is
SHARED with Route A's Albanese universal property (Milne §III.6), so it is not throwaway. The
progress-critic bound a fallback: scoped analogist consult on this bridge BEFORE another prover
round. The absolute fact (`Γ(proper integral /field) is a field`) is in Mathlib; the open question
is whether Mathlib has the **relative assembly** — proper pushforward `f_* O_X`, Stein
factorization, or a "morphism to affine determined by global sections / factors through
`Spec Γ`" packaging — that turns "each slice's image is a point" into the morphism equality on `U`.

## Hints (optional)
Search targets: Stein factorization (`AlgebraicGeometry.SteinFactorization`? likely absent),
proper pushforward of the structure sheaf, `AlgebraicGeometry.Scheme.Γ` adjunction
(`AlgebraicGeometry.ΓSpec` / `Scheme.toSpecΓ` / `Γ`-`Spec` adjunction: a morphism `W ⟶ Spec R`
corresponds to a ring map `R ⟶ Γ(W)`), `AlgebraicGeometry.Scheme.homEquiv` for maps INTO an
affine scheme (a morphism `W ⟶ Spec R` is determined by `R ⟶ Γ(W,⊤)`). The likely idiomatic route:
maps into the affine `U₀` are determined by their ring map on global sections; if `Γ` of each
slice is `k̄`, the ring map is constant per slice, forcing factorization through `p₂`. Also check
whether `AlgebraicGeometry.IsAffineHom` / `affineTargetClass` or the morphism-into-affine
`Scheme.ΓSpecIso`/`Spec`-counit gives the "determined by global sections" handle. Is there a
relative `proper + O-connected ⟹ f_* O = O_base` (the algebraic-geometry form of
"proper-connected-into-affine is constant")? Distinguish: do we genuinely need `f_*` cohomology
(absent), or can the GLOBAL-SECTIONS adjunction + per-slice field argument suffice without it?
This distinction is the key thing I need from you — whether bridge 2 is a 1–2 iter idiomatic
assembly or a multi-iter Mathlib gap-fill.

## Severity expectation
high-stakes
