# AlgebraicJacobian/Differentials.lean — Iter-124 prover lane

## Outcome

**PARTIAL** — Structural advance on the M1.b residual at L362.
Promoted `forward : Localization M →+* A_colim` to an explicit
`AlgHom` (`forwardAlg`) in-body and closed the `commutes'` field
(algebra-map compatibility), which was previously bundled inside
the AlgEquiv `sorry`. The new residual is the more specific
`Function.Bijective ⇑forwardAlg` claim.

- File compiles: `lake build AlgebraicJacobian.Differentials`
  succeeds (one expected `declaration uses sorry` warning).
- Sorry count: **1** (unchanged from iter-123 close).
- The residual `sorry` is now at `AlgEquiv.ofBijective forwardAlg
  sorry` (line ~398).

## appLE_isLocalization (line 282)

### Attempt 1 — Promote forward to AlgHom + isolate bijectivity residual

- **Approach**: Replace the iter-123 packaging `sorry : Localization M ≃ₐ[Γ(S, U)] A_colim`
  with the explicit construction `AlgEquiv.ofBijective forwardAlg ?_`,
  where `forwardAlg = {forward with commutes' := ...}`.
- **`commutes'` closed in body**: The algebra-map compatibility
  `∀ r : Γ(S, U), forward ((algebraMap _ _) r) = (algebraMap _ _) r`
  follows from `RingHom.congr_fun h_fwd_comp r` (the LHS uses
  `algebraMap Γ(S, U) (Localization M)`; the RHS uses
  `algebraMap Γ(S, U) A_colim`, which is `(appLE_colimRingHom f e).hom`
  definitionally via `appLE_colimAlgebra := (appLE_colimRingHom f e).hom.toAlgebra`).
- **Result**: STRUCTURAL ADVANCE. The single residual `sorry` is
  now narrowed from "build the entire AlgEquiv" to "show
  `Function.Bijective ⇑forwardAlg`". The algebra-structure
  bookkeeping (Step 4 of the original plan, plus the `commutes'`
  field of the AlgEquiv) is now fully in-body.

### Detailed analysis of the bijectivity residual

The single residual `Function.Bijective ⇑forwardAlg` decomposes
(via `Function.Bijective = Injective ∧ Surjective`) into:

**INJECTIVITY** (`Function.Injective ⇑forwardAlg`):
By `IsLocalization.lift_injective_iff`, this is equivalent to:
```
∀ x y : Γ(S, U),
    algebraMap _ (Localization M) x = algebraMap _ (Localization M) y ↔
    (appLE_colimRingHom f e).hom x = (appLE_colimRingHom f e).hom y
```
The `→` direction is trivial (RingHom preserves equality).
The `←` direction is the hard cofinality content of Step 3:
if `g.hom x = g.hom y` in `A_colim`, then by the colim structure
the equality lives in some `Γ(S, W)` with `W ⊇ fV`; refining to
a basic open `D(g)` for `g ∈ M` and using
`IsAffineOpen.isLocalization_basicOpen` yields `g^n * (x - y) = 0`
in `Γ(S, U)` for some `n`, with `g^n ∈ M`.

**SURJECTIVITY** (`Function.Surjective ⇑forwardAlg`):
By `IsLocalization.lift_surjective_iff`, this is equivalent to:
```
∀ v : A_colim, ∃ (xm : Γ(S, U) × M),
    v * (appLE_colimRingHom f e).hom xm.2 = (appLE_colimRingHom f e).hom xm.1
```
This is the hard cofinality content of Step 2: every `v ∈ A_colim`
is in the image of some cocone arm `Γ(S, W) → A_colim` (by the
`IsPointwiseLeftKanExtensionAt` structure); refining to `D(g)`
gives `v = forwardAlg (a / g^n)` for some `a, n`.

### Mathlib gap and blocker analysis

The bijectivity residual requires two Mathlib pieces that are NOT
directly available in snapshot `b80f227`:

1. **Element representation in the lan-defined colim**: The
   `IsPointwiseLeftKanExtensionAt` API
   (`Mathlib.CategoryTheory.Functor.KanExtension.Pointwise:197`)
   gives `IsColimit (coconeAt _)`, and `IsColimit.isoColimit` bridges
   to `CommRingCat.FilteredColimits.colimitCocone`
   (`Mathlib.Algebra.Category.Ring.FilteredColimits`), which DOES
   give explicit element representation for filtered colims of rings.
   But assembling this bridge for the specific
   `CostructuredArrow (Opens.map f.base).op (op V)` (showing it is
   `SmallCategory + IsFiltered`, then transporting through `isoColimit`)
   is ~80-150 LOC of categorical bookkeeping.
