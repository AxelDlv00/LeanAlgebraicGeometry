# AlgebraicJacobian/Picard/QuotScheme.lean

## Status: PARTIAL — sheaf-level iso chain landed; HARD BAR not met (0 sorry closures); 12 sorries (unchanged)

iter-193 Lane F target: close `_sectionLinearEquiv` body (the
"compositional bookkeeping" residual). HARD BAR: 1 axiom-clean closure.

**Result**: structural advance — the sheaf-level iso chain is now
in the body (5-step composition); the residual sorry is now localized
to the LinearEquiv extraction + Beck-Chevalley intertwining check.
But no sorry was fully eliminated this iter.

## `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (line 815)

### Attempt 1 (this iter): sheaf-level iso chain assembly

- **Approach**: assemble the 5-step iso chain at the sheaf level
  using the obtained witnesses `step1`, `step2`, `step3` plus
  Mathlib's `IsAffineOpen.SpecMap_appLE_fromSpec` for the
  commutative square `hU.fromSpec ≫ g = Spec.map φ ≫ hV.fromSpec`.

- **Substantive new content** (~25 LOC):

  ```lean
  have h_eq : _hU.fromSpec ≫ g = Spec.map (g.appLE V U e) ≫ _hV.fromSpec :=
    (IsAffineOpen.SpecMap_appLE_fromSpec g _hV _hU e).symm
  let composedIso :=
    ((Scheme.Modules.pullbackComp _hU.fromSpec g).app N ≪≫
      (Scheme.Modules.pullbackCongr h_eq).app N ≪≫
      ((Scheme.Modules.pullbackComp (Spec.map (g.appLE V U e)) _hV.fromSpec).app N).symm ≪≫
      (Scheme.Modules.pullback (Spec.map (g.appLE V U e))).mapIso step1 ≪≫
      step2)
  let topAdd := { ... : Γ((pullback hU.fromSpec).obj ((pullback g).obj N), ⊤) ≃+ _ }
  ```

  The 5-step chain:
  1. `(pullback hU.fromSpec).obj ((pullback g).obj N)` (sheaf on Spec Γ(Y, U))
  2. ≅ `(pullback (hU.fromSpec ≫ g)).obj N`                          [pullbackComp]
  3. ≅ `(pullback (Spec.map φ ≫ hV.fromSpec)).obj N`                 [pullbackCongr h_eq]
  4. ≅ `(pullback (Spec.map φ)).obj ((pullback hV.fromSpec).obj N)`  [(pullbackComp).symm]
  5. ≅ `(pullback (Spec.map φ)).obj (tilde Γ(N, V))`                 [step1: Stacks 01I8]
  6. ≅ `tilde (TensorProduct Γ(X,V) Γ(Y,U) Γ(N,V))`                  [step2: Stacks 01HQ]

  Then ⊤-sections give the AddEquiv `topAdd`.

- **Result**: PARTIAL — sheaf-level iso chain landed axiom-clean.
  Residual: the Σ-pair construction (LinearEquiv with intertwining)
  still requires:
  (a) ⊤-section transport to TensorProduct via `tilde.isoTop.symm`
      (faces a `Γ(X, V)` notation ambiguity between the structure-sheaf
      `Γ(X, V) : CommRingCat` and the module-sheaf `Γ(X, V) : Ab`
      readings — needs careful `↑` type ascription or fresh `set`-name);
  (b) AddEquiv → Γ(Y, U)-LinearEquiv upgrade via `Hom.app_smul` +
      ΓSpecIso scalar transport;
  (c) compose with `step3.symm` to land in `Γ((pullback g).obj N, U)`;
  (d) Beck-Chevalley intertwining check `1 ⊗ x ↦ baseMap g N e x`
      via naturality of the adjunction unit
      `pullback_app_isoTensor_unitAtV`.

