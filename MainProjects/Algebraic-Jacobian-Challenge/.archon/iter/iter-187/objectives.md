# Iter-187 — Detailed per-lane objectives

## Plan-phase outputs (preceding prover dispatch)

- **2 critic dispatches**: progress-critic route187 + blueprint-reviewer
  iter187. Both COMPLETE.
- **1 analogist dispatch**: mathlib-analogist quotscheme-isbasechange-tilde
  (Lane F idiom consult). COMPLETE.
- **2 blueprint-writer dispatches**: rrformula-h0h1split (MF-1 + H⁰/H¹
  split), avr-iiic-pivot-label (MF-2). AVR writer COMPLETE; RRFormula
  writer queued.
- **1 refactor dispatch**: ocofp-steps3to5 (Lane A Steps 3+4+5). Queued.
- **2 direct edits**: OCofP chapter pins for refactor's Step 3+4; 3-row
  STRATEGY.md estimate revisions (A.4.b / chart-bridge / Genus-0 RR.2).

## Lane fates (8 dispatching, 3 deferred)

### DISPATCHING

| # | File | Lane | Verdict | Helper budget | HARD BAR / Acceptable outcome |
|---|---|---|---|---|---|
| 1 | `RiemannRoch/OCofP.lean` | Lane A | CHURNING corrective | 1 | ≥1 pre-existing sorry closes (Step 5 alone) |
| 2 | `Picard/LineBundlePullback.lean` | Lane A.1.b IsInvertible follow-up | CONVERGING-extension | 2 | Predicate defined + ≥1 decl refined |
| 3 | `Picard/QuotScheme.lean` | Lane F | CHURNING corrective | 2 | Signature threading + named helper land; body PARTIAL acceptable |
| 4 | `Picard/IdentityComponent.lean` | NEW IdentityComponent | UNCLEAR | 1 | identityComponentCarrier body close + closed-half + 5 typed-sorry skeletons |
| 5 | `RiemannRoch/RationalCurveIso.lean` | Lane I REORDER | STUCK | 2 | Hom.poleDivisor body axiom-clean OR ≤1 narrow named sorry |
| 6 | `Albanese/AuslanderBuchsbaum.lean` | Lane G sub-lane G1 | CHURNING corrective | 2 | Cotangent dim drop helper lands ±1 named sorry |
| 7 | `Albanese/CodimOneExtension.lean` | Lane M↓ re-opened | PASS chapter | 1 | ≥1 step closes OR smooth→regular wrapped as narrow sorry |
| 8 | `RiemannRoch/OcOfD.lean` | NEW Lane J | under-dispatch correction | 1 | sheafOf_zero closes axiom-clean OR ≤1 narrow sorry |

### DEFERRED per HARD GATE

| File | Reason | iter-188 path |
|---|---|---|
| `Genus0BaseObjects/GmScaling.lean` (Lane B) | Chapter PARTIAL MF-2 (writer in flight) | Mandatory reviewer clears; prover with III.c separated-locus recipe |
| `AbelianVarietyRigidity.lean` (Lane E) | Same MF-2 (semaphore-conservative defer) | Mandatory reviewer clears; prover with 6-step appTop recipe |
| `RiemannRoch/RRFormula.lean` (Lane H) | Chapter FAIL MF-1 (writer in flight) | Mandatory reviewer clears; prover closes H⁰ half ~30-60 LOC axiom-clean |

## Per-lane detailed work plan

### Lane 1 — OCofP (Lane A, CHURNING corrective)

**Refactor `ocofp-steps3to5` dispatched** (plan-phase). Lands:
- Step 3: `lineBundleAtClosedPoint.carrierPresheaf` functor (~30 LOC).
- Step 4: `lineBundleAtClosedPoint.carrierPresheaf_isSheaf` (~30 LOC,
  potentially 1 narrow named typed sorry on the `isSheaf_iff_isSheaf_forget`
  Set-level reduction).
- Step 5: Replace L397 `lineBundleAtClosedPoint` body — mechanically
  closes the pre-existing sorry.

**Prover work** (post-refactor):
- Attempt to close `toFunctionField` L418 body — gated on
  `lineBundleAtClosedPoint`'s explicit body shape.
- Attempt `globalSections_iff_mp` L480 + `globalSections_iff_mpr` L526
  via the explicit `carrierSubmodule` membership characterisation.
- If `carrierPresheaf_isSheaf` left a typed sorry, attempt to close it.

