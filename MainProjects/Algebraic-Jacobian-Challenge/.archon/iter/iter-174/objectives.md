# Iter-174 — prover objectives (detailed)

## Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean` (continuation, CHURNING corrective)

### Blueprint
`chapters/AbelianVarietyRigidity.tex` (covers G0BO via `% archon:covers`; HARD GATE CLEARS via iter-173 `blueprint-reviewer avr-fastpath173`).

### Required reading
- `analogies/chart-bridge.md` (iter-173 chart-bridge recipe).
- `analogies/chart-bridge-shared-helper.md` (iter-174 mathlib-analogist consult; READ FIRST — landed plan-phase).

### Hard scope-discipline (per progress-critic CHURNING corrective)

Close EXACTLY 2 sorries this iter. **Do NOT attack any other sorries on this file.** Specifically:

1. **`gmScalingP1_chart_agreement`** (currently L944, post-refactor location: ~L944 in current file). The chart-cocycle `∀ x y, pullback.fst (cover.f x) (cover.f y) ≫ chart x = pullback.snd _ _ ≫ chart y`.

2. **`gmScalingP1_over_coherence`** (currently L961). The over-coherence `(cover).glueMorphisms chart agreement ≫ ProjectiveLineBar.hom = (ProjectiveLineBar ⊗ Gm).hom`.

### Strategy (refined by `mathlib-analogist chart-bridge-shared-helper` iter-174 consult)

The iter-173 "single shared helper closes BOTH `over_coherence` + `chart_agreement`" framing is **WRONG**. Per the analogist's `analogies/chart-bridge-shared-helper.md`, the lane splits into TWO sub-tasks:

#### Sub-task A — `gmScalingP1_over_coherence` (CLOSEABLE axiom-clean iter-174)

Land the shared helper

```lean
private lemma gmScalingP1_chart_PLB_eq (kbar : Type u) [Field kbar] [IsAlgClosed kbar]
    (i : Fin 2) :
    gmScalingP1_chart kbar i ≫ ProjectiveLineBarScheme kbar.hom =
    (gmScalingP1_cover kbar).f i ≫ (pullback.fst ProjectiveLineBar.hom Gm.hom)
      ≫ Spec.map (algebraMap kbar Away_i)
```

bundling 4 sub-pieces (per analogist Decision 3):
- (a) kbar-algebra preservation of `homogeneousLocalizationAwayIso`: NEW project-side sub-lemma `homogeneousLocalizationAwayIso_algebraMap` (~5-10 LOC) showing `(homogeneousLocalizationAwayIso kbar i).toRingHom.comp (algebraMap kbar (𝒜 0)) = algebraMap kbar (Away (X i))`. Derivable via `Localization.awayLift` + `chartEvalRingHom`'s action on constants (`C r ↦ C r`).
- (b) bridge-structure: use `AlgebraicGeometry.pullbackSpecIso_hom_base` (NOT `_hom_fst`) — the canonical bridge `pullbackSpecIso.hom ≫ Spec.map (algMap R (S ⊗[R] T)) = pullback.fst _ _ ≫ Spec.map (algMap R S)`.
- (c) per-cover `pullback.condition` chain (`pullbackSymmetry_hom_comp_fst`, `pullbackRightPullbackFstIso_hom_fst`, `pullback.congrHom_hom`).
- (d) reuse `awayι_comp_PLB_hom` from iter-173.

Then close `over_coherence` via `Cover.hom_ext` + `ι_glueMorphisms_assoc` + per-`i` application of the helper. ~30-40 LOC total.

#### Sub-task B — `gmScalingP1_chart_agreement` (PARTIAL closeable iter-174)

Cocycle agreement is content-specific; cannot share the helper directly. Per analogist split:
- **Diagonal cases** (`x = y` for `(0,0)` and `(1,1)`): close via `CategoryTheory.Limits.fst_eq_snd_of_mono_eq` since each `(cover).f i` is an open immersion, hence `Mono`. ~1-2 LOC each.
- **Cross cases** (`(0,1)` and `(1,0)`): require the ring identity `λ · u = (1/t) · λ` in `Localization.Away (X 0 · X 1) ⊗[kbar] GmRing` per `analogies/gmscaling-deep.md` Q4. ~30-40 LOC per cross case OR honest deferral to iter-175.

