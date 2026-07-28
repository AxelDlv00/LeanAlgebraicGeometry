I have everything needed. Here are my findings.

## (i) What actually exists, with paths

**Mathlib at v4.31.0 (`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/`):**

Scheme-level quotient by a finite group action: **does not exist**. I searched `Mathlib/AlgebraicGeometry/` exhaustively — the directory listing has no quotient file, `grep` for `MulAction`/`MulSemiringAction` against `Scheme` returns **zero hits**, and there is no coequalizer-in-Scheme or categorical-quotient construction. Confirmed: mathlib's `SymmetricPower` lives only in `Mathlib/LinearAlgebra/TensorPower/Symmetric.lean` (`SymmetricPower`, `SymmetricPower.mk`, `SymmetricPower.tprod`, `SymmetricPower.Rel`) and is for **modules only**. There is no `Sym` for schemes anywhere.

Ring-level invariants (part 2a) — **present but thin**:
- `FixedPoints.subring` / `FixedPoints.subsemiring` / `FixedPoints.subalgebra` — `Mathlib/Algebra/Algebra/Subalgebra/Operations.lean:98` (and 89, 105)
- `Algebra.IsInvariant` — `Mathlib/RingTheory/Invariant/Defs.lean:29`
- `MulSemiringAction.charpoly` + `Algebra.IsInvariant.isIntegral` — `Mathlib/RingTheory/Invariant/Basic.lean:140`, `:179`
- `FixedPoints.subfield` / `FixedPoints.isIntegral` — `Mathlib/FieldTheory/Fixed.lean:251`

The gap: I found **no** finite-type-over-invariants / Noether finiteness result (`grep FixedPoints × FiniteType|Noetherian|fg` = zero hits). Integrality exists; module-finiteness of `A` over `A^G` for a general commutative ring does not. And there is no `Equiv.Perm` action on a tensor power (`grep` on `PiTensorProduct.lean`/`TensorPower/*` = zero hits) — the `(A^{⊗g})^{S_g}` action itself would have to be built.

Scheme gluing (part 2b) — **complete and usable**: `AlgebraicGeometry.Scheme.GlueData` at `Mathlib/AlgebraicGeometry/Gluing.lean:91`, with `glued`, `ι`, `ι_isOpenImmersion`, `ι_jointly_surjective`, `glue_condition`, `vPullbackConeIsLimit`, `openCover`, `glueMorphisms`, `hom_ext`, `ι_glueMorphisms`. Also `Scheme.RelativeGluing` and `GluingOneHypercover`.

**Birationality (part 5) — the important negative:** there is **no `IsBirational` predicate in mathlib at this pin**. `Mathlib/AlgebraicGeometry/Birational/` contains exactly two files, `Dominant.lean` and `RationalMap.lean`, and `Dominant.lean` has only 7 declarations, all of the form "`IsDominant` of a `PartialMap` is restriction-invariant". `grep -rn "IsBirational" Mathlib/` returns only `ENNReal.orderIsoUnitIntervalBirational` (unrelated). There is no "invert a birational morphism on a dense open" lemma and no `RationalMap` inverse.

**AJC project — real reusable infrastructure I did not expect to find:**
- `/home/axel/.../AlgebraicJacobian/Picard/FiniteGaloisQuotient.lean` (550 lines) — a *finite group quotient of a scheme* engine: `toSpecAut : G →* Aut (Spec A)`, `SemilinearGalAction`, `IsGaloisQuotient`, `HasStableAffineCover`, `HasGaloisQuotient`, `affineGaloisQuotientHomEquiv`. Plus `Picard/GaloisQuotientGlue.lean` (433 lines) with `sectionsMulSemiringAction`, `isStableOpen_basicOpen_prod_actApp`, `actRes_isoSpec_hom`, and `Picard/FiniteGaloisQuotientAffine.lean` (590 lines).

