## (A) Mathlib inventory (this pin: `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib`)

**Invariants of a group action on a ring — present and usable.**
- `FixedPoints.subsemiring (B' G) : Subsemiring B'` — `Mathlib/Algebra/Algebra/Subalgebra/Operations.lean:90`
- `FixedPoints.subring (B G) : Subring B` — same file, `:98`
- `FixedPoints.subalgebra (A B' G) : Subalgebra A B'` — same file, `:106`. Requires `[MulSemiringAction G B']`, `[SMulCommClass G A B']`. Membership is `Iff.rfl` with `∀ g, g • x = x` (I verified).
- `FixedPoints.subfield` — `Mathlib/FieldTheory/Fixed.lean:107`; `IsInvariantSubring` (`Mathlib/Algebra/Ring/Action/Invariant.lean:33`), `IsInvariantSubfield` (`FieldTheory/Fixed.lean:77`).
- `Algebra.IsInvariant A B G` — `Mathlib/RingTheory/Invariant/Defs.lean:31` (predicate "every fixed point comes from `A`"), with a substantial theory in `Mathlib/RingTheory/Invariant/Basic.lean`: `Algebra.IsInvariant.isIntegral` (`:179`), `exists_smul_of_under_eq` (`:187`, `G` transitive on primes over a prime), `orbit_eq_primesOver` (`:208`), `Algebra.IsInvariant.charpoly` (`:140`). This is the arithmetic (Frobenius) theory, not the scheme-quotient theory, but `orbit_eq_primesOver` is exactly the point-set statement "`Spec B → Spec B^G` has orbits as fibres".
- `Subalgebra`/`RingHom.codRestrict` (`Mathlib/Algebra/Algebra/Subalgebra/Basic.lean:566`) supplies the factorisation.

**Spec of the invariant subring: no universal property in mathlib, but it is ~15 lines from the adjunction.** There is *nothing* named `FixedPoints` anywhere under `Mathlib/AlgebraicGeometry/` or `Mathlib/RingTheory/Spectrum/` (grepped, empty). However I **proved, machine-checked, in this pin** the affine categorical-quotient statement:

```
theorem specFixedPoints_universal (T B : Type) [CommRing T] [CommRing B]
    (G : Type) [Group G] [MulSemiringAction G B]
    (f : Spec (CommRingCat.of B) ⟶ Spec (CommRingCat.of T))
    (hf : ∀ g : G, Spec.map (CommRingCat.ofHom (MulSemiringAction.toRingHom G B g)) ≫ f = f) :
    ∃! u : Spec (CommRingCat.of (FixedPoints.subring B G)) ⟶ Spec (CommRingCat.of T),
      Spec.map (CommRingCat.ofHom (FixedPoints.subring B G).subtype) ≫ u = f
```
28 lines, no `sorry`, **no finiteness on `G`**. Ingredients: `Spec.preimage` / `Spec.homEquiv` / `Spec.map_preimage` / `Spec.preimage_map` / `Spec.preimage_comp` / `Spec.map_injective` at `Mathlib/AlgebraicGeometry/GammaSpecAdjunction.lean:549-581`, plus `Spec.fullyFaithful` (`:522`), `Spec.full` (`:527`), `Spec.faithful` (`:530`), `ΓSpec.adjunction`, `AffineScheme.equivCommRingCat : AffineScheme ≌ CommRingCatᵒᵖ` (`Mathlib/AlgebraicGeometry/AffineScheme.lean:217`), `AffineScheme.hasLimits/hasColimits` (`:227,:231`).

