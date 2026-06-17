# AlgebraicJacobian/RiemannRoch/OCofP.lean — iter-183 Lane A

## Outcome

**PARTIAL** — sig amend landed + concrete `carrierSet` substantive scaffold.
**Sorry count: 7 (NO REGRESSION; target ≤ 7 hit; ≤ 6 strong target NOT hit).**

The lane fired the directive's priority-1 action (sig amend
`lineBundleAtClosedPoint` to add `(hPcoh : Order.coheight P = 1)` plus
threading through `toFunctionField` and all downstream consumers) and
added a substantive `carrierSet` scaffold (Hartshorne subsheaf-of-`K_C`
direct construction, concrete `Set`-valued; analogist
`ocofp-sheaf-internalhom.md` Decision 3 recipe). The `Submodule`
upgrade and the presheaf/sheaf assembly were deferred to iter-184+
because the budget ceiling (`sorry count ≤ 7`) blocks scaffold sorries
under the current Mathlib gap (non-archimedean inequality
`Ring.ordFrac_add` requires `[IsDiscreteValuationRing]`, which the
`KrullDimLE 1` regime does NOT provide).

## Sig amend (priority 1 of directive)

### `lineBundleAtClosedPoint` (L154)

```
noncomputable def lineBundleAtClosedPoint
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (_P : C.left) (_hP : IsClosed ({_P} : Set C.left))
    (_hPcoh : Order.coheight _P = 1) :     -- ★ NEW
    Sheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar) :=
  sorry
```

### `toFunctionField` (L174)

Similarly amended to take `(hPcoh : Order.coheight P = 1)` after `hP`.
Body still typed `sorry`.

### Consumer ripple

