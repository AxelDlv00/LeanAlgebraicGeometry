# Iter-166 objectives (detailed per-attempt sidecar)

This sidecar holds the per-attempt detail for the two prover lanes dispatched this iter.
PROGRESS.md `## Current Objectives` carries the canonical lane list; task_pending.md the
file-level state. Use this file for working notes (analogist tips, expected fail modes,
recovery paths) the prover may want.

## Lane 1 — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

### Goal (mathematical)

Land the proof body of `morphism_P1_to_grpScheme_const` (the genus-0 base case headline)
via the iter-164-resolved 𝔾_m-scaling shortcut. Refactor `genusZero_curve_iso_P1` and
`rigidity_genus0_curve_to_grpScheme` to match.

### Signature deltas (proposed; prover may adjust)

```lean
-- BEFORE (iter-165, abstract proxy + scaffold):
theorem morphism_P1_to_grpScheme_const
    [IsAlgClosed kbar]
    (P1 : Over (Spec (.of kbar)))
    [SmoothOfRelativeDimension 1 P1.hom] [IsProper P1.hom] [GeometricallyIrreducible P1.hom]
    (_hgenus : genus P1 = 0)
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : P1 ⟶ A) :
    ∃ a₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ A, f = toUnit P1 ≫ a₀ := sorry

-- AFTER (iter-166, concrete ProjectiveLineBar):
theorem morphism_P1_to_grpScheme_const
    [IsAlgClosed kbar]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : ProjectiveLineBar kbar ⟶ A) :
    ∃ a₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ A,
      f = toUnit (ProjectiveLineBar kbar) ≫ a₀ := by
  -- See proof outline below.
  sorry
```

```lean
-- BEFORE:
theorem genusZero_curve_iso_P1
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0)
    (P1 : Over (Spec (.of kbar)))
    [SmoothOfRelativeDimension 1 P1.hom] [IsProper P1.hom] [GeometricallyIrreducible P1.hom]
    (_hP1genus : genus P1 = 0) :
    Nonempty (C ≅ P1) := sorry

-- AFTER:
theorem genusZero_curve_iso_P1
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0) :
    Nonempty (C ≅ ProjectiveLineBar kbar) := sorry  -- body still RR-gated (iter-167+)
```

```lean
-- The headline (after both above refactors) transports via the iso:
theorem rigidity_genus0_curve_to_grpScheme
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom]
    [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (hgenus : genus C = 0)
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : C ⟶ A)
    (p : 𝟙_ (Over (Spec (.of kbar))) ⟶ C)
    (hf : p ≫ f = η[A]) :
    f = (toUnit C ≫ η[A]) := by
  obtain ⟨φ⟩ := genusZero_curve_iso_P1 hgenus
  -- transport f to f' : ProjectiveLineBar ⟶ A; apply morphism_P1_to_grpScheme_const
  -- to get const a₀; pin a₀ = η[A] via the pointed hypothesis hf.
  sorry
```

### Proof outline for `morphism_P1_to_grpScheme_const` (the load-bearing body)

Blueprint reference: `AbelianVarietyRigidity.tex` L1199-1278 (`prop:morphism_P1_to_AV_constant`).

Let `P := ProjectiveLineBar kbar`, `G := Gm kbar`. Recall the proven Cor 1.5
(`hom_additive_decomp_of_rigidity`, L813) consumes:
- `[IsProper V.hom]`, `[GeometricallyIrreducible (V ⊗ W).hom]`,
  `[LocallyOfFiniteType (V ⊗ W).hom]`, `[IsReduced (V ⊗ W).left]`;
- `[GrpObj A] [IsProper A.hom]`;
- base points `v₀ : 𝟙_ ⟶ V`, `w₀ : 𝟙_ ⟶ W`;
- `h : V ⊗ W ⟶ A` with `hh : lift v₀ w₀ ≫ h = η[A]`.

We instantiate `V := P`, `W := G`, `v₀ := ProjectiveLineBar.zeroPt kbar`,
`w₀ := Gm.onePt kbar`. The `(V ⊗ W)` instances must synthesise — they should follow from
the per-factor instances of `Genus0BaseObjects` (via product-instance lemmas; if Mathlib
doesn't auto-infer them on `Over (Spec k̄)`, may need explicit `instance` declarations on
`ProjectiveLineBar ⊗ Gm` in `Genus0BaseObjects.lean` or AVR.lean — Lane 2 add-on if needed).

Proof body (mathematically; the prover writes the Lean tactic / term):

1. **Normalise the value at `0`.** Let `a₀ := ProjectiveLineBar.zeroPt kbar ≫ f`. The
   claim `∃ a₀, f = toUnit ≫ a₀` is witnessed by this `a₀` (in particular, we have to
   show `f = toUnit P ≫ a₀`).