**Symmetric powers.**
- `SymmetricPower` (`Sym[R] ι M`) — `Mathlib/LinearAlgebra/TensorPower/Symmetric.lean:52`, with `mk` (`:108`), `tprod`, `span_tprod_eq_top` (`:137`). Modules only; **no algebra/ring structure**, no permutation action recorded there.
- `MvPolynomial.symmetricSubalgebra` (`Mathlib/RingTheory/MvPolynomial/Symmetric/Defs.lean:108`) and the **fundamental theorem** `MvPolynomial.esymmAlgEquiv : MvPolynomial (Fin n) R ≃ₐ[R] symmetricSubalgebra σ R` (`Symmetric/FundamentalTheorem.lean:340`, plus `esymmAlgHom_injective/surjective`). This is `Sym^n(𝔸^1) ≅ 𝔸^n` in disguise — the one genuinely non-trivial affine symmetric power available off the shelf.
- `Sym α n` (multisets of fixed size) — `Mathlib/Data/Sym/Basic.lean`. Type level only.
- n-fold tensor power as a ring: `PiTensorProduct.instCommRing` (`Mathlib/RingTheory/PiTensorProduct.lean:310`), `instAlgebra` (`:154`), `liftAlgHom` (`:207`), `algHom_ext` (`:221`), `singleAlgHom` (`:192`). The permutation action is **not** there: `PiTensorProduct.reindex` (`Mathlib/LinearAlgebra/PiTensorProduct.lean:677`) is only `≃ₗ`. I verified the multiplicativity upgrade compiles (an `AlgHom` from `reindex` for `Equiv.Perm (Fin n)`: `map_mul'` by double `induction_on`, `map_one'`/`commutes'` by `reindex_tprod` + `rfl`) — about 20 lines for the `AlgHom`, ~30 for the `AlgEquiv`/`MulSemiringAction`.

**Quotients of schemes by group actions: genuinely absent.** No `Scheme.Quotient`, no `quotientScheme`, no `MulAction` on `Scheme`, no "categorical quotient" vocabulary anywhere. `Mathlib/AlgebraicGeometry/Group/` contains only `Abelian.lean` and `Smooth.lean` (no action-on-a-scheme API). Colimits of schemes exist only for **discrete** shapes (`Mathlib/AlgebraicGeometry/Limits.lean:187-188`) and pushouts **along open immersions** (`:725`); no coequalizers. `Mathlib/AlgebraicGeometry/EffectiveEpi.lean` has one instance (`effectiveEpi_base_of_flat`, `:49`).

## (B) Sibling-project inventory

- **AJC** `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/SymPowInterface.lean` — 318 lines, **sorry-free** (the 3 `sorry` grep hits are docstring prose: `:20`, `:60`, `:85`). Field list verified below.
- `.../Albanese/AlbaneseFromData.lean` — 469 lines, sorry-free (5 grep hits are prose); capstone `exists_unique_albanese_factorisation_of_birational` at `:432` consumes `(D : SymPowData C g)` **and** `hproj`.
- `.../Albanese/AlbaneseUP.lean` — 704 lines, **6 real `sorry`s** (lines 398, 445, 490, 527, 584, 621); header at `:88` states the "mathlib has no quotient of a scheme by a finite group" claim.
- `.../Picard/FiniteGaloisQuotient.lean` — **550 lines, 0 sorry**. This is the most relevant sibling asset and it is *not* referenced from the Albanese lane. It contains `toSpecAut : G →* Aut (Spec (CommRingCat.of A))` (`:103`) — a ring action turned into a scheme action; `SemilinearGalAction` (`:155`); `orbit` (`:174`); `OrbitsInAffineOpen` (`:184`); `IsStableOpen` (`:189`); `HasStableAffineCover` (`:203`); `IsGaloisQuotient` (`:374`); `HasGaloisQuotient` (`:393`); and `affineGaloisQuotientHomEquiv` (`:532`) — "the affine case of the Hom property, **proved**".
- `.../Picard/GaloisQuotientGlue.lean` — 433 lines, 0 sorry: `sectionsMulSemiringAction : MulSemiringAction (L ≃ₐ[K] L) Γ(X, U)` (`:176`), `actRes : U.toScheme ⟶ U.toScheme` (`:341`), `restrict : SemilinearGalAction …` (`:374`), `actRes_isoSpec_hom_toSpecAut` (`:415`). This is a worked example of "group acts on a scheme, restrict to affine opens, act on sections, compare with `Spec` of the ring action" — precisely the gluing bookkeeping `Sym^n C` needs.
- **AJCR** `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Albanese/` — 24 files, 7327 lines, **0 `sorry`**, and **no symmetric-power content at all** (only `Picard/JacobianDataCharts.lean` mentions "symmetric"). Its Albanese work is the Milne III.3/Thm 3.2 rational-map-extension arc.
- **SubProjects/Albanese** `AlgebraicJacobian/Albanese/AlbaneseUP.lean` — 30 `sorry` grep hits, 7 real (`:183, 250, 300, 335, 373, 417, 458`). Contains `Pic0.SymmetricPower … := sorry` (a `sorry`-bodied *definition*, at ~`:296-300`) with a docstring specifying exactly the construction `Spec((A^{⊗g})^{S_g})` glued over an affine cover. No `SymmetricPower.lean` file exists anywhere in the workspace — the "iter-178+ substrate file" it defers to was never written.