This is the closest thing in the workspace to a `Sym^g` construction, and its module docstring records the decisive verdict for your question: `HasStableAffineCover` and `HasGaloisQuotient` are deliberately **instance-free `Prop`-gates**, because the orbit-in-affine hypothesis is *essential* (Hironaka's smooth proper non-projective threefold with a free ℤ/2-action whose quotient is only an algebraic space). The file calls the stable-affine-refinement step "a genuine multi-session lemma (walls: transport of sections along the action isomorphisms, and basic-open-affineness bookkeeping)". Note also it's owned by another lane per I-0493, so it can't be edited from this file's lane.

## (ii) Verdict: Sym^g C is a multi-session subproject

Not buildable in-session. Three independent reasons, in increasing severity:

1. **The affine heart doesn't exist in mathlib.** You need `(A^{⊗g})^{S_g}` with the S_g-action on the tensor power (absent), and then module-finiteness over the invariants to get an honest scheme of finite type (absent — only `IsIntegral` exists).
2. **The gluing is not the hard part but is not free either.** `Scheme.GlueData` requires you to produce `V i j`, `t i j`, and verify the cocycle `t' `-condition for the ~g-fold-product charts of a cover of C. That's the standard multi-day GlueData grind.
3. **The decisive one:** the project's own `FiniteGaloisQuotient.lean` already tried exactly this shape for a *simpler* group action and concluded the geometric step is multi-session and gated by a genuine counterexample. Sym^g C is a harder instance (the action is not free — the diagonal is fixed — so the quotient is not étale and the blueprint's own `lem:symmetric_power_nonsingular` needs the completed-local-ring symmetric-function argument at `k[[X_1..X_r]]^{S_r} = k[[σ_1..σ_r]]`, which is another full subproject).

## (iii) Cheapest honest increment, ranked

**#1 — the `SymmetricPowerData` restructuring (recommended).** Your hypothesis in question 4 is correct, and I verified it in Lean rather than argued it. Replace the `sorry`-bodied `def SymmetricPower` (which currently makes everything downstream vacuous) with a bundled structure that the downstream lemmas take as an argument. I compiled a working prototype against the actual project (probe now deleted). It closes **3 of the 6 sorries outright and reduces a 4th**:

- `symmetricPowerAVMap` → **closes**, as `(D.desc (sumMap g φ) (sumMap_isSymmetric g φ)).choose`.
- `symmetricPowerToJacobian` → **closes**, as `symmetricPowerAVMap D (abelJacobi C P0)`, exactly as its docstring already says.
- `SymmetricPower` → **is deleted as a sorry**; the existence of the bundle becomes an explicit hypothesis/`Prop`-gate. This is a genuine honesty gain, not bookkeeping: `sorry`-bodied *definitions* are worse than open hypotheses, because they silently make every statement about them unfalsifiable.
- `albanese_eq_iff_symmetricPower_eq` → **forward direction closes**; the reverse direction still needs `s_{P_0} : C ⟶ Sym^g C` (blueprint `def:basepoint_section_symmetric_power`), which is a *fourth field* you can add to the bundle, at which point it closes too.

