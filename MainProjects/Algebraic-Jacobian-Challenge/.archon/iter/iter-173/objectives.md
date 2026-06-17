# Iter-173 prover objectives — detailed lane prompts

## Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean` (CHURNING corrective: helper-budget = 0)

**Required reading (mandatory, in order)**:

1. `analogies/chart-bridge.md` — the iter-173 mathlib-analogist persistent file. The 30-LOC bridge recipe assembling four Mathlib lemmas. The PRIMARY 3 blocker is resolved by this bridge.
2. `blueprint/src/chapters/AbelianVarietyRigidity.tex`, `\subsection*{Scaffolds for the body of $\sigma_\times$}` (L1268–1420) — the four iter-173 blueprint pins.
3. `analogies/gmscaling-deep.md` Q4 — the cocycle ring identity `λ · u = (1/t) · λ`.
4. Iter-172 task result for this file (`.archon/task_results/Genus0BaseObjects.lean.md`) — PRIMARY 1 implementation notes + dead-ends recorded.

### PRIMARY 1 — `gmScalingP1_chart` (L845)

Body shape (analogist-verified, ~10 LOC):

```
(gmScalingP1_cover_X_iso kbar i).hom
  ≫ Spec.map (gmScalingP1_chart_i_ringMap kbar)
  ≫ Spec.map (CommRingCat.ofHom homogeneousLocalizationAwayIso.symm.toRingHom)
  ≫ Proj.awayι (projectiveLineBarGrading kbar) (X i) ...
```

The helper `gmScalingP1_cover_X_iso kbar i` is the new ~12-LOC bridge:

```
def gmScalingP1_cover_X_iso (kbar : Type u) [Field kbar] (i : Fin 2) :
    (gmScalingP1_cover kbar).X i ≅ Spec (.of (TensorProduct kbar (Localization.Away (X i : MvPolynomial ...)) (GmRing kbar))) :=
  pullbackSymmetry _ _ ≪≫
  pullbackRightPullbackFstIso _ _ _ ≪≫
  -- congr along Proj.awayι_toSpecZero (rewrites `Proj.awayι ≫ PLB.hom` as `Spec.map (algebraMap kbar (Away _ _))`)
  ... ≪≫
  pullbackSpecIso kbar _ _
```

Citations from `analogies/chart-bridge.md`:
- `pullbackSymmetry` — `Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback:494`.
- `pullbackRightPullbackFstIso` — `Mathlib.CategoryTheory.Limits.Shapes.Pullback.Pasting:451`.
- `Proj.awayι_toSpecZero` — `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic:209`.
- `pullbackSpecIso` — `Mathlib.AlgebraicGeometry.Pullbacks:702`.

**Mirror Mathlib template** `OpenCover.pullbackCoverAffineRefinementObjIso` (`Mathlib.AlgebraicGeometry.Cover.Open:160`) — same `pullbackSymmetry + pullbackRightPullbackFstIso` pattern.

The `Gm.hom = Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar)))` step is `rfl` (verified by analogist via `gmScheme_canOver` defeq L707-709).

### PRIMARY 2 — `gmScalingP1_over_coherence` (L871)

Body shape (~30 LOC) via `Scheme.Cover.hom_ext`:

```
apply (gmScalingP1_cover kbar).hom_ext
intro i
simp only [Scheme.Cover.ι_glueMorphisms]
-- Now show: gmScalingP1_chart kbar i ≫ ℙ¹.hom = (cover).f i ≫ (PLB ⊗ Gm).hom
-- Each side factors through Spec.map (algebraMap kbar _) — discharge by Spec.map_injective + algebraMap-uniqueness
```

Mechanical once PRIMARY 1 is concrete. Per `Scheme.Cover.hom_ext`: a morphism out of `(cover).glueMorphisms` agrees with a morphism `g` iff their per-chart restrictions to each `cover.X i` agree.

### PRIMARY 3 — `gmScalingP1_chart_agreement` (L855)

Body shape (~40 LOC) cocycle on `D₊(X 0 · X 1)`:

```
intro i j
-- Case i = j: trivial via pullback.condition.
-- Cross case (i = 0, j = 1 or vice versa): reduce to ring identity on D₊(X 0 · X 1):
--   chart-0 sends t ↦ t ⊗ λ⁻¹; chart-1 sends u ↦ u ⊗ λ.
--   On the overlap, t · u = 1, so λ · u = λ · (1/t) = (1/t) · λ — identity in
--   `Localization.Away (X 0 · X 1) ⊗[kbar] GmRing kbar`.
```