## (C) `SymPowData` exact fields, and ranked inhabitation routes

Fields (`SymPowInterface.lean:122-131`), in a `CartesianMonoidalCategory K` with `HasFiniteProducts K`:
```
carrier : K
proj    : (∏ᶜ (fun _ : Fin n => C)) ⟶ carrier
desc    : ∀ {T : K} (h : (∏ᶜ (fun _ : Fin n => C)) ⟶ T),
            (∀ σ : Equiv.Perm (Fin n), MonObj.permAut C σ ≫ h = h) →
            ∃! u : carrier ⟶ T, proj ≫ u = h
```
Load-bearing analysis. `desc` quantifies over **every** `T : K` — for AJC, `K = Over (Spec (.of kbar))`, i.e. all schemes over `k̄`, not just affine ones. The paired hypothesis `hproj : ∀ σ, permAut C σ ≫ D.proj = D.proj` is what kills `symPowDataTrivial` (`:297`). But note a sharper fact than the file's warning: **if `proj` is a monomorphism, `hproj` forces `permAut C σ = 𝟙`.** So any candidate where `proj` is an iso/mono passes `hproj` for free, and the discriminating case needs `permAut C σ ≠ 𝟙` — i.e. `C` not subterminal *and* `n ≥ 2`.

Routes, ranked by cost:

1. **`C = 𝟙_ K` (the point `Spec k̄`), any `n`. ~25 lines, zero mathlib gap. Verified compiling.** I built and checked `symPowDataUnit (n : ℕ) : SymPowData (𝟙_ K) n` with `carrier := 𝟙_ K`, `proj := toUnit _`, and `symPowDataUnit_proj_perm := toUnit_unique _ _`. All three fields provable, including `desc` for *arbitrary* `T` (the section `Pi.lift (fun _ => 𝟙 (𝟙_ K))` and `toUnit_unique` give both halves). Since `exists_unique_albanese_factorisation_of_birational` has **no curve hypothesis** (its own docstring, `AlbaneseFromData.lean:402`), this instantiates the capstone at `g ≥ 2` for the first time. Honest limit: `∏ᶜ (fun _ : Fin n => 𝟙_)` is terminal, so `permAut = 𝟙` and the symmetry test is passed vacuously — this is the *same* degeneracy class as `n = 1`, and should be advertised as "the interface is consistent at every `n`", not as "the group law is exercised".
2. **`n = 0`, any `C`. ~8 lines, no gap. Verified compiling.** `symPowDataZero` with `proj := 𝟙`; `hproj` holds because `Equiv.Perm (Fin 0)` acts through `Pi.hom_ext` on an empty index (`b.elim0`). Strictly weaker than route 1 — it is `symPowDataTrivial` with a vacuous symmetry check.
3. **`C` affine, `n ≥ 2`, `desc` restricted to affine `T`. ~250-400 lines, one real gap.** Buildable today: `permAlg` on `⨂[k] Fin n, A` (~30 lines, verified the `AlgHom` half compiles), `MulSemiringAction (Equiv.Perm (Fin n))` on it (~20), `FixedPoints.subalgebra` as the carrier, `specFixedPoints_universal` as `desc` (28, proved above), plus `Spec (⨂ A) ≅ ∏ᶜ Spec A` in `Over (Spec k̄)`. **That last iso is the gap**: mathlib has only the binary `AlgebraicGeometry.pullbackSpecIso` (`Mathlib/AlgebraicGeometry/Pullbacks.lean:719`) and no `PiTensorProduct`-to-`Spec` comparison anywhere (`PiTensorProduct` never appears under `AlgebraicGeometry/`). Budget 150-250 lines to build the n-fold iso by induction from the binary one. This route does **not** inhabit `SymPowData` as literally written, because `desc` needs *all* `T`.
4. **`C` affine, `n ≥ 2`, full `desc`. Route 3 plus the "affine target suffices" reduction.** The extra content: a non-affine `T` receives a morphism from the affine `C^n`, and one must show the unique affine factorisation is still unique/exists globally. This needs `Spec(B^G)` to be a *topological* quotient plus the invariant-sections computation — nothing in mathlib (confirmed: zero `FixedPoints` hits in `AlgebraicGeometry/` or `RingTheory/Spectrum/`). Realistic 400-700 lines on top of route 3.
5. **General `C` (the real `Sym^g C` for a curve), `n ≥ 2`.** Route 4 plus gluing over an affine cover, `S_n`-stable refinement, and cocycle bookkeeping. The in-tree precedent for exactly this bookkeeping is `Picard/FiniteGaloisQuotient.lean` + `Picard/GaloisQuotientGlue.lean` (983 sorry-free lines), which already has `toSpecAut`, stable-open predicates, orbit-in-affine-open, and a proved affine Hom-property. Reusing them, I'd put this at 1200-2000 lines rather than the `analogies/m3-route-audit.md:238-250` estimate of 2400-3800.