All consumers in the file (`globalSections_iff_mp`, `globalSections_iff_mpr`,
`globalSections_iff`, `h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`,
`exists_nonconstant_genusZero`) were amended to either pass through
`hPcoh` to `lineBundleAtClosedPoint`/`toFunctionField` calls, or to take
`hPcoh` themselves (added to `h1_vanishing_genusZero` and
`dim_eq_two_of_genusZero` which previously didn't have it). The
`exists_nonconstant_genusZero` already had `hPcoh` in scope.

### Verification

- File compiles green: 7 sorry warnings, 0 errors.
- No new project axioms (zero-axiom build retained).
- Sig amend verified safe via grep: no other Lean file imports
  `lineBundleAtClosedPoint` (only OCofP.lean itself).
- `lineBundleAtClosedPoint` NOT in `archon-protected.yaml` — sig amend
  permitted.

## Substantive scaffold landed (iter-183 contribution beyond sig amend)

### `Scheme.lineBundleAtClosedPoint.carrierSet` (L143, concrete `Set` def)

The per-open Hartshorne subsheaf-of-`K_C` carrier: the set of rational
functions `f ∈ K(C)` satisfying the order conditions
`ord_Q(f) ≥ 0` for every prime divisor `Q ≠ P` with `Q.point ∈ U`,
and `ord_P(f) ≥ -1` when `P ∈ U`.

```
private noncomputable def lineBundleAtClosedPoint.carrierSet
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1)
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    Set C.left.functionField := by
  let Phat : C.left.PrimeDivisor := ⟨P, hPcoh⟩
  haveI : Ring.KrullDimLE 1 (C.left.presheaf.stalk Phat.point) :=
    Scheme.IsRegularInCodimensionOne.out Phat
  exact { f | (∀ Q : C.left.PrimeDivisor, Q.point ∈ U.unop.1 → Q.point ≠ P →
              0 ≤ Scheme.RationalMap.order Q f) ∧
              (P ∈ U.unop.1 → (-1 : ℤ) ≤ Scheme.RationalMap.order Phat f) }
```

**TOOLING TRAP**: the obvious term form
```
{ f | ... ∧ (P ∈ U.unop.1 → (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f) }
```
fails with `failed to synthesize instance of type class Ring.KrullDimLE 1
(C.left.presheaf.stalk { point := P, coheight := hPcoh }.point)`. Lean's
instance synthesis does NOT reduce the structure projection
`⟨P, hPcoh⟩.point ⇝ P` during typeclass search; the `IsRegularInCodimensionOne`
instance (which has `Y : PrimeDivisor X` explicit) requires Lean to
unify `Y.point` against the goal, which fails on the unreduced literal.

**Workaround that landed**: use `by ... exact` and let-bind
`Phat : C.left.PrimeDivisor := ⟨P, hPcoh⟩`, then `haveI` the
`Ring.KrullDimLE 1` instance manually via `Scheme.IsRegularInCodimensionOne.out
Phat`. The `exact` block then references `Phat` (named, instance fires).

### `Scheme.lineBundleAtClosedPoint.carrierSet_mono` (L181, substantive monotonicity)

The carrierSet is monotone in `U`: for `V.unop ⊆ U.unop`,
`carrierSet U ⊆ carrierSet V` (smaller open ⇒ fewer order conditions
⇒ larger carrier). Proof is 2 lines: `refine ⟨fun Q hQV hQP => hf.1 Q
(hUV hQV) hQP, fun hPV => hf.2 (hUV hPV)⟩`. No sorry.

This is the substantive monotonicity that the iter-184+ presheaf
restriction map will consume: an arrow `U ⟶ V` in `(Opens C.left)ᵒᵖ`
corresponds to `V.unop ⊆ U.unop`, and the (identity-on-`K(C)`)
restriction `carrierSet U → carrierSet V` is the inclusion of this
lemma.

## Why no Submodule upgrade this iter

The directive recipe (`analogies/ocofp-sheaf-internalhom.md` L155-203)
shows the Submodule construction with 3 closure proof sorries:

```
{ carrier := { f | ... }
  zero_mem' := by … (order of 0 is +∞)
  add_mem' := by … (order is super-additive / non-archimedean)
  smul_mem' := by … (k̄-scalar doesn't change orders at prime divisors) }
```

Of these:

- `zero_mem'` IS provable (5 LOC: `unfold Scheme.RationalMap.order;
  rw [map_zero, WithZero.log_zero]`; verified by `lean_multi_attempt`).
  No sorry.

- `add_mem'` REQUIRES the non-archimedean inequality
  `min (ordFrac x) (ordFrac y) ≤ ordFrac (x + y)`. Mathlib's
  `Ring.ordFrac_add` (`Mathlib.RingTheory.OrderOfVanishing.Noetherian`)
  ONLY provides this under `[IsDiscreteValuationRing R]`; under the
  weaker `[Ring.KrullDimLE 1 R]` (what `IsRegularInCodimensionOne`
  provides), the lemma does NOT exist in Mathlib. **Mathlib gap**:
  the `ordFrac_add` for `KrullDimLE 1` is a non-trivial extension
  (the `ordFrac` in this regime uses an aggregated valuation across
  height-1 primes — non-archimedean inequality is per-prime, and
  the aggregation respects `min`).

- `smul_mem'` requires `ord_Q (algebraMap kbar K(C) c) = 0` for
  `c ∈ kbar^×` (constant scalars are units in the local ring at every
  prime divisor). Provable via `Ring.ordFrac_of_isUnit` + the
  embedding `kbar^× ↪ O_{C,Q}^×` for any prime divisor `Q`, but
  ~20-30 LOC of substantive work.

**Sorry budget**: the directive's critic mandate is `sorry count ≤ 7
(no regression); ≤ 6 strong; ≤ 5 stretch. If sorry count goes ≥ 8,
iter-184 escalates to structural refactor.` Adding the Submodule
with 3 inline sorries (zero_mem if not proven; add_mem; smul_mem)
plus a typed sorry for the isSheaf and eliminating only 1 sorry from
the `lineBundleAtClosedPoint` body would yield net +3 sorries
(7 → 10), triggering escalation.

Even a minimal scaffold (carrier as typed sorry + isSheaf as typed
sorry, eliminating 1 sorry from the body) yields net +1 (7 → 8),
hitting the escalation threshold.

**Therefore iter-183 deferred the Submodule upgrade**: the substantive
scaffold landed (`carrierSet` + `carrierSet_mono`) is at zero new
sorries, hitting the no-regression target.

## File state summary

- **LOC**: 459 → 545 (+86 LOC iter-183).
- **Sorries**: 7 → 7 (no regression; ≤ 7 target HIT).
- **Project axioms**: 0 → 0 (zero-axiom build retained).
- **New declarations**: 2 (`lineBundleAtClosedPoint.carrierSet`,
  `lineBundleAtClosedPoint.carrierSet_mono`). Both helpers, both
  axiom-clean. Helper budget consumed: 2 of 5.

## Sorries remaining (7 total)

| Line | Decl | Tier | Status |
|------|------|------|--------|
| L224 | `lineBundleAtClosedPoint` body | Tier-3 | Honest direct sorry; iter-184+ via carrierSubmodule + presheaf + isSheaf chain |
| L244 | `lineBundleAtClosedPoint.toFunctionField` body | Tier-3 | Gated on `lineBundleAtClosedPoint` body |
| L298 | `globalSections_iff_mp` | Tier-3 | Gated on `lineBundleAtClosedPoint` body |
| L343 | `globalSections_iff_mpr` | Tier-3 | Gated on `lineBundleAtClosedPoint` body |
| L453 | `h1_vanishing_genusZero` | Tier-3 | Deep cohomology (LES + skyscraper); iter-184+ |
| L490 | `dim_eq_two_of_genusZero` | Tier-3 | Gated on `h1_vanishing_genusZero` |
| L544 | `exists_nonconstant_genusZero` | Tier-3 | Gated on `dim_eq_two_of_genusZero` |

## Iter-184 path forward

### Primary: upgrade `carrierSet` → `carrierSubmodule`

1. **`Scheme.RationalMap.order_zero` lemma** (~5 LOC, axiom-clean):
   `Scheme.RationalMap.order Q (0 : K(C)) = 0` via `map_zero +
   WithZero.log_zero`. NO Mathlib gap.

2. **`Scheme.RationalMap.order_smul_unit` lemma** (~20-30 LOC,
   axiom-clean): for `c : kbar` with `c ≠ 0`,
   `Scheme.RationalMap.order Q (c • f) = Scheme.RationalMap.order Q f`.
   Uses `Ring.ordFrac_of_isUnit` + kbar embedding into local rings.

3. **TYPED SORRY**: `Scheme.RationalMap.order_add_min_le` — the
   non-archimedean inequality
   `min (order Q f) (order Q g) ≤ order Q (f + g)`. Stacks 02ME /
   `02MA`. Mathlib gap under `[KrullDimLE 1]`; named typed sorry
   bridge.

4. **Build** `lineBundleAtClosedPoint.carrierSubmodule` as a
   `Submodule kbar C.left.functionField` using carrierSet + the 3
   closure lemmas (zero/add/smul) — Tier-2 modulo `order_add_min_le`
   gap, after iter-184+ closure lemmas land.

### Secondary: presheaf functor

5. **Build** `lineBundleAtClosedPoint.presheaf` as
   `(TopologicalSpace.Opens C.left)ᵒᵖ ⥤ ModuleCat.{u} kbar` using
   `carrierSubmodule` and `carrierSet_mono` (identity-on-`K(C)`
   restriction via `Submodule.inclusion`). NO sorries (assuming
   carrierSubmodule lands).

### Tertiary: sheaf-property

6. **TYPED SORRY**: `lineBundleAtClosedPoint.isSheaf` — gluing-by-
   stalks for subobjects of the constant sheaf at `K(C)`. ~80-150 LOC
   iter-185+ (Mathlib gap analysed in `ocofp-sheaf-internalhom.md`).

7. **Bundle** `lineBundleAtClosedPoint` body as
   `⟨presheaf, isSheaf⟩` — eliminates the L224 sorry.

### Estimated sorry trajectory iter-184+

- Iter-184 (closure lemmas): +1 typed sorry (`order_add_min_le` gap)
  → 8 total, but with 2 named bridges as substantive structural
  progress.
- Iter-185 (Submodule + presheaf): -1 sorry (carrier landed
  cleanly via `order_add_min_le` consumer) → 7 again.
- Iter-186+ (isSheaf typed sorry + body collapse): -1 sorry
  (eliminate `lineBundleAtClosedPoint` body sorry by bundling) +1
  typed sorry (isSheaf as helper) → 7.

The cleaner path: pre-build `order_add_min_le` as a typed sorry
helper, then the Submodule + presheaf collapse to 0 NEW sorries in a
single iter, eliminating 1 OLD sorry → 6 total (strong target).

## Key lemmas / Mathlib facts discovered

- `Ring.ordFrac` is a `K →*₀ WithZero (Multiplicative ℤ)`, hence
  `Ring.ordFrac _ 0 = 0` (monoid-with-zero hom).
- `WithZero.log_zero : WithZero.log 0 = 0` (junk convention).
- `Ring.ordFrac_add` (non-archimedean) — `IsDiscreteValuationRing`
  required (Mathlib gap for `[KrullDimLE 1]` regime).
- `Ring.ordFrac_of_isUnit` — unit ⇒ ord = 1 (under `[KrullDimLE 1]`).
- `Scheme.IsRegularInCodimensionOne.out` — bridge instance from
  project class to per-prime-divisor `Ring.KrullDimLE 1`.

## Tooling traps / negative results

- **Instance synthesis under structure projection**: literal
  `⟨P, hPcoh⟩.point` does NOT reduce during typeclass search even
  though `Scheme.IsRegularInCodimensionOne.out Y` is a perfectly
  good instance for any `Y : PrimeDivisor`. Workaround: name the
  PrimeDivisor (`let Phat : ... := ⟨P, hPcoh⟩`) and `haveI` the
  KrullDimLE instance manually inside a `by ... exact` block.

- **`let`-binding does NOT fix synthesis**: trying
  `let Phat := ⟨P, hPcoh⟩` in a TERM context (no `by`) still fails
  because the let-binding is unfolded eagerly at typeclass search
  time. Must use `by ... exact` to introduce `haveI`.

- **Universe handling**: `(TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ`
  is the canonical Mathlib idiom (matches `Scheme.toModuleKPresheaf`
  pattern); `Opens` bare-identifier works only when
  `TopologicalSpace` namespace is opened (not the case in OCofP.lean
  by default).

## Blueprint markers

The blueprint chapter `RiemannRoch_OCofP.tex` (iter-182 plan-phase
landed the `toFunctionField` pin block) does NOT need updates from
this lane other than the sig amend acknowledgement: the chapter's
`\lean{...}` pin lines for `lineBundleAtClosedPoint` and
`toFunctionField` should be re-verified by the next blueprint-reviewer
dispatch to confirm the new `hPcoh` hypothesis is reflected in the
prose. (Per signature-drift watchlist in PROGRESS.md.)

**New decls without blueprint pins**: `carrierSet` and
`carrierSet_mono` are `private` helpers — no blueprint pin required.

## Helper budget

Consumed: 2 of 5 (`carrierSet` + `carrierSet_mono`).

Remaining budget (3) is for iter-184+ closure lemmas.