**iter-174 acceptance**: close Sub-task A axiom-clean AND close diagonal cases of Sub-task B. Defer cross cases to iter-175 if needed.

### Helper budget

- Up to 2 new private helpers: `gmScalingP1_chart_PLB_eq` (Sub-task A) + `homogeneousLocalizationAwayIso_algebraMap` (the kbar-algebra preservation sub-lemma).
- Do NOT add new top-level declarations.
- Do NOT modify any existing axiom-clean declaration.

### Status target (per analogist split)

- **COMPLETE**: Sub-task A (`over_coherence`) + Sub-task B diagonal cases closed axiom-clean; cross cases either closed or DEFERRED to iter-175. File sorry count: 8 → 6 if cross cases close; 8 → 7 if cross cases deferred. **COMPLETE accepts either outcome on cross cases per analogist's "deferrable to iter-175" framing.**
- **PARTIAL-acceptable**: Sub-task A closed (axiom-clean); Sub-task B left as scaffold with diagonal cases attempted but not closed.
- **PARTIAL-low**: Sub-task A only attempted but not closed. **iter-175 will escalate to STUCK + structural-refactor** per progress-critic corrective.
- **INCOMPLETE**: 0 closed. Trigger fires for analogist-recommended structural refactor in iter-175 plan-phase.

---

## Lane D — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (continuation, NARROW SCOPE)

### Blueprint
`chapters/RiemannRoch_WeilDivisor.tex` (HARD GATE PASS verified iter-173 `blueprint-reviewer wd-fastpath173`; cleared `lean-vs-blueprint-checker wd173`).

### Required reading
- The chapter's `def:divisor_closed_point` block (chapter L330-L340 area) for the bijection sketch.
- iter-173 task result on the prior `ofClosedPoint` placeholder rationale (per `lean-auditor iter173`).

### Scope (PRIMARY)

**`Scheme.WeilDivisor.ofClosedPoint`** (L171). Build the Weil divisor `1 · P ∈ Div(C)` from a closed point `P ∈ C` (with `IsClosed ({P} : Set C)` hypothesis).

The closed-point ↔ prime-divisor bridge: given `IsClosed ({P})` plus an `IsIntegral C` typeclass and `dim C = 1`, the closure `{P}̄` is an integral 1-codimensional closed subset, hence its generic point gives `Order.coheight = 1`. Construct `Scheme.PrimeDivisor` from this data, then `Finsupp.single` to land `WeilDivisor`.

### Helper budget

Up to 1 new private bridge lemma (e.g. `closedPoint_isPrimeDivisor` packaging the coheight computation). No structural changes.

### Status target

- **COMPLETE**: `ofClosedPoint` body closed. File sorry count 5 → 4.
- **PARTIAL-acceptable**: any partial progress on the coheight bridge that compiles.
- **INCOMPLETE**: defer.

### NOT attempted

`Scheme.RationalMap.order` (L141) — gated on DVR extraction (iter-175+).
`Scheme.WeilDivisor.principal` / `principal_hom` / `principal_degree_zero` — gated on `order`.

---

## Lane E — `AlgebraicJacobian/Picard/LineBundlePullback.lean` (NEW FILE — file-skeleton scaffold)

### Blueprint
`chapters/Picard_LineBundlePullback.tex` (NEW iter-173 — Kleiman §2 verbatim quotes; 5 pins).

HARD GATE: pending scoped fast-path review THIS iter (will be dispatched after writers + refactors return). If review fails, Lane E defers.

### Scope

Scaffold all 5 pinned declarations as `sorry`-bodied stubs:
- `AlgebraicGeometry.Scheme.lineBundlePullback` — pullback of a line bundle along `C ×_k T → C`.
- (4 other pins from the chapter — to be verified)

Add:
- Imports (Mathlib `AlgebraicGeometry.Sheaves.Pullback` family).
- `namespace AlgebraicGeometry.Scheme`.
- Update `AlgebraicJacobian.lean` umbrella to `import AlgebraicJacobian.Picard.LineBundlePullback`.