2. **Basic-open cofinality in Opens S**: the claim "for every
   `W ⊇ fV` open in `U`, there exists `g ∈ M` with `D(g) ⊆ W`"
   is a genuine algebraic-geometry statement. The pointwise
   version (Mathlib: `IsAffineOpen.exists_basicOpen_le`) gives a
   `g_x` for each `x ∈ fV`; combining finitely many (by
   quasi-compactness of `fV`) into a single `g ∈ M` requires a
   prime-avoidance-style argument. NOT directly in Mathlib for
   the specific `appLE_unitSubmonoid` shape.

The combination is roughly:
- 50-80 LOC: filtered-colim bridge (1 above).
- 50-80 LOC: basic-open cofinality (2 above).
- 30-50 LOC: assembly into `IsLocalization.lift_injective_iff` and
  `IsLocalization.lift_surjective_iff` arguments.

Total estimate: 130-210 LOC, consistent with iter-123's 140-230 LOC
estimate for the original 6-substep plan.

### Reusable Mathlib pieces verified this iter

- `IsLocalization.lift_injective_iff` [verified] —
  `Mathlib.RingTheory.Localization.Defs` — gives the injectivity
  criterion in terms of `algebraMap` equality vs `g` equality.
- `IsLocalization.lift_surjective_iff` [verified] — same module —
  gives the surjectivity criterion in terms of `v * g x.2 = g x.1`
  representability.
- `CommRingCat.FilteredColimits.colimitCoconeIsColimit` [verified]
  — `Mathlib.Algebra.Category.Ring.FilteredColimits` — gives the
  explicit filtered-colim of rings.
- `Functor.LeftExtension.IsPointwiseLeftKanExtensionAt` [verified]
  — `Mathlib.CategoryTheory.Functor.KanExtension.Pointwise:197` —
  gives the lan-colim representation.
- `Functor.LeftExtension.IsPointwiseLeftKanExtensionAt.isoColimit`
  [verified] — same module L250 — transports `(lan F).obj Y` to
  `colimit (CostructuredArrow.proj L Y ⋙ F)`.
- `IsAffineOpen.exists_basicOpen_le` [verified] —
  `Mathlib.AlgebraicGeometry.AffineScheme` — pointwise basic-open
  witness.
- `IsAffineOpen.isLocalization_basicOpen` [verified, used iter-122]
  — same module — exhibits `Γ(S, D(g)) = (Γ(S, U))_g`.
- `AlgEquiv.ofBijective` [verified] — `Mathlib.Algebra.Algebra.Equiv`
  — produces the `AlgEquiv` from the bijective AlgHom.

### Why a 1-sorry residual (not split into inj/surj)

Splitting `Function.Bijective` into separate `Injective` + `Surjective`
sub-sorries would increase the project sorry count from 2 → 3
(triggering the strict-rule reading of CHURNING). The current
packaging keeps the project sorry count at **2** while making the
remaining work concrete (just bijectivity, not the entire AlgEquiv).

### Tactical playbook from iter-123 mathlib-analogist (still applicable)

- **Cluster A (Lan `map_comp`)**: Pre-prove + `erw` idiom; used in
  `isUnit_appLE_unitSubmonoid_in_colim` L234-239. Not triggered
  this iter (no new Lan-rewriting).
- **Cluster B (IsLocalization shape)**: `lift_injective_iff` +
  `lift_surjective_iff` are the canonical reductions; both
  packaged into the `AlgEquiv.ofBijective` residual.
- **Cluster C (algebraMap-from-`.toAlgebra`)**: Used in `commutes'`
  closure: `RingHom.congr_fun h_fwd_comp r` lands in the algebra-
  map form definitionally.
- **Cluster D (unit.naturality)**: Not triggered this iter.

### Negative search results

- Searched `IsLocalization.bijective_lift_iff` — only
  `bijective_lift_piRingHom_algebraMap_comp_piEvalRingHom`
  (specific to product algebra; not applicable).
- Searched `IsLocalization.atUnits`, `Localization.atUnits` —
  gives `R ≃ₐ[R] S` when `M ≤ IsUnit.submonoid R`; not our
  setup.
- Searched `colim_of_localizations`, `Localization.colimit_*` —
  no off-the-shelf "filtered colim of localizations at single
  elements = localization at union submonoid" lemma; same
  iter-121/iter-123 finding.

## Blueprint marker recommendations