Two remaining: `abelJacobi` (needs Pic⁰ moduli interpretation — another lane's dependency) and `descentThroughBirationalSigma`.

**#2 — `descentThroughBirationalSigma`.** Partly unblocked by your `extend_to_av` landing, but not fully. Details below.

**#3 — do not attempt `abelJacobi`.** It consumes the Pic⁰ moduli property, which lives on the `ajc-etale-pic` seam.

## (iv) Proof sketch for #1, with verified lemma names

Everything below compiled. `A` commutative is *derivable*, not an added hypothesis — that's the key enabler:

```
GeometricallyReduced A.hom          := geometricallyReduced_of_smooth A.hom   -- already in AlbaneseUP.lean:162
GeometricallyIntegral A.hom         := GeometricallyIntegral.of_geometricallyReduced_of_geometricallyIrreducible A.hom
IsCommMonObj A                      := isCommMonObj_of_isProper_of_geometricallyIntegral A  -- Mathlib/AlgebraicGeometry/Group/Abelian.lean:133 (@stacks 0BFD)
```

Then, with `curvePow C g := ∏ᶜ fun _ : Fin g => C` (products in `Over (Spec (.of kbar))` exist — `inferInstance`), `permAut C g σ := Pi.lift fun i => Pi.π _ (σ i)`, and `sumMap g φ := ∏ i : Fin g, (Pi.π _ i ≫ φ)`:

```lean
theorem sumMap_isSymmetric (g : ℕ) (φ : C ⟶ A) : IsSymmetric (sumMap g φ) := by
  intro σ
  show precompHom (permAut C g σ) (sumMap g φ) = sumMap g φ
  unfold sumMap
  rw [map_prod]
  refine Fintype.prod_equiv σ _ _ (fun i => ?_)
  show permAut C g σ ≫ _ = _
  rw [← Category.assoc, permAut, Pi.lift_π]
```
where `precompHom h : (Y ⟶ A) →* (X ⟶ A)` is built from `MonObj.comp_one` and `MonObj.comp_mul` (`Mathlib/CategoryTheory/Monoidal/Cartesian/Mon.lean:437,440`), and `Hom.commMonoid` (same file, :277) supplies the `CommMonoid (X ⟶ A)` that `∏` and `map_prod` need. That is the whole of blueprint `lem:symmetric_product_av_map` — five lines, no geometry.

The forward direction of the biconditional is `map_prod` again, on postcomposition `MonoidHom.mk' (· ≫ ψ) (fun u v => MonObj.mul_comp u v ψ)`, and needs `IsMonHom ψ`. **I proved that end-to-end, sorry-free and axiom-clean** (`[propext, Classical.choice, Quot.sound]`), which is worth flagging because the `(J ⊗ J)` side-instances of `av_regularMap_isHom_of_zero` do **not** come from `infer_instance`:

```lean
IsReduced J.left                    := Scheme.isReduced_of_smooth_of_isAlgClosed J
IsIntegral (pullback J.hom J.hom)   := Scheme.isIntegral_pullback_self J   -- CodimOneExtension.lean:925, already proved
GeometricallyIrreducible (J ⊗ J).hom := GeometricallyIrreducible.comp _ _   -- Mathlib .../Geometrically/Irreducible.lean:121
```
The `⊗` versions need `show ... (pullback.fst J.hom J.hom ≫ J.hom)` first — bare `infer_instance` on `(J ⊗ J).hom` fails, and `dsimp` alone is not enough. `Scheme.isIntegral_pullback_self` existing already is a real saving; it's exactly the input required.

## (v) On `descentThroughBirationalSigma` specifically

`extend_to_av` (`Albanese/Thm32RationalMapExtension.lean:231`) confirmed unconditional and axiom-clean. Signature:

```lean
theorem extend_to_av {kbar} [Field kbar] [IsAlgClosed kbar]
    {X : Over (Spec (.of kbar))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom] [IsSeparated X.hom]
    [LocallyOfFiniteType X.hom] [IsIntegral X.left] [IsReduced X.left]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : X.left.RationalMap A.left)
    (hover : f.compHom A.hom = X.hom.toRationalMap) :
    ∃! (g : X.left ⟶ A.left), g.toRationalMap = f
```

Two of the three obligations are **verified dischargeable**:

- **All six `X`-side binders on `X := jacobianScheme C`**: I compiled this. They come from `jacobianScheme_smooth`, `jacobianScheme_isProper`, `jacobianScheme_geomIrred` plus `Scheme.isReduced_of_smooth_of_isAlgClosed`, `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, `isIntegral_of_irreducibleSpace_of_isReduced`. No new geometry.
- **`hover`**: also compiled. Given a dense open `V ⊆ J` and `u : V ⟶ A` with `u ≫ A.hom = V.ι ≫ J.hom`, the clean route is `letI : (Scheme.PartialMap.mk V hV u).IsOver (Spec (.of kbar)) := ⟨hu⟩` then `Scheme.RationalMap.isOver_iff.mp inferInstance`. (Going through `PartialMap.toRationalMap_eq_iff` directly hits `homOfLE` type-correctness trouble — use the `IsOver` route.)

**What is genuinely missing is the input, not the invocation.** You must produce the dense open `V ⊆ J` and the morphism `u : V ⟶ A`, i.e. invert `f^{(g)}` on a dense open. That requires:

1. `f^{(g)}` itself (blocked on the bundle and on `abelJacobi`);
2. birationality of `f^{(g)}` — blueprint `lem:symmetric_product_to_jacobian`, which is a *large* chain: `lem:symmetric_product_general_divisor` (Riemann–Roch + Serre duality), `prop:symmetric_product_differentials`, `lem:symmetric_product_tangent_exact`, `lem:jacobian_dimension`, plus the explicit positive-characteristic inseparability exclusion the chapter intro calls out;
3. **an inversion step with no mathlib support at this pin.** No `IsBirational`, no `RationalMap` inverse, no "isomorphism on a dense open ⟹ inverse partial map". You would have to state the birationality data *as* the pair `(U, V, iso)` — which is in fact what the `symmetricPowerToJacobian` docstring already anticipates ("a dense open subset `U ⊆ Sym^g C` mapping isomorphically onto a dense open `V ⊆ Pic⁰`"). Put that in the bundle as a field and the descent becomes a genuine `extend_to_av` invocation; leave it out and no amount of work on this file closes the sorry.

So: your landing makes `descentThroughBirationalSigma` **invocable** — the theorem-application plumbing is verified to work — but the sorry cannot honestly close until the birationality data is either proved (multi-session, Riemann–Roch-dependent) or hypothesised as bundle data. If you hypothesise it, `descentThroughBirationalSigma` closes too, taking the count from 6 sorries to 2 open gates (`abelJacobi`, and the existence of the bundle), which is the honest factoring and a much better state than 6 sorries with a `sorry`-bodied def underneath them.