2. **Translate to `f' = f - a₀`** (mapping `0 ∈ P` to `η[A] ∈ A`). Using `GrpObj A`,
   form `f' := f / (toUnit P ≫ a₀)` (in the `Hom(P, A)` group). Then
   `ProjectiveLineBar.zeroPt kbar ≫ f' = a₀ / a₀ = η[A]`.

3. **Form `h := gmScalingP1 kbar ≫ f' : P ⊗ G ⟶ A`.**

4. **Discharge the `hh` hypothesis for Cor 1.5.** We need
   `lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar) ≫ h = η[A]`. Rewrite:
   ```
   lift zeroPt onePt ≫ gmScalingP1 ≫ f' = (lift zeroPt onePt ≫ gmScalingP1) ≫ f'
   ```
   To simplify `lift zeroPt onePt ≫ gmScalingP1`, note that the load-bearing lemma is
   `gmScalingP1_collapse_at_zero`:
   ```
   lift (toUnit Gm ≫ ProjectiveLineBar.zeroPt) (𝟙 Gm) ≫ gmScalingP1
     = toUnit Gm ≫ ProjectiveLineBar.zeroPt
   ```
   The RHS is the "`σ_×(0, λ) = 0`" identity ON `Gm`. To get the version
   `lift zeroPt onePt ≫ gmScalingP1 = zeroPt`, precompose the lemma with
   `onePt : 𝟙_ ⟶ Gm`:
   ```
   onePt ≫ (lift (toUnit Gm ≫ zeroPt) (𝟙 Gm)) ≫ gmScalingP1
     = onePt ≫ (toUnit Gm ≫ zeroPt)
   ```
   The LHS, by `comp_lift` + `toUnit_unique`-style simplification + `Category.id_comp`,
   should reduce to `lift zeroPt onePt ≫ gmScalingP1`. The RHS is `(onePt ≫ toUnit Gm) ≫
   zeroPt = (𝟙 _) ≫ zeroPt = zeroPt`. (Compare the parallel `hwsW` / `hvsV` calculations
   inside the `hom_additive_decomp_of_rigidity` body, L834-843.)

   So `lift zeroPt onePt ≫ gmScalingP1 = zeroPt`. Composing with `f'`:
   `lift zeroPt onePt ≫ h = zeroPt ≫ f' = η[A]` (from step 2).

5. **Apply Cor 1.5.** Get
   ```
   h = (fst P G ≫ f_V) * (snd P G ≫ f_W)
   ```
   where `f_V := lift (𝟙 P) (toUnit P ≫ onePt) ≫ h` and
   `f_W := lift (toUnit G ≫ zeroPt) (𝟙 G) ≫ h`.

6. **The `W`-axis collapses (the load-bearing scaling fixed point).**
   `f_W = lift (toUnit G ≫ zeroPt) (𝟙 G) ≫ gmScalingP1 ≫ f'`. By
   `gmScalingP1_collapse_at_zero`,
   `lift (toUnit G ≫ zeroPt) (𝟙 G) ≫ gmScalingP1 = toUnit G ≫ zeroPt`. So
   `f_W = toUnit G ≫ zeroPt ≫ f' = toUnit G ≫ η[A] = 1` (the hom-group identity in
   `Hom(G, A)`, via `Hom.one_def` + `toUnit_unique`).