### Build verification

`lake build AlgebraicJacobian.Picard.LineBundlePullback` → exit 0.
`lake build AlgebraicJacobian` → exit 0.

### Out of scope

- Filling any body. Bodies are iter-175+ work.
- Anti-pattern: NO `Iso.refl`-tautology bodies; NO `True := trivial` placeholders. Each `sorry` must carry the **intended substantive type signature** so the type itself encodes the claim.

### Status target

- **COMPLETE**: all 5 stubs scaffold; build green.
- **PARTIAL**: 3-4 stubs scaffold.
- **INCOMPLETE**: <3 stubs OR build red.

---

## Lane F — `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (NEW FILE — file-skeleton scaffold)

### Blueprint
`chapters/RiemannRoch_RRFormula.tex` (NEW iter-173 — Hartshorne IV.1 verbatim; 4 pins).

HARD GATE: same as Lane E.

### Scope

Scaffold all 4 pinned declarations as `sorry`-bodied stubs:
- `AlgebraicGeometry.Scheme.eulerCharacteristic`
- `AlgebraicGeometry.Scheme.riemannRochFormula`
- (2 other pins from the chapter — to be verified)

Add imports + namespace + umbrella update analogous to Lane E.

### Status target

Same form as Lane E (COMPLETE: 4/4; PARTIAL: 2-3; INCOMPLETE: <2 or red).

---

## Lane G — `AlgebraicJacobian/Picard/RelativeSpec.lean` (NARROW SCOPE: `QcohAlgebra` carrier)

### Status: GO (analogist returned a concrete recipe)

`mathlib-analogist qcohalgebra-structure` returned **Encoding I** (sheafified `Under`-object form) — see `analogies/qcohalgebra-structure.md`.

### Blueprint
`chapters/Picard_RelativeSpec.tex` (LANDED iter-172; HARD GATE CLEARS via iter-172 plan-phase scoped review).

### Scope (NARROW)

Replace the TYPE-level `noncomputable def Scheme.QcohAlgebra (X : Scheme.{u}) : Type (u+1) := sorry` (L98) with the analogist-recommended bundled structure (Encoding I):

```lean
structure Scheme.QcohAlgebra (X : Scheme.{u}) where
  sheaf : TopCat.Sheaf CommRingCat X
  unit : X.sheaf ⟶ sheaf
  isQcoh : IsQuasicoherent toQcohModule  -- or equivalent Mathlib predicate
```

This is a direct sheaf upgrade of Mathlib's `Mathlib/Algebra/Category/Ring/Under/Basic.lean:13-18` "Under R ≅ commutative R-algebras" idiom.

### Out of scope this lane

- Filling bodies of `RelativeSpec`, `UniversalProperty`, `affine_base_iff`, `base_change` (iter-175+).
- Upgrading `UniversalProperty` to `Functor.RepresentableBy` (iter-175+).
- Refining `structureMorphism` body (iter-175+ — gated on `RelativeSpec` body).

### Helper budget

- Up to 2 new private helpers (e.g. `toQcohModule` accessor + `IsQuasicoherent` predicate if Mathlib lacks).
- The 5 downstream `sorry`s that depend on `QcohAlgebra` (`RelativeSpec`, `structureMorphism`, `UniversalProperty`, `affine_base_iff`, `base_change`) STAY as scaffold sorries (their types now reference the concrete `QcohAlgebra` structure, not the type-level placeholder — they're typed-against-Encoding-I).

### Status target

- **COMPLETE**: `QcohAlgebra` carrier replaced with the Encoding I structure; build green; the 5 downstream sorries now reference the concrete carrier (no semantic regression).
- **PARTIAL-acceptable**: carrier structured but one downstream `sorry` needed a type-level adjustment.
- **INCOMPLETE**: carrier still `:= sorry`. defer to iter-175.

### Required reading
- `analogies/qcohalgebra-structure.md` (analogist persistent file).
- Blueprint chapter `Picard_RelativeSpec.tex` for the universal property's intended `Hom_{O_X-alg}(𝒜, g_* O_T)` shape.