## (D) What contradicts "mathlib has nothing"

Three things, in decreasing importance.

The **affine half of the quotient is fully available and I proved it in this pin** (`specFixedPoints_universal`, 28 lines, no finiteness hypothesis on `G`). The header claim at `SymPowInterface.lean:17-20` and `AlbaneseUP.lean:88` — "there is no quotient of a scheme by a finite group action" — is accurate only about the *global* construction; it reads as though the affine model were also missing, and the sized-at-2400-3800-lines figure in `analogies/m3-route-audit.md` was priced without noticing that `FixedPoints.subring`/`subalgebra` plus `Spec.homEquiv` closes the affine universal property outright.

The **fundamental theorem of symmetric polynomials is in mathlib as an `AlgEquiv`** (`MvPolynomial.esymmAlgEquiv`, `RingTheory/MvPolynomial/Symmetric/FundamentalTheorem.lean:340`). That is a complete, non-degenerate `Sym^n` of an affine scheme (`Sym^n 𝔸^1 ≅ 𝔸^n`) sitting in the library, unused by this lane.

The **project's own `Picard/FiniteGaloisQuotient.lean` (550 lines, 0 sorry) already contains scheme-level finite-group-action infrastructure**, including `toSpecAut : G →* Aut (Spec (CommRingCat.of A))` at line 103 and a *proved* affine Hom-property `affineGaloisQuotientHomEquiv` at line 532, with `GaloisQuotientGlue.lean` supplying the affine-open restriction and sections-action machinery. The Albanese lane's "missing quotient" and the Picard lane's "Galois quotient" are the same construction with a different group; neither file references the other.

Two smaller corrections. `symPowDataTrivial`'s docstring says the discriminator is that `hproj` "would force `permAut C σ = 𝟙`" — true, but the general statement is stronger and worth recording: `hproj` + `proj` mono forces `permAut C σ = 𝟙`, so *any* candidate with monic `proj` (including route 1 and the existing `n = 1`) passes symmetry vacuously. And `SubProjects/Albanese/.../AlbaneseUP.lean:296` carries a `sorry`-bodied `Pic0.SymmetricPower` definition deferring to an `Albanese/SymmetricPower.lean` substrate file that does not exist anywhere in the workspace — the same failure mode the AJC interface file was written to avoid.