**HARD BAR** (per progress-critic CHURNING corrective): ≥1 pre-existing
sorry must close iter-187. Step 5 alone meets this from the refactor side.
If the prover closes additional cascades, the gate is strongly hit.

### Lane 2 — LineBundlePullback (Lane A.1.b IsInvertible follow-up)

**Path A** (project-side definition):

```lean
private def Scheme.LineBundle.IsInvertible {X : Scheme.{u}} (M : X.Modules) : Prop :=
  ∃ (𝒰 : X.AffineOpenCover), ∀ U, Nonempty (M.restrict U.opens ≅ X.toModules.restrict U.opens)
```

(exact shape per the project's `AffineOpenCover` API + `Modules.restrict`
infrastructure). Mathlib `b80f227` ships none of this directly; it's
project-bespoke.

**Then refine** at least one of the 5 axiom-clean iter-186 declarations:
- `OnProduct πC πT` → `{ M : (Limits.pullback πC πT).Modules // IsInvertible M }`
  (subtype-like) OR a separate `OnProductInvertible` predicate.
- `pullbackAlongProjection` — adds `IsInvertible`-preservation
  (Stacks 01HH).

Helper budget = 2 (the predicate + 1 preservation lemma).
Acceptable outcome: predicate defined axiom-clean + ≥1 of 5 decls
refined to consume it; full refinement may take iter-188.

### Lane 3 — QuotScheme (Lane F, analogist-informed)

**iter-187 analogist verdict** (`analogies/quotscheme-isbasechange-tilde.md`):
- Drop `Module.Flat.isBaseChange` framing (category mistake; it's a
  stability statement, NOT IsBaseChange producer).
- Thread `[F.IsQuasicoherent]` through 9 consumer signatures.
- Factor `pullback_tildeIso` as a NAMED helper (typed sorry; ~5 LOC sig).
- Close `pullback_app_isoTensor_baseMap_isBaseChange` axiom-clean via
  `IsBaseChange.ofEquiv` ∘ `TensorProduct.isBaseChange` through the
  named helper.

**Per analogist's "Concrete recommendation" (items 1-3 of 3):**

1. Edit docstring at L632-655 — remove the wrong
   `Module.Flat.isBaseChange` framing. Replace with: the iso comes
   from `(pullback_app_isoTensor g' …).symm` directly; residual gap
   is Beck-Chevalley compatibility + section-vs-tensor-product
   Tilde-isoTop content.