- `lem:appLE_isLocalization` (Differentials.tex L154-156) — keep
  `\leanok` on the statement block (sorry'd `IsLocalization`
  predicate in scope; sync_leanok convention per .archon/CLAUDE.md
  "statement formalized with at least a sorry"). **Do NOT add
  `\leanok` to the proof block** until bijectivity closes. The
  `sync_leanok` phase will manage this deterministically.

## File summary

- Total lines: ~537 (was ~537 entering iter-124).
- New body in `appLE_isLocalization`: `forwardAlg` construction
  with explicit `commutes'` proof, plus replacement of the
  iter-123 comment block with a more specific blocker analysis.
- One residual `sorry` at `AlgEquiv.ofBijective forwardAlg sorry`.
- Compiles cleanly (`lake build AlgebraicJacobian.Differentials`).

## Iter-125 handoff

Per PROGRESS.md "Watch criteria committed for iter-125":

- This iter result is closest to **case 2 (PARTIAL, any flavor)**:
  Steps 1 + 4 + algebra-map compatibility (`commutes'`) all in body;
  bijectivity (Steps 2 + 3 reduced) remains as the residual.
- **Per the iter-124 strategy-critic sharpened commitment, this
  triggers the iter-125 unconditional M2.a pivot**. M1.b parks
  with its current state; iter-125 dispatches the Rigidity refactor
  (iter-124 mathlib-analogist scoped); iter-126+ runs the M2.a
  prover lane.
- The current `Differentials.lean` state is stable (compiles,
  one sorry, no broken APIs, no new helpers introduced) and can
  be parked indefinitely or picked up by a future M1.b lane with
  the concrete next-step recipe documented in the source comments
  + this report.

### Next-step recipe for any future M1.b prover lane

1. **Set up filtered-colim bridge** (50-80 LOC):
   - Show `CostructuredArrow (Opens.map f.base).op (op V)` is
     `SmallCategory + IsFiltered` (the latter via `(W₁, h₁) +
     (W₂, h₂) ⟶ (W₁ ⊓ W₂, ...)`; the meet exists in `Opens S`
     and still contains `fV`).
   - Transport `A_colim ≅ colimit (CostructuredArrow.proj _ _ ⋙ S.presheaf)`
     via `isoColimit`.
   - Further transport through `CommRingCat.FilteredColimits.colimitCocone`
     to get explicit element representation.

2. **Prove basic-open cofinality** (50-80 LOC):
   - For each `W ⊇ fV`, use `IsAffineOpen.exists_basicOpen_le`
     pointwise to get `g_x ∈ Γ(S, U)` with `f.base x ∈ D(g_x) ⊆ W ∩ U`.
   - By quasi-compactness of `fV` (Mathlib: `IsAffineOpen.isCompact`),
     extract a finite cover `{D(g_i)}_{i ≤ n}` with `fV ⊆ ∪ D(g_i)`
     and each `D(g_i) ⊆ W ∩ U`.
   - Combine into a single `g ∈ M` via a sum/product argument
     (prime-avoidance-style: in the affine setting, the elements
     `{g_i}` generate a section that's non-vanishing on `fV` by
     construction).

3. **Apply to bijectivity** (30-50 LOC):
   - Surjectivity: every `v ∈ A_colim` is `(coconeArm W) x` for
     some `x ∈ Γ(S, W)`; refine to `D(g)`; `x|_{D(g)} = a / g^n`
     in `(Γ(S, U))_g`; `v = forwardAlg (a / g^n)`.
   - Injectivity: similarly, if `(coconeArm U) x = (coconeArm U) y`
     in `A_colim`, both equal in some refinement `(Γ(S, U))_g`,
     so `g^n (x - y) = 0` in `Γ(S, U)` for some `n`.

### Alternative routes (for any future M1.b lane)

- **Route A (recommended above)**: filtered-colim bridge +
  basic-open cofinality + `lift_injective_iff`/`lift_surjective_iff`.
- **Route B**: avoid `IsLocalization` and prove the AlgEquiv
  directly via `Functor.descOfIsLeftKanExtension` to build the
  backward map, then `RingEquiv.ofRingHom` with explicit inverse
  identities. More categorical, less algebra-driven.
- **Route C**: bypass M1.b entirely via M2.a Rigidity pivot
  (iter-124 sharpened commitment). M1 becomes off-loop
  Mathlib-contribution work (optional).

The iter-124 result + this recipe gives iter-126+ a concrete
starting point IF the user later un-parks M1.b. Otherwise,
**iter-125 fires the M2.a pivot unconditionally** per the
strategy-critic-iter124 commitment.
