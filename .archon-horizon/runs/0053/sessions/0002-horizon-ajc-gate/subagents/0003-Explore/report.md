## 1. `Module.Finite.of_addEquiv_semilinear` (project-local)

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardTransfer.lean:106-110`

```lean
theorem Module.Finite.of_addEquiv_semilinear {R S : Type u} [Semiring R] [Semiring S]
    {M N : Type u} [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module S N]
    (σ : R →+* S) (hσ : Function.Surjective σ) (e : M ≃+ N)
    (he : ∀ (r : R) (x : M), e (r • x) = σ r • e x) (hN : Module.Finite S N) :
    Module.Finite R M
```
Note the direction: `N` finite over `S` ⟹ `M` finite over `R` (backwards along σ). Sole use site: same file, line 192, inside `AlgebraicGeometry.Scheme.Modules.module_finite_gamma_pullback_fromSpec` (line 157).

**Mathlib already covers this** (bidirectionally): `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/Finiteness/Basic.lean:258`

```lean
theorem LinearMap.finite_iff_of_bijective (f : M →ₛₗ[σ] P) (hf : Function.Bijective f) :
    Module.Finite R M ↔ Module.Finite S P
```
with section variables (lines 245-247): `{σ : R →+* S} [RingHomSurjective σ]`. Companion: `Module.Finite.of_surjective` at line 252 (also semilinear). So `of_addEquiv_semilinear` is the `.mpr` of `finite_iff_of_bijective` modulo packaging `e` + `he` as a `→ₛₗ[σ]` and supplying `RingHomSurjective σ` from `hσ`.

## 2 & 3. Transporting Free / Projective / Finite along a ring iso + semilinear equiv

**This is exactly `Module.Free.of_equiv` / `Module.Projective.of_equiv` in mathlib** (the names `of_ringEquiv` were deprecated 2026-02-14 to `of_equiv`):

- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/LinearAlgebra/FreeModule/Basic.lean:118-122`
```lean
lemma Module.Free.of_equiv {R R' M M' : Type*} [Semiring R] [AddCommMonoid M] [Module R M]
    [Semiring R'] [AddCommMonoid M'] [Module R' M']
    {σ : R →+* R'} {σ' : R' →+* R} [RingHomInvPair σ σ'] [RingHomInvPair σ' σ]
    (e₂ : M ≃ₛₗ[σ] M') [Module.Free R M] : Module.Free R' M'
```
- `LinearAlgebra/FreeModule/Basic.lean:139-144`: `Module.Free.iff_of_equiv (e₂ : M ≃ₛₗ[σ] M') : Module.Free R M ↔ Module.Free R' M'` (same instance hypotheses)
- `LinearAlgebra/FreeModule/Basic.lean:146-147`: `@[deprecated] alias of_ringEquiv := of_equiv`, `iff_of_ringEquiv := iff_of_equiv`
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/Algebra/Module/Projective.lean:172-176`
```lean
theorem Module.Projective.of_equiv {R S} [Semiring R] [Semiring S] {M N}
    [AddCommMonoid M] [AddCommMonoid N] [Module R M] [Module S N]
    {σ : R →+* S} {σ' : S →+* R} [RingHomInvPair σ σ'] [RingHomInvPair σ' σ]
    (e₂ : M ≃ₛₗ[σ] N) [Projective R M] : Projective S N
```
(deprecated alias `Projective.of_ringEquiv` at line 191.)

**Supplying the `RingHomInvPair` instances from a `σ : S ≃+* T`** — `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/Algebra/Ring/CompTypeclasses.lean`:
- line 124: `RingHomInvPair.of_ringEquiv (e : R₁ ≃+* R₂) : RingHomInvPair (↑e : R₁ →+* R₂) ↑e.symm`
- line 132: `RingHomInvPair.of_ringEquiv_symm (e : R₁ ≃+* R₂) : RingHomInvPair (↑e.symm : R₂ →+* R₁) ↑e`
- line 117: `RingHomInvPair.toRingEquiv (σ σ') : R₁ ≃+* R₂`

The mathlib idiom is `attribute [local instance] RingHomInvPair.of_ringEquiv RingHomInvPair.of_ringEquiv_symm in` before the theorem. Live examples worth copying:
- `/home/axel/…/Mathlib/RingTheory/Spectrum/Prime/FreeLocus.lean:58-75` (`mem_freeLocus_of_isLocalization`) — builds `{ __ := IsLocalizedModule.iso …, map_smul' := … }` as a `≃ₛₗ[e]` from a ring equiv `e` plus an additive iso, then `Module.Free.iff_of_equiv (σ := e)`.
- `/home/axel/…/Mathlib/RingTheory/LocalProperties/Projective.lean:162-176` (`Module.projective_of_localization_maximal'`) — same pattern with `Module.Projective.of_equiv (σ := e)`.

So the answer to (3): you do **not** go through `Basis.map`. You package `X ≃+ Y` + the semilinearity hypothesis as an anonymous-constructor `X ≃ₛₗ[(σ : S →+* T)] Y` (`{ __ := e, map_smul' := … }`), turn on `RingHomInvPair.of_ringEquiv`/`_symm` as local instances, and apply `Module.Free.of_equiv`. Its proof (Basic.lean:123-133) is precisely the "`Basis` constructor with semilinear data" you were looking for: it builds `Finsupp.mapRange.addEquiv e₁.toAddEquiv` and feeds `Basis.ofRepr`.

**`Basis.map` is NOT available for `≃ₛₗ`** — `/home/axel/…/Mathlib/LinearAlgebra/Basis/Defs.lean:163-166` fixes `variable (f : M ≃ₗ[R] M')`, `protected def Basis.map : Basis ι R M'`. The only semilinear thing in `Basis/Defs.lean` is `Basis.ext'` (line 321). The ring-changing basis transport is instead:
- `Basis.mapCoeffs` — `LinearAlgebra/Basis/Defs.lean:385`: `def Basis.mapCoeffs (f : R ≃+* R') (h : ∀ c x, f c • x = c • x) : Basis ι R' M` — same carrier `M`, two module structures agreeing through `f`. Not applicable when `X ≠ Y`.
- `Basis.ofRepr : (M ≃ₗ[R] (ι →₀ R)) → Basis ι R M` (structure field, `Basis/Defs.lean:88`).

**Other relevant plumbing:**
- `RingEquiv.toSemilinearEquiv (f : R ≃+* S) : R ≃ₛₗ[(↑f : R →+* S)] S` — `Algebra/Module/Equiv/Defs.lean:577-583` (only for the rings themselves as modules over themselves).
- `RingHom.toSemilinearMap (f : R →+* S) : R →ₛₗ[f] S` — `Algebra/Module/LinearMap/Defs.lean:471`.
- `AddEquiv.toLinearEquiv (e : M ≃+ M₂) (h : ∀ c x, e (c • x) = c • e x) : M ≃ₗ[R] M₂` — `Algebra/Module/Equiv/Basic.lean:222` (same ring only).
- `Module.compHom.toLinearEquiv (g : R ≃+* S) : R ≃ₗ[R] S` (with `Module.compHom S ↑g`) — `Algebra/Module/Equiv/Basic.lean:174`.
- `LinearEquiv.restrictScalars (f : M ≃ₗ[S] M₂) : M ≃ₗ[R] M₂` — `Algebra/Module/Equiv/Basic.lean:48` (needs `CompatibleSMul`/scalar towers, not a ring iso).

**`Module.finrank` / `rank` version** — `/home/axel/…/Mathlib/LinearAlgebra/Dimension/Basic.lean:213` and `:239`:
```lean
theorem lift_rank_eq_of_equiv_equiv (i : R → R') (j : M ≃+ M')
    (hi : Bijective i) (hc : ∀ (r : R) (m : M), j (r • m) = i r • j m) :
    lift.{v'} (Module.rank R M) = lift.{v} (Module.rank R' M')
theorem rank_eq_of_equiv_equiv (i : R → R') (j : M ≃+ M₁) (hi : Bijective i)
    (hc : …) : Module.rank R M = Module.rank R' M₁
```
(Algebra-flavoured variants at `Dimension/Basic.lean:322` and `:347`.)

### Project-local analogues already present
- `Module.finrank_eq_of_ringEquiv_addEquiv` — `AlgebraicJacobian/Picard/SchematicSupport.lean:712-718`: `(i : R ≃+* R') (j : M ≃+ M') (hc : ∀ r m, j (r • m) = i r • j m) : Module.finrank R M = Module.finrank R' M'` (just `Cardinal.toNat` of `rank_eq_of_equiv_equiv`).
- `Module.nonempty_addEquiv_of_finrank_eq_of_ringEquiv` — `AlgebraicJacobian/Picard/Pic0TangentSpace.lean:68-75` (fields, `Nonempty (V ≃+ W)` from equal finrank).
- `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_of_ringEquiv_semilinear` — `AlgebraicJacobian/Picard/QuotScheme.lean:1985-1998` (`σ : R ≃+* R'`, two σ-semilinear `≃+`s, transports `IsLocalizedModule` to `S.map σ`).
- `isPushout_of_ringEquiv` — `AlgebraicJacobian/Picard/SectionBaseChange.lean:196`.
- **No project-local `Module.Free` / `Module.Projective` semilinear transport exists** — the project only uses mathlib's `Module.Free.of_equiv'` (linear form), e.g. `AlgebraicJacobian/Picard/FlatteningStratification.lean:337, 354, 484, 535`.

## 4. QuotScheme.lean declarations

All in `namespace AlgebraicGeometry.Scheme.Modules`, file `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuotScheme.lean`.

**line 2116-2119**
```lean
noncomputable def gammaPullbackTopIso {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f]
    (M : Y.Modules) :
    Γ((Scheme.Modules.pullback f).obj M, ⊤) ≅ Γ(M, f.opensRange) :=
  gammaPullbackImageIso f M ⊤ ≪≫ eqToIso (by rw [Scheme.Hom.image_top_eq_opensRange])
```

**line 2130-2132**
```lean
noncomputable def gammaImageRingEquiv {X Y : Scheme.{u}} (j : X ⟶ Y) [IsOpenImmersion j]
    (V : X.Opens) : Γ(X, V) ≃+* Γ(Y, j ''ᵁ V) :=
  (j.appIso V).commRingCatIsoToRingEquiv.symm
```

**line 2140-2144**
```lean
theorem gammaPullbackImageIso_hom_semilinear {X Y : Scheme.{u}} (j : X ⟶ Y) [IsOpenImmersion j]
    (M : Y.Modules) (V : X.Opens) (a : Γ(X, V))
    (x : Γ((Scheme.Modules.pullback j).obj M, V)) :
    (gammaPullbackImageIso j M V).hom (a • x)
      = gammaImageRingEquiv j V a • (gammaPullbackImageIso j M V).hom x
```
(proof is 10 lines: `simp only [...]; erw [Scheme.Modules.Hom.app_smul]; rfl`.)

Related: `gammaPullbackImageIso_hom_naturality` at line 2106, `gammaPullbackImageIso_symm_semilinear` (private) at line 3523.

Since `gammaImageRingEquiv` is a genuine `≃+*` and `gammaPullbackImageIso_hom_semilinear` gives exactly `map_smul'` for it, `(gammaPullbackImageIso j M V).addCommGroupIsoToAddEquiv` + that lemma assembles directly into a `Γ((pullback j).obj M, V) ≃ₛₗ[(gammaImageRingEquiv j V : _ →+* _)] Γ(M, j ''ᵁ V)`, which is precisely the input shape of `Module.Free.of_equiv` / `Module.Projective.of_equiv` / `LinearMap.finite_iff_of_bijective`.

## 5. `IsLocalization.Away f Γ(Spec R, PrimeSpectrum.basicOpen f)`

**Yes, it is an instance** — `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineScheme.lean:640-643` (anonymous instance, inside `namespace AlgebraicGeometry.IsAffineOpen`; found by `inferInstance`, no name needed):
```lean
instance {R : CommRingCat} {f : R} :
    IsLocalization.Away f Γ(Spec R, PrimeSpectrum.basicOpen f) :=
  inferInstanceAs (IsLocalization.Away f
    ((Spec.structureSheaf R).obj.obj (op <| PrimeSpectrum.basicOpen f)))
```
The `Algebra R Γ(Spec R, U)` instance it uses is at `AffineScheme.lean:632-634`, with `algebraMap_Spec_obj` (line 637-638) identifying `algebraMap R Γ(Spec R, U) = ((Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.map (homOfLE le_top).op).hom`.

Named relatives:
- `AlgebraicGeometry.StructureSheaf.IsLocalization.to_basicOpen (r : R) : IsLocalization.Away r ((structureSheaf R).obj.obj (op <| basicOpen r))` — `AlgebraicGeometry/StructureSheaf.lean:928-930` (instance).
- anonymous `instance (f : R) : IsLocalization.Away f Γ(R, basicOpen f)` — `AlgebraicGeometry/StructureSheaf.lean:539-541` (namespace `AlgebraicGeometry.StructureSheaf`, the primitive one).
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen (hU : IsAffineOpen U) (f : Γ(X, U)) : IsLocalization.Away f Γ(X, X.basicOpen f)` — `AffineScheme.lean:659-660` (a `theorem`, not an instance; needs `hU`).
- `AlgebraicGeometry.isLocalization_away_of_isAffine [IsAffine X] (r : Γ(X, ⊤)) : IsLocalization.Away r Γ(X, X.basicOpen r)` — `AffineScheme.lean:673-676` (instance).
- `AlgebraicGeometry.IsAffineOpen.isLocalization_of_eq_basicOpen (i : V ⟶ U) (e : V = X.basicOpen f)` — `AffineScheme.lean:726-728`.
- `AlgebraicGeometry.Γ_restrict_isLocalization : IsLocalization.Away r Γ(X.basicOpen r, ⊤)` — `AffineScheme.lean:730-733` (instance).