2. Thread `[F.IsQuasicoherent]` / `[N.IsQuasicoherent]` through:
   - L563 `pullback_app_isoTensor_baseMap_isBaseChange`
   - L588 `pullback_app_isoTensor_isBaseChange`
   - L615 `Scheme.Modules.pullback_app_isoTensor`
   - L656 `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
   - L717 `_of_isAffineOpen`
   - L758 `_of_affineCover`
   - L808 `canonicalBaseChangeMap_app_app_isIso`
   - L831 `canonicalBaseChangeMap_isIso`
   - L840 `flatBaseChangeCohomology`
   ~5-10 LOC of signature edits; no body work.

3. Factor `pullback_tildeIso` as NAMED helper:
   ```
   private noncomputable def pullback_tildeIso ... :
       (Scheme.Modules.pullback (Spec.map φ)).obj (tilde M) ≅
       tilde (B ⊗_A M) := sorry
   ```
   Signature ~5 LOC.

4. Close `pullback_app_isoTensor_baseMap_isBaseChange` body via:
   ```
   apply IsBaseChange.ofEquiv ... <| pullback_tildeIso ... ≪≫ ...
   ```
   The substantive content is now hidden in `pullback_tildeIso`'s typed
   sorry.

Helper budget = 2. Acceptable outcome: signature threading + named
helper land axiom-clean; body close via `.ofEquiv` may need 1 iter of
tactical tuning (PARTIAL acceptable).

### Lane 4 — IdentityComponent (NEW lane, file-skeleton extension + body)

**Body work** (iter-186 PARTIAL targets):

(a) `identityComponentCarrier` body — needs project-side instance:
```lean
instance : LocallyConnectedSpace X.toTopCat where ...
```
for `[IsLocallyNoetherian X]` schemes (~30 LOC, possibly more if
EGA I 6.1.9 direct port is heavy). Body of `identityComponentCarrier`:
```lean
⟨{ carrier := connectedComponent (e.image),
   is_open' := isOpen_connectedComponent }⟩
```
(exact construction matches the iter-186 `G.left.Opens`-valued helper).

(b) `IdentityComponent.isOpenSubgroupScheme` closed-half — once (a)
lands, the closed-half reduces via `isClopen_connectedComponent.2`
(its `IsClosed` half) on the carrier `Set`.

**File-skeleton extension** (5 new typed-sorry scaffolds for Path B
chapter split's new pins):

```lean
private theorem IdentityComponent.isSubgroupHomomorphism ... := sorry
private theorem IdentityComponent.isFiniteTypeGeometricallyIrreducible ... := sorry
private noncomputable def IdentityComponent.baseChangeIso ... := sorry
private theorem Pic0Scheme.finrank_eq_genus ... := sorry
private theorem Pic0Scheme.kPoints_iff_kerDegree ... := sorry
```

(Exact signatures per chapter L127/L147/L167/L463/L489 `\lean{...}` pins.)

Helper budget = 1 (`LocallyConnectedSpace` instance).
Acceptable: (a) closes axiom-clean modulo 1 named sorry on LCS instance
if not immediate; (b) closes; (c) typed-sorry scaffolds.

### Lane 5 — RationalCurveIso (Lane I REORDER, STUCK corrective)

**SOLE target this iter**: `Hom.poleDivisor` body L290. NO helper
work, NO Pin 3 work this iter (per progress-critic STUCK corrective).

**Construction (Path (a) Finsupp direct)**:

```lean
noncomputable def Hom.poleDivisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (φ : C ⟶ ProjectiveLineBar kbar) :
    C.left.WeilDivisor :=
  -- Pre-image of ∞ ∈ ℙ¹ as a finite set of prime divisors on C
  -- (finiteness from quasi-finiteness of φ + Hartshorne II.6.8)
  -- Each Q ∈ φ⁻¹(∞) carries the multiplicity ord_Q(algebraMap K(ℙ¹) K(C) t_∞)
  -- where t_∞ = X₀/X₁ on the chart-1 affine of ℙ¹.
  Finsupp.onFinset
    (preimage_infinity_finset φ : Finset C.left.PrimeDivisor)
    (fun Q => Scheme.RationalMap.order Q (algebraMap K(ℙ¹) K(C) (t_inf kbar)))
    (preimage_infinity_support_witness ...)
```

**Substrate helpers needed** (potential typed sorries if Mathlib gaps):
- `preimage_infinity_finset`: needs finiteness of `φ⁻¹(∞)` —
  derived from Hartshorne II.6.8 (non-constant morphism of smooth
  proper curves is finite + finite map has finite fibers).
- `t_inf kbar : K(ℙ¹)`: needs `ProjectiveLineBar.functionField` API
  + local parameter at infinity (the ratio coordinate X₀/X₁ on chart-1).
- `algebraMap K(ℙ¹) K(C)`: the canonical `φ`-induced map; typeclass
  binder.

Helper budget = 2 (`preimage_infinity_finset` + `t_inf kbar` if
needed as project-side declarations).

**Acceptable outcome**: `Hom.poleDivisor` body either:
- (i) Lands axiom-clean (preferred — substrate all assembled).
- (ii) Lands modulo ≤1 narrow named typed sorry on a finiteness or
  local-parameter substrate gap.

**NOT acceptable**: bare `sorry`. The lane has been STUCK for 4 iters
on this; iter-187 must produce substantive body progress.

### Lane 6 — AuslanderBuchsbaum (Lane G sub-lane G1, CHURNING corrective)

**Per iter-187 STRATEGY.md commitment** (Decision 1 in plan.md): the
project commits to Option 2 from `analogies/isregularlocalring-isdomain.md`
(project-side Stacks 00NQ formalisation, ~300 LOC across 2-3 iters).

**Iter-187 starts sub-lane G1**: cotangent-space dim drop helper.

**Statement**: for `x ∈ 𝔪 \ 𝔪²` of a Noetherian local ring `R`, the
cotangent space of `R/(x)` has dimension one less than that of `R`:
```lean
private theorem CotangentDimDrop.finrank_cotangent_quot_succ
    {R : Type*} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    (x : R) (hx : x ∈ IsLocalRing.maximalIdeal R)
    (hxnotsq : x ∉ IsLocalRing.maximalIdeal R ^ 2) :
    Module.finrank (IsLocalRing.ResidueField (R ⧸ Ideal.span {x}))
      (CotangentSpace (R ⧸ Ideal.span {x})) + 1 =
    Module.finrank (IsLocalRing.ResidueField R) (CotangentSpace R) := by
  -- Build the κ-linear short exact sequence
  --   0 → κ · x̄ → 𝔪/𝔪² → 𝔪̄/𝔪̄² → 0
  -- where κ = R/𝔪 (cotangent residue field) and apply
  -- Submodule.finrank_quotient_add_finrank
  sorry
```

(Statement may need refinement on whether to use Mathlib's
`CotangentSpace` or roll a project-side `𝔪/𝔪²`. Check Mathlib
substrate before deciding.)

**Mathlib substrate**:
- `IsLocalRing.maximalIdeal` / `IsLocalRing.ResidueField`.
- `Submodule.finrank_quotient_add_finrank` (dimension SES).
- Building the 1-dimensional κ-subspace from `x ∉ 𝔪²` — the substantive
  step requiring careful ring-theoretic argument.

**Acceptable outcome**: helper body lands axiom-clean OR modulo ≤1
narrow named typed sorry on the κ-subspace-from-`x ∉ 𝔪²` construction.

**Helper budget = 2** (the dim-drop helper + 1 supporting κ-subspace
construction if extracted).

### Lane 7 — CodimOneExtension (Lane M↓ re-opened, chapter PASS)

**Per blueprint-reviewer iter187**: chapter PASS;
`lem:smooth_to_regular_local_ring` correctly missing `\leanok` (Mathlib
gap on smooth→regular stalk implication, ~200-300 LOC cotangent-space
machinery).

**Target**: `IsRegularLocalRing` half of `hreg_dim` (the half that the
iter-184 CoheightBridge work didn't cover; Krull-dim half is axiom-clean).

The body may close modulo a narrow named typed sorry on the
Jacobian-criterion direction. Concretely:
- The `IsRegularLocalRing` half is gated on
  `lem:smooth_to_regular_local_ring` (Stacks 00TT TFAE 3-clause); the
  prover may need to wrap that as a narrow named typed sorry if
  not directly closable.

**Acceptable outcome**: ≥1 step of `hreg_dim`'s `IsRegularLocalRing`
half closes, OR the smooth → regular gap is wrapped as a narrow named
typed sorry (not the full conjunction).

Helper budget = 1. Blueprint:
`chapters/Albanese_CodimOneExtension.tex` (PASS).

### Lane 8 — OcOfD (NEW Lane J, under-dispatch correction)

**Target**: `Scheme.OcOfD.sheafOf_zero` body L150 (~30-60 LOC).

**Recipe**: unfold `sheafOf` at `0 : C.left.WeilDivisor`; order
conditions trivial on `0` (no points contribute); carrier = structure
sheaf identification; identify with `Scheme.toModuleKSheaf C` via
sheaf hom from equal `Set`-carriers; close via `Sheaf.ext`.

**Off-target this iter**: `sheafOf` def body L130 (the main definition),
`sheafOf_singlePoint` L160-ish, `sheafOf_ses_single_add` L200-ish
— all Hartshorne II.7 substantial; iter-188+.

Helper budget = 1. Acceptable: `sheafOf_zero` axiom-clean OR ≤1 narrow
sorry on a sheaf-equality detail. Blueprint:
`chapters/RiemannRoch_OcOfD.tex` (PASS).

## Sorry projection envelope

Entering: **76 / 0 axioms**.

Best case (all 8 lanes hit acceptable + Lane A closes 2 cascades +
Lane I lands axiom-clean): 76 → **~68-72** (−4 to −8).

Realistic (Lane A Step 5 + 1 cascade; Lane F threading lands but body
PARTIAL; Lane I PARTIAL with 1 named typed sorry; Lane G G1 PARTIAL
with 1 typed sorry; Lane M↓ wraps smooth→regular as narrow sorry;
Lane J closes; IdentityComponent file-skeleton +5 typed sorries
offset by closures): 76 → **~75-80** (−1 to +4).

Worst case (Lane A refactor body leaves 3+ closure sorries
unclosed; Lane F signature threading triggers typeclass synthesis
cascades; multiple PARTIAL): 76 → **~80-86** (+4 to +10).

## Helper budget grand total

8 lanes × per-lane budgets = 12 helpers max across iter-187. Within
the 15-helper soft cap per iter-185 strategy-critic guidance.