7. **Hence `h = pr_1 ≫ f_V`**, i.e.\
   `gmScalingP1 ≫ f' = fst P G ≫ f_V`. Specialising at `(x, 1) ∈ P × G`
   (precomposing with `lift (𝟙 P) (toUnit P ≫ onePt) : P ⟶ P ⊗ G`): the LHS is
   `f_V` itself; the RHS is also `f_V`. (This consistency check is automatic.)

   Specialising at `(1, λ) ∈ P × G` (precomposing with
   `lift (toUnit G ≫ onePt) (𝟙 G) : G ⟶ P ⊗ G`):
   ```
   lift (toUnit G ≫ onePt) (𝟙 G) ≫ gmScalingP1 ≫ f'
     = lift (toUnit G ≫ onePt) (𝟙 G) ≫ fst P G ≫ f_V
     = (toUnit G ≫ onePt) ≫ f_V
   ```
   Here the LHS is "`f'|_{Gm}` after the `σ_×(1, λ) = λ` identity" — i.e. `Gm.hom ↪
   ProjectiveLineBar` composed with `f'`. The RHS is "constant at `onePt ≫ f_V`".
   So `f'|_{Gm}` is the constant morphism at `onePt ≫ f_V`. (You may need an
   intermediate `gmScalingP1_at_one` lemma — i.e., `σ_×(x, 1) = x` — if the unit-law
   of the `Gm` action doesn't simplify by `simp`.)

8. **Density.** `Gm ↪ ProjectiveLineBar` is an open immersion with dense image
   (`𝔾_m` is `ℙ¹ ∖ {0, ∞}`, complement of finitely many `k̄`-points, hence dense in the
   irreducible `ℙ¹`). `A` is separated (`[IsProper A.hom]` + Mathlib's
   `IsSeparated A.hom`-from-`IsProper`). Apply `Scheme.Over.ext_of_eqOnOpen`
   (proven, `Rigidity.lean`) to upgrade `f'|_{Gm} = const` to `f' = const` on all of
   `ProjectiveLineBar`.

   **API check:** `ext_of_eqOnOpen`'s signature (from Rigidity.lean) is the
   `eq_of_eqOnOpen` pattern — confirm it accepts the `Gm ↪ ProjectiveLineBar` open
   immersion. If the API needs a `IsDominant` / `IsDenseImmersion` instance on `Gm.hom`
   composed with `ProjectiveLineBar.hom`-relative containment, may need a helper lemma
   landing the dense-image property — could be a Lane 2 add-on.

9. **Un-translate.** `f' = toUnit P ≫ η[A]` means `f / (toUnit P ≫ a₀) = toUnit P ≫
   η[A]`, equivalently `f = toUnit P ≫ a₀` (using `Hom`-group operations and
   `MonObj.one_mul`-style cancellation).

10. **Witness.** Return `⟨a₀, by …⟩`.

### Expected fail modes (with cheapest recovery)

1. **Cor 1.5's product instance synthesis fails on `ProjectiveLineBar ⊗ Gm`.** The
   `(V ⊗ W).hom`-side typeclasses (`GeometricallyIrreducible`, `LocallyOfFiniteType`,
   `IsReduced`) may not auto-infer. **Recovery:** add explicit
   `instance` declarations for `ProjectiveLineBar ⊗ Gm` in `Genus0BaseObjects.lean`
   (Lane 2 add-on); these are routine product-instance lemmas.
2. **`gmScalingP1_collapse_at_zero` shape doesn't unify with Cor 1.5's `_hf`
   precompositional rewriting.** **Recovery:** insert a small intermediate lemma
   stating `lift zeroPt onePt ≫ gmScalingP1 = zeroPt` (or massage the existing
   collapse-lemma's RHS by `comp_lift`/`toUnit_unique`); flag and adjust in Lane 1.
3. **`ext_of_eqOnOpen` API mismatch with the `Gm ↪ ℙ¹` density.** **Recovery:** add a
   helper lemma `gm_dense_in_P1 : IsDenseOpenImmersion (Gm.hom)` or its `IsDominant`
   analogue (the density is concrete — `ℙ¹ ∖ {0, ∞}` is open dense). This may be a
   Lane 2 add-on if `ext_of_eqOnOpen` needs a specific instance shape.

## Lane 2 — `AlgebraicJacobian/Genus0BaseObjects.lean`

### Goal (mathematical)

Close 7 live-consumer scaffold sorries; optionally close 2 sub-build sorries
(`projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`) and the off-path
`ga_grpObj`.

### `gm_grpObj` body (L329) — THE most novel installer

```lean
instance gm_grpObj (kbar : Type u) [Field kbar] : GrpObj (Gm kbar) := sorry
```

Strategy (per analogist `gm-scaling-p1`):
- `GrpObj.ofRepresentableBy` (Mathlib `CategoryTheory.Monoidal.Cartesian.Grp_:35`) takes
  a representable-by witness `RepresentableBy F X` for a functor `F : Cᵒᵖ ⥤ GrpCat`
  yielding `GrpObj X`.
- `F := T ↦ GrpCat.of Γ(T.left, ⊤)ˣ` (the units functor — over `Over (Spec k̄)`).
- The `RepresentableBy` witness: morphisms `T ⟶ Gm` in `Over (Spec k̄)` ↔ units in
  `Γ(T.left, ⊤)`. This is the standard "morphism into `Spec (Localization.Away t)` ↔
  unit in global sections" bijection (Mathlib's `AffineScheme`-level Yoneda for the
  Spec / global-sections adjunction restricted to localizations). Citations to chase:
  `Mathlib.AlgebraicGeometry.AffineScheme:632/651/666`, `IsLocalization.Away`
  identifications.
- Naturality: morphism-composition on the scheme side corresponds to multiplication
  of units; the structure-fields of `GrpCat.of _ˣ` (mul, one, inv) match the structure
  fields of `GrpObj`-via-functor exactly.

If this turns out to be a hard installer (representable-by + functor-of-groups
naturality is multi-step), the prover may PARTIAL it and surface the blocker for an
iter-167 mathlib-analogist (cross-domain) on `ofRepresentableBy` usage patterns.

### `gmScalingP1` body (L366) — the load-bearing morphism

Use `AlgebraicGeometry.Scheme.Cover.glueMorphisms` over a two-chart cover of
`ProjectiveLineBar ⊗ Gm`:

- Chart 1: `D₊(X₀) × Gm`, where `D₊(X₀) ⊆ Proj` is the open `Proj.awayι ((X₀ : MvPolynomial (Fin 2) k̄))`-image (= `𝔸¹`); on this chart, `(t, λ) ↦ λt` (`Spec.map` of the ring hom `k̄[t, λ, λ⁻¹] →+* k̄[t, λ, λ⁻¹]`, `t ↦ λ·t`).
- Chart 2: `D₊(X₁) × Gm`, where the coordinate `u = 1/t`; on this chart, `(u, λ) ↦ u/λ` (`Spec.map` of `u ↦ u·λ⁻¹`).
- Agreement on overlap `D₊(X₀X₁) × Gm = 𝔾_m × Gm` (`k̄[t, t⁻¹, λ, λ⁻¹]`): both restrictions send `(t, λ) ↦ (λt, λ)`-target which is `λt` in `D₊(X₀)`-coords and `u = 1/(λt) = u/λ` in `D₊(X₁)`-coords; the ring-level computation `(λ·t)·λ⁻¹ = t·1 = t` checks the descent.

The agreement check is the hard part; the chart-restrictions themselves are explicit
`Spec.map (CommRingCat.ofHom <ring-hom>)`.

### `gmScalingP1_collapse_at_zero` body (L381)

Once `gmScalingP1` and `ProjectiveLineBar.zeroPt` are concrete, this reduces to a
chart-level computation: `gmScalingP1` restricted along
`zeroPt ⊗ 𝟙 : 𝟙_ ⊗ Gm = Gm ⟶ ProjectiveLineBar ⊗ Gm` lands in the `D₊(X₀)` chart
(since `zeroPt = [0 : 1] ∈ D₊(X₀)`); on that chart, `(0, λ) ↦ λ · 0 = 0 = zeroPt`.

Concretely: the equation `lift (toUnit ≫ zeroPt) (𝟙 _) ≫ gmScalingP1 = toUnit ≫ zeroPt`
is `Spec.map`-of a ring-hom equation `(t ↦ λ · 0 = 0)` on `Γ(D₊(X₀) × Gm) = k̄[t, λ, λ⁻¹]`.
Should close by `Scheme.Over.ext` + explicit chart-restriction + ring-level computation.

### `ProjectiveLineBar.{zeroPt, onePt, inftyPt}` bodies (L199/L204/L209)

Each is a morphism `𝟙_ ⟶ ProjectiveLineBar kbar`. Construct as the composite:
- the `Proj.awayι` open immersion `D₊(X_i) ⟶ ProjectiveLineBar` (chart embedding);
- precomposed by `Spec.map` of the evaluation `k̄[t] →+* k̄`, `t ↦ 0` (or `1`, or
  `u ↦ 0` for `∞`) — i.e. the `k̄`-point of `𝔸¹` given by the augmentation ideal at `0`/`1`/`0`.

Concretely, `zeroPt := (the morphism 𝟙_ → 𝔸¹ = Spec k̄[t] at "t = 0") ≫ awayι(X₀)`;
similarly for `onePt`, `inftyPt`.

### `Gm.onePt` (L340) — already defined; verify

```lean
def Gm.onePt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ Gm kbar :=
  η[Gm kbar]
```

This is the group-unit of `Gm kbar` (under `gm_grpObj`); should land as soon as
`gm_grpObj` closes. No separate work.

### `projectiveLineBar_geomIrred` / `projectiveLineBar_smoothOfRelDim` (L175 / L182)

Sub-builds Mathlib does not ship for `Proj`. **Recommended approach:**
- For smoothness: transport across the two-chart cover; each chart is `𝔸¹`, which is
  `SmoothOfRelativeDimension 1` (Mathlib `AffineSpace`-instance). Need a "smoothness is
  local on the target" or "smoothness is local on the source" instance to assemble.
- For geom irred: `Proj` of an integral graded ring is integral; the `MvPolynomial
  (Fin 2) k̄` is a domain. Geometric irreducibility over `k̄` (algebraically closed)
  follows from irreducibility (no further extension to perfect).

If either takes >100 LOC, leave as `sorry` and PARTIAL the lane.

### `ga_grpObj` (L264) — OFF-PATH (optional)

Same shape as `gm_grpObj` but with `AddGrpCat` and `AffineSpace.homOverEquiv` as the
representable-by witness. Close if convenient.

## Notes / handoff

- Both lanes are file-disjoint; Lane 1 imports Lane 2 (so Lane 1 can sit on Lane 2's
  signatures landed iter-165).
- The blueprint chapter `AbelianVarietyRigidity.tex` is HARD-GATE cleared (iter-164);
  no chapter edits required by either lane.
- `sync_leanok` will refresh `\leanok` markers automatically after the prover phase.