- **Key Mathlib finding**: `IsAffineOpen.SpecMap_appLE_fromSpec` at
  `Mathlib/AlgebraicGeometry/AffineScheme.lean:464` provides exactly
  the commutative square we need. Argument order is delicate (mathlib's
  `f` ↔ our `g`, mathlib's `hU` ↔ our `hV`, etc.).

### Dead-end warning

- `Γ(X, V)` notation is ambiguous (CommRingCat reading vs Ab reading
  via Modules.presheaf). Inside `ModuleCat.of Γ(Y, U) (TensorProduct
  Γ(X, V) Γ(Y, U) Γ(N, V))`, elaboration can't pick between them.
  Workarounds: (i) use `_ ` placeholder with inferred type (worked
  for `topAdd`); (ii) `set R : CommRingCat := Γ(X, V)` to bind the
  CommRingCat reading; (iii) explicit `↑Γ(X, V)` and `↑Γ(Y, U)`.
  iter-194 prover SHOULD use approach (ii) when extracting the
  LinearEquiv to avoid repeating this trap.

### Next-iter recipe

The chain is in place. Next iter:

```lean
-- After composedIso and topAdd are built:
set TP : Type u := TensorProduct ↑Γ(X, V) ↑Γ(Y, U) ↑Γ(N, V)
-- Use tilde.isoTop on `ModuleCat.of ↑Γ(Y, U) TP`:
let isoT := AlgebraicGeometry.tilde.isoTop (ModuleCat.of (↑Γ(Y, U)) TP)
-- isoT : ModuleCat.of (↑Γ(Y, U)) TP ≅ (modulesSpecToSheaf.obj (tilde ...)).presheaf.obj (.op ⊤)
-- Chain topAdd with isoT.inv.hom (with appropriate type bridge from
-- `Γ(tilde M, ⊤)` to `(modulesSpecToSheaf.obj (tilde M)).presheaf.obj (.op ⊤)`).
-- This bridge is potentially defeq but may need `cast`/`heq` machinery.

-- Upgrade AddEquiv → LinearEquiv via `.toLinearEquiv` with smul proof
-- (use Hom.app_smul over Γ(Spec Γ(Y, U), ⊤) ≅ Γ(Y, U) via ΓSpecIso).

-- Compose with step3.symm: TensorProduct →ₗ Γ((pullback g).obj N, U).

-- Beck-Chevalley intertwining: trace `1 ⊗ x` through each step,
-- using naturality of pullback_app_isoTensor_unitAtV. This is the
-- "naturality square" check between the adjunction unit and the
-- iso chain.
```

## Other sorries (no progress this iter)

- `hilbertPolynomial` body (line 170) — Snapper's Lemma. Deep.
- `QuotFunctor` body (line 208) — substantive functor. Deep.
- `Grassmannian` body (line 245) — substantive functor. Deep.
- `Grassmannian.representable` body (line 272) — deep representability.
- `QuotScheme` body (line 326) — main theorem. Deep.
- `pullback_tildeIso` body (line 562) — Stacks 01HQ. Mathlib gap.
- `pushforward_isQuasicoherent` body (line 588) — Stacks 01XJ.
  Brief look: would need `IsQuasicoherent.of_coversTop` on an affine
  cover of S. Each affine V gives qcqs `f|_{f⁻¹V}` and QC `F|_{f⁻¹V}`;
  pushforward is QC on V by direct presentation extraction. ~80 LOC,
  iter-194+ work.
- `tildeIso_of_isQuasicoherent_isAffineOpen` body (line 616) — Stacks
  01I8. Mathlib gap; would need pullback-preserves-QC infrastructure.
- `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
  body (line 1032) — Beck-Chevalley compatibility chain.
- `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` body (line
  1091) — base-side Mayer-Vietoris descent. Substantive.
- `canonicalBaseChangeMap_app_app_isIso_of_affineCover` body (line
  1133) — target-side Mayer-Vietoris descent. Substantive.

## Blueprint marker recommendations

- `lem:pullback_app_isoTensor_baseMap_sectionLinearEquiv` — KEEP as
  `\leanok` for statement; the proof body is still `sorry` (do NOT
  add `\leanok` for proof). The iso chain progress is internal to
  the body; the blueprint statement is unchanged.

## Lemmas found this iter

- `IsAffineOpen.SpecMap_appLE_fromSpec`: commutative square for the
  fromSpec map of affine opens under a morphism. Key for `_sectionLinearEquiv`.
- `Scheme.Modules.pullbackComp`, `Scheme.Modules.pullbackCongr`:
  natural isomorphisms for pullback composition / equality. Used in
  composedIso.
- `tilde.isoTop` (Mathlib `Tilde.lean:177`): `M ≅ Γ(tilde M, ⊤)` in
  ModuleCat R. Available for the iter-194+ extraction.
- `Scheme.Modules.fromTildeΓ` (Mathlib `Tilde.lean:195`): the counit
  `tilde Γ(M, ⊤) ⟶ M`. Useful alternative path.
- `isIso_toOpen_top` (Mathlib `Tilde.lean:171`): `IsIso (toOpen M ⊤)`.

## Files / regions touched

- `AlgebraicJacobian/Picard/QuotScheme.lean` lines 850-901 (body of
  `pullback_app_isoTensor_baseMap_sectionLinearEquiv`).
- No other files touched. No protected signatures modified.

## Build status

GREEN: 12 sorries (unchanged), 0 axioms, no errors.