Per `analogies/gmscaling-deep.md` Q4 the identity follows from `t · u = 1` in `Localization.Away (X 0 · X 1)`.

### Cleanup directives

- DO NOT introduce new top-level helpers beyond `gmScalingP1_cover_X_iso` (helper-budget = 0 net per progress-critic). The CHURNING corrective forbids "another helper pile". If you find yourself needing a second new top-level helper, STOP and escalate via task_result rather than landing.
- Each PRIMARY must close `axiom-clean` (`{propext, Classical.choice, Quot.sound}` only). If you can only land it with `sorryAx`-propagation through a new buried sorry, leave it as a top-level scaffold sorry instead and document why in the task result.
- Use `lean_verify <decl>` to confirm axiom hygiene after each PRIMARY closes.

### Off-limits in Lane A

- Do NOT attempt `gm_grpObj` (L768) — iter-174 work via `GrpObj.ofRepresentableBy`.
- Do NOT attempt `projGm_isReduced` (L1022) — gated on Lane A chain.
- Do NOT attempt `gmScalingP1_collapse_at_zero` (L912) — gated on PRIMARY 1.

---

## Lane B — `AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW FILE, file-skeleton; verbatim re-dispatch)

**Required reading**:

1. `blueprint/src/chapters/Picard_RelativeSpec.tex` — 6 pinned declarations + Stacks 01LL/01LO/01LS verbatim quotes.
2. Iter-172 task result for Lane B (`.archon/task_results/AlgebraicJacobian_Picard_RelativeSpec.lean.md` — does not exist; iter-172 lane died to API-529 with 0 edits before producing a report).

### Scope (file-skeleton lane — verbatim re-dispatch of iter-172 directive)

Scaffold 6 declarations with `:= sorry` (or `by sorry`) bodies and the correct Mathlib-aligned signatures from the chapter pins:

1. `AlgebraicGeometry.Scheme.QcohAlgebra` (def, ~5 LOC) — the type of quasi-coherent sheaves of `O_X`-algebras. Use Mathlib's `Sheaf` + `AlgebraicGeometry.SheafOfModules` + algebra-structure-on-modules pattern.
2. `AlgebraicGeometry.Scheme.RelativeSpec` (noncomputable def, ~10 LOC) — `RelativeSpec : QcohAlgebra X → Scheme`. Builds the relative spectrum scheme by gluing along an affine open cover of `X`.
3. `AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty` (theorem, ~15 LOC) — natural Hom-bijection `Hom_X(T, RelativeSpec 𝒜) ≃ Hom_{O_X-alg}(𝒜, g_* O_T)`. Express via `CategoryTheory.Functor.RepresentableBy` per chapter L423-425.
4. `AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff` (theorem, ~8 LOC) — Stacks 01LT: when `X = Spec R`, `RelativeSpec 𝒜 ≅ Spec (𝒜(X))` (the affine reduction).
5. `AlgebraicGeometry.Scheme.RelativeSpec.base_change` (theorem, ~10 LOC) — Stacks 01LS: `RelativeSpec` commutes with base change. Form: `f : X' → X` morphism + `𝒜 : QcohAlgebra X` ⇒ `RelativeSpec (f^* 𝒜) ≅ RelativeSpec 𝒜 ×_X X'`.
6. `AlgebraicGeometry.Scheme.RelativeSpec.functor` (def, ~8 LOC) — the functorial action `QcohAlgebra X ⥤ Over X`.

### Imports

`import Mathlib.AlgebraicGeometry.AffineScheme` + `import Mathlib.AlgebraicGeometry.SheafOfModules` (or equivalent qcoh-sheaf imports). Add `namespace AlgebraicGeometry.Scheme`. Match the Mathlib idiom of `Spec`/`RelativeSpec`/Yoneda packaging.

### Umbrella update

Append `import AlgebraicJacobian.Picard.RelativeSpec` to `AlgebraicJacobian.lean`. The umbrella line ordering: place it before `AlgebraicJacobian.RiemannRoch.WeilDivisor` (alphabetical: `Picard` < `RiemannRoch`).

### Build target

