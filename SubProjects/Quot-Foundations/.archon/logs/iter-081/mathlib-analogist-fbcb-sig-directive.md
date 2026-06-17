## Mode: api-alignment

## Target
Design a stateable, elaborating Lean signature for the FBC-B capstone
`AlgebraicGeometry.Modules.baseChangeGammaPullbackEquiv` (blueprint
`thm:fbcb_global_direct`, `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
L4503). A `lean-scaffolder` pass crashed trying to STATE it — this is a
signature-shape question, not a proof.

## Context (existing project API — all in `AlgebraicJacobian/Cohomology/`)
- Base change is a pullback square `IsPullback g' f' f g` (FlatBaseChange.lean
  L2566/L2606): `g : S' ⟶ S`, `g' : X' ⟶ X`, with `X' = X_B` the apex.
- Pullback module: `F' = (Scheme.Modules.pullback g').obj F`  (F : X.Modules).
- `pushforwardBaseChangeMap` (L79): the comparison datum the sheaf-level iso is
  `IsIso` of.
- In FlatBaseChangeGlobal.lean: `groundRing X := X.presheaf.obj (op ⊤)`;
  `gammaModA M U : ModuleCat (groundRing X)` = sections of `M` over `U` as a
  `groundRing X`-module; `baseChangeGammaEquiv` (L241):
  `(groundRing X) ⊗ B ⊗ gammaModA F ⊤  ≃ₗ[B]  eqLocus(B⊗leftRes, B⊗rightRes)`
  for a flat `A=groundRing X`-algebra `B`; `gammaTopEquivEqLocus` (L203).

## Question
Blueprint wants `Γ(X,F) ⊗_A B  ≃ₗ[B]  Γ(X', F')`. The RHS `Γ(X', F')` is
`gammaModA ((Scheme.Modules.pullback g').obj F) ⊤`, but that is a module over
`groundRing X'`, NOT over `B`. Find the Mathlib/project idiom for:
1. The canonical ring iso/algebra map `B ≅ groundRing X'` (or `Algebra B
   (groundRing X')`) for `X' = X_B` — i.e. `Γ(X_B, O) = B ⊗_A Γ(X,O)` collapsing
   to `B` when `X' = X ×_{Spec A} Spec B` and `A = Γ(X,O)`. Is there a clean
   `Scheme.Modules.pullback`/`ΓSpecIso`-based spelling? Does the pullback square
   need an extra hypothesis (e.g. `S = Spec (groundRing X)`, the canonical
   `X ⟶ Spec Γ`) to pin `groundRing X' = B`?
2. Given that, how to view `gammaModA F' ⊤` as a `B`-module so the `≃ₗ[B]`
   typechecks (restrictScalars along `B → groundRing X'`, or the iso).
3. Whether the cleanest signature parametrizes over the abstract pullback square
   `IsPullback g' f' f g` + `[Flat g]` + `S' = Spec B`, or directly over a flat
   `A`-algebra `B` with `X' := pullback (X ⟶ Spec A) (Spec.map ...)` constructed
   in-statement (mirroring how `baseChangeGammaEquiv` takes `B` directly).

Deliver the recommended `noncomputable def baseChangeGammaPullbackEquiv …` header
(hypotheses + `≃ₗ[B]` type) that will elaborate, with the restrictScalars/algebra
plumbing named, so a scaffolder can land the sorry stub next iter. Cite the Mathlib
decls (ΓSpecIso, pullback-of-Spec, restrictScalars) by name.

## Search radius
narrow (algebraic geometry / Scheme.Modules + CommRing base change)