`lake build AlgebraicJacobian.Picard.RelativeSpec` must exit 0. The 6 sorry warnings are expected.

### NOT in scope

- Filling any body. Bodies are iter-174+ work.
- The `% SOURCE QUOTE PROOF: TODO` on `thm:relative_spec_univ` (blueprint-reviewer route173 flagged "soon", not blocking) — leave the corresponding Lean body as `sorry`; a future writer will fill the proof quote before the body lane fires.

### Status target

- **COMPLETE**: all 6 stubs scaffold; build green.
- **PARTIAL**: 4-5 stubs scaffold; build green.
- **INCOMPLETE**: <4 stubs OR build red.

---

## Lane D — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (body-fill NARROW SCOPE)

**Required reading**:

1. `.archon/task_results/blueprint-writer-wd-spec-refine.md` — the iter-173 spec-refine report, "Specific instructions for iter-173 prover" section (the explicit prover to-do list with 3 numbered items).
2. `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` `def:prime_divisor` block (post-iter-173 wd-spec-refine landing) — pins the `Order.coheight point = 1` predicate.
3. Iter-172 task result for Lane C (`.archon/task_results/AlgebraicJacobian_RiemannRoch_WeilDivisor.lean.md`) — the file-skeleton landing notes.
4. Iter-172 lean-vs-blueprint-checker `wd172` finding — `PrimeDivisor.isCodim1AndIntegral : True := trivial` is must-fix-this-iter; structurally unsound.

**HARD GATE**: gated on `blueprint-reviewer wd-fastpath173` returning `complete: true` + `correct: true` + no must-fix-this-iter touching the chapter. If that review has not landed when this lane fires, abort with task_result documenting why.

### PRIMARY 1 — PrimeDivisor placeholder repair (L90)

Replace:

```lean
structure Scheme.PrimeDivisor (X : Scheme) where
  point : X
  isCodim1AndIntegral : True := trivial
```

with:

```lean
structure Scheme.PrimeDivisor (X : Scheme) where
  point : X
  coheight : Order.coheight point = 1
```

Per wd-spec-refine writer's recipe. The `point : X` field is preserved (downstream defeq). The new `coheight` field is the substantive codim-1 witness (Mathlib `Order.coheight` from `Mathlib.Order.KrullDimension`; the specialisation preorder `x ≤ y ↔ y ⤳ x` makes the generic point the unique maximal element, so `coheight = 1` captures "codim-1 generic point").

**Closes lean-auditor `iter172` must-fix-this-iter.**

### PRIMARY 2 — `Scheme.WeilDivisor.degree_hom` body (L197)

Replace `:= sorry` with:

```lean
noncomputable def degree_hom {X : Scheme.{u}} : X.WeilDivisor →+ ℤ where
  toFun := degree
  map_zero' := by simp [degree, Finsupp.sum_zero_index]
  map_add' := by
    intro D D'
    simp [degree, Finsupp.sum_add_index]
    -- ring identity: `Σ (n + n') = Σ n + Σ n'`
```

~3-5 LOC; pure `Finsupp` algebra. Independent of the PrimeDivisor repair. Worth landing for the sorry-decrement even if PRIMARY 1 hits surprises.

### NOT ATTEMPTED

- `Scheme.RationalMap.order` (L133) — gated on a DVR-on-`O_{X,η}` extraction (iter-174+).
- `Scheme.WeilDivisor.ofClosedPoint` (L163) — gated on closed-point ↔ prime-divisor bijection (iter-174+).
- `Scheme.WeilDivisor.principal` / `principal_hom` / `principal_degree_zero` — gated on `order` body + RR.2/RR.3 sub-build.

### Status target

- **COMPLETE**: both PRIMARY items close; build green.
- **PARTIAL-acceptable**: PrimeDivisor placeholder repair OR `degree_hom` body closes (the placeholder repair is higher value — it eliminates structural unsoundness in `Scheme.WeilDivisor`).
- **INCOMPLETE**: neither lands.

### Risk caveat

The PrimeDivisor refactor may ripple to the 6 remaining sorry-bodied declarations (their signatures all reference `PrimeDivisor` via the `Y : X.PrimeDivisor` parameter). Test build incrementally; expect 1-2 propagation fixes (e.g. callers passing `⟨point, coheight_proof⟩` rather than `⟨point⟩`). Document any propagation work in the task result.
