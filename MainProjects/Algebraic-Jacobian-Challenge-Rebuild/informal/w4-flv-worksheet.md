# Wave-4 FLV — fibrewise large-twist vanishing: the binding worksheet (`AJCR.w4-rep` / w4-4)

*Written 2026-07-15 (Fable design agent). Route design per the (C2) lesson: decisions
first, provers only from specs derived from this worksheet. Model:
`informal/c2-effectivity-assembly.md`. Inputs read in full: `informal/w4-datum-design.md`
(esp. §§1.2, 2.1, 2.3, 3.2, 4.1–4.2, 5.1), `informal/w4-cbc-recon.md` (§0.2 CBC-0..3, §5
risk 3), the landed χ-ledger and degree stack (`RiemannRoch/{Chi,ChiSlice,ChiFiniteness,
ChiLedger,ChiCurve,Degree,DivisorSheaf,MulEquiv,PrincipalDivisor}.lean`,
`Curve/BaseChangeInstances.lean`), the meromorphic bridge
(`Picard/DivisorClassMeromorphic.lean`, W1–W4 ledger `fbd77da540`;
`Picard/MeromorphicPresentation.lean`), the landed engine files
(`Cohomology/{TwoCover,Finiteness,RelativeTwoCover}.lean`, `Curve/MapToP1.lean`),
`informal/deg-d2-meromorphic-worksheet.md` AMENDMENT (W6), and Kleiman
`references/Kleiman_The_Picard_Scheme_Theorem-4.8.tex` (whole excerpt; anchor lines
cited below). No Lean edited; no build run (prover holds the lock).*

**VERDICT IN ONE LINE.** FLV is the increasing-lattice exhaustion argument run on the
π-two-cover — the same geometry as the landed `Finiteness.lean` ladder, but where the
ladder gave *finiteness*, an increasing union of section lattices exhausting the overlap
sections gives *vanishing*: per-class, non-effective `n₀`, no Serre duality, no
`R^i f_*`, one gate (the w4-1 ported affine vanishing fires the Čech carrier on
`divisorSheaf`); and W6 **splits** — the h⁰/h¹-of-a-class API collapses to a few lines
on landed `h0_congr`/`h1_congr` (no campaign), while the engine-sheaf ↔ divisor-sheaf
identification is a real M-brick that belongs to the datum seam, *not* to FLV.

---

## §1 THE STATEMENT — what FLV literally says in this tree's types

### 1.1 The consumer's quantifier, checked against the landed stack

Kleiman's strata need (w4-datum §1.2 (V-fib); excerpt eq. 4.8.3, lines 71–73): for the
fixed twist family and **every field point**, per-class eventual `h¹`-vanishing. In this
tree a field point of a test ring `R` is a residue field `κ(p)`; `R` is a `k`-algebra, so
`κ(p)` is a field extension of `k` — **checked: exactly the `(K : Type u) [Field K]
[Algebra k K]` signature of `Curve/BaseChangeInstances.lean`**, which installs (as
instances, items 1–5) the FULL standing pack of the RiemannRoch/degree stack on
`C_K := (C ⊗ overSpec k K).left`: `Over Spec K` via the second projection, smooth₁ /
proper / qc in the `↘`-spelling, `IsIntegral`, and both structure-sheaf finiteness
instances. So every field-level statement below applies to every fiber of every test
ring by typeclass resolution alone. Classes over a field are divisor classes: **(S)**
`CurveDivisor.exists_picClass_eq` and **(X)** `CurveDivisor.exists_divOf_of_picClass_eq`
(landed, `Picard/DivisorClassMeromorphic.lean:118,131`). Twist degree bookkeeping:
`classDeg_picClass` (E-i) + `classDeg_mul` (E-ii) (landed, `RiemannRoch/Degree.lean`);
`deg Θ_n = n·deg π` is w4-5's lemma.

### 1.2 The two statements (binding shapes; spelling lane-owned)

FLV is TWO theorems, an inner conditional one and an outer class-level one. Standing
variables: the abstract curve bundle of the RiemannRoch files —
`(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (.of K))]
[SmoothOfRelativeDimension 1 (X ↘ …)] [IsIntegral X] [QuasiCompact (X ↘ …)]
[Module.Finite K (HModule (X.moduleKSheaf K) 0)] [Module.Finite K (… 1)]`.

**(FLV-fiber) — the core, conditional on a finite map** (house pattern:
`moduleFinite_hModule_one_of_isFinite_toP1`, `Cohomology/Finiteness.lean:374`):

```
theorem subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1
    (π : X ⟶ P1 K) [IsFinite π] (hπ : π ≫ P1.structureMap K = X ↘ Spec (.of K))
    (D : X.CurveDivisor) :
    ∃ n₀ : ℕ, ∀ n ≥ n₀,
      Subsingleton (Sheaf.HModule (X.divisorSheaf K (D + n • fiberDivisor K π)) 1)
```

where `fiberDivisor K π : X.CurveDivisor` is the **positive part of `divOf u`**,
`u : X.functionFieldˣ` the pulled-back chart coordinate (§2.2; FLV-0). Conclusion is
`Subsingleton`, NOT `h1 = 0`: `finrank = 0` does not exclude infinite dimension, and
`Subsingleton` is what transports along sheaf isos (`HModule.mapEquiv`) and surjections
— the consumers need the strong form. (`h1 = 0` follows via `Sheaf.h1_eq_zero`.)

**(FLV-class) — the outer statement the datum consumes** (curve layer, over an
arbitrary field; quantified over an abstract twist class so it is immune to how the
datum's `Θ_n` reaches the fiber):

```
theorem exists_subsingleton_hModule_one_of_one_le_classDeg
    (λ θ : X.CechPic) (hθ : 1 ≤ classDeg K θ) :
    ∃ n₀ : ℕ, ∀ n ≥ n₀, ∀ D : X.CurveDivisor,
      CurveDivisor.picClass K D = λ * θ ^ n →
      Subsingleton (Sheaf.HModule (X.divisorSheaf K D) 1)
```

stated on the bundled curve layer (it invokes `exists_isFinite_toP1`, which needs
`[IsProper C.hom]` etc.), plus the smoke-test instantiation at `C_K` mirroring
`BaseChangeInstances` item 6. `n₀` is **per-class and non-effective** — the Kleiman
strata `P^φ_m` (excerpt lines 64–90) absorb exactly this, and the w4-datum §4.1 default
already committed to the strata route; the nested-open-union mechanics are Kleiman
line 88 (*"the products `P^φ_m ×_{P^φ} T` form a nested sequence of open subschemes of
`T`, whose union is `T`"*).

The quantification `∀ D, picClass D = λθⁿ → …` is well-posed because h¹ is
class-invariant (W6-lite, §3) — `n₀` cannot depend on the witness.

**Corollary (the rank anchor for CBC-3).** Under the conclusion,
`(Sheaf.h0 (X.divisorSheaf K D) : ℤ) = CurveDivisor.deg K D + Sheaf.chi (X.moduleKSheaf K)`
— one line from landed `Sheaf.chi_eq_h0` + `chi_divisorSheaf`; curve form
`= deg D + 1 − genus C`. This is the fibrewise value of Kleiman's `rank Q = χ`
(3.10 (v)⟹(i), excerpt line 100) that w4-3/G-CBC-6 cites.

### 1.3 What FLV deliberately does NOT say

- **No uniform bound** (`deg > 2g−2` is duality, off-route — §2.4(d)); no effective
  `n₀`; no dependence-only-on-`g`. Per-class is sufficient by the strata default.
- **No relative statement.** Base-change stability of the vanishing across fibers is
  CBC-2's job (Kleiman lines 82–86); FLV is consumed pointwise at residue fields.
- **No statement about the engine's cocycle-glued sheaves.** FLV's h¹ is the h¹ of
  `divisorSheaf` of a witness divisor. The seam to the engine's fiber sheaf is W6-full
  (§3.2), owned by the datum/cbc lane.

---

## §2 THE ROUTE — increasing-lattice exhaustion, no duality (DECIDED)

### 2.1 The decision

**Route (b) — the two-cover lattice route — wins, in the following sharpened form.**
Everything happens inside `K(X)` (the deg-D2 D1 discipline): `divisorSections` are
literal `K(X)`-submodules and restrictions are `Submodule.inclusion`
(`DivisorSheaf.lean:divisorSectionsRes`). On the affine two-cover
`V₀ := π⁻¹ᵁ D₊(X₀)`, `V₁ := π⁻¹ᵁ D₊(X₁)` (landed: `isAffineOpen_preimage_chartOpen`,
`preimage_chartOpen_sup`), with `F := fiberDivisor K π` supported in `V₁ ∖ V₀` and `u`
its equation:

- `M₀ := 𝒪(D)(V₀)`, `M₁ := 𝒪(D)(V₁)`, `N := 𝒪(D)(V₀ ⊓ V₁)` — submodules of `K(X)`;
- the three section lattices of the twisted sheaf `𝒪(D + n•F)` are, **as submodule
  equalities in `K(X)`** (ord bookkeeping, §2.2): over `V₀` it is `M₀` (unchanged —
  `supp F ∩ V₀ = ∅`), over `V₀ ⊓ V₁` it is `N` (unchanged), over `V₁` it is
  `u⁻ⁿ • M₁` (the `mulEquivDivisorSheaf` mechanism, section-level, one chart);
- so the two-cover Čech H¹ of `𝒪(D + n•F)` is `N ⧸ Aₙ` with
  `Aₙ := M₀ ⊔ (u⁻ⁿ • M₁)` — **one fixed ambient `N` with a growing denominator**;
- `(Aₙ)` is an **increasing chain** (`ord_x u ≥ 0` on `V₁`, so `u•M₁ ⊆ M₁`) which
  **exhausts `N`** (a section on the overlap has finitely many fiber points to clear,
  each with `ord_x u = F_x ≥ 1`: pole-clearing at the finite set `V₁ ∖ (V₀⊓V₁)`);
- `N ⧸ A₀` is **finite-dimensional**: it computes `h¹(𝒪(D))` through the Čech carrier
  (§2.3), and `Module.Finite K (HModule (divisorSheaf K D) 1)` is landed
  (`ChiFiniteness.lean:250`, the dévissage instance);
- **endgame (pure linear algebra):** an increasing ℕ-chain of submodules of `N`
  containing `A₀`, with `⨆ Aₙ = ⊤` and `N ⧸ A₀` finite-dimensional, is eventually `⊤`
  (images in the Noetherian quotient `N ⧸ A₀` stabilize; the stabilized union is
  everything). Hence `∃ n₀, ∀ n ≥ n₀, Aₙ = ⊤`, i.e. the Čech H¹ is the zero module,
  i.e. `Subsingleton (HModule (divisorSheaf K (D + n•F)) 1)` through the carrier.

This answers the stabilization question posed by the mission head-on: `h¹(D + nx)` is
monotone non-increasing and stabilizes at some `h∞ ≥ 0`, and *the exhaustion is the
missing argument that `h∞ = 0`* — not a strict-drop point-selection, not duality. Note
what the landed ladder is and is not used for: **`Finiteness.lean`'s two-lattice ladder
is NOT re-run.** The ladder's product (finiteness of H¹) enters only once, at the base
`n = 0`, through the landed dévissage instance; the vanishing content is the exhaustion,
which the ladder does not provide (it bounds a fixed quotient; it says nothing about the
twist direction). The answer to "what does the ladder actually give, and is `n` large
effective": it gives finiteness only; effectivity is lost at the stabilization index;
per-class `n₀` is honest and sufficient.

### 2.2 The fiber geometry (why the lattices behave)

`u := ` the pulled-back chart coordinate as a unit of the function field: the landed
overlap-=-basicOpen facts (`Finiteness.lean:174–197`, `private` — re-exposure is w4-5's
first deliverable, per w4-datum §2.1) make `t₀` (and symmetrically `t₁`) a **unit
section on `V₀ ⊓ V₁`**; `germGenericUnits` (`MeromorphicPresentation.lean:58`) turns a
unit section into an element of `K(X)ˣ`. Then with `u := ` the chart-1 coordinate
pullback: `ord_x u ≥ 0` on `V₁` (regular section), `ord_x u = 0` on `V₀ ⊓ V₁` (unit),
`ord_x u ≤ 0` on `V₀` (its inverse is the chart-0 pullback, regular there), so
`fiberDivisor K π := (divOf u)⁺` (positive part) is effective with
`supp ⊆ V₁ ∖ V₀ = ` the closed points where `u` vanishes — finitely many
(`ordZ_support_finite`, `PrincipalDivisor.lean:122`). Every needed inequality is the
landed `ord`/`divisorBound` calculus (`DivisorSheaf.lean`, `MulEquiv.lean:ord_val_eq_ordZ`).

**Pole existence (`F ≠ 0`) is load-bearing** (the exhaustion dies if `u` has no zeros)
and is the one genuinely geometric obligation: from `IsFinite π`, `u` is transcendental
over `K` (it generates `K(t) ↪ K(X)`), so if `u` had no zeros then `K[u] ↪ Γ(X, 𝒪)`
would contradict the landed `Module.Finite K H⁰(𝒪)` instance. Two candidate discharges
are recorded in FLV-0's spec (§4); neither was compile-verified this pass (§5.3).

### 2.3 The carrier — where the Ext-h¹ meets the lattice (the one gate)

`Scheme.twoCoverH1LinearEquiv` (`TwoCover.lean:92`) is already general-coefficients: for
ANY sheaf `F` of `K`-modules with `Subsingleton (HModule' F Vᵢ 1)` (i = 0,1) it gives
`HModule F 1 ≃ₗ[K] F(V₀ ⊓ V₁) ⧸ range (moduleDiff F)`, and `range (moduleDiff) = Q₀ ⊔ Q₁`
is the two-line `range_diff_eq` argument (`Finiteness.lean:218`, private, structure-sheaf;
its general-`F` restatement is part of FLV-2). The two vanishing instances for
`F = divisorSheaf K D'` on the affine `Vᵢ` are **exactly w4-1's ported theorem**
`IsAffineOpen.subsingleton_hModule'_one_of_qcoh` with the `QcohOn (divisorSheaf K D') Vᵢ`
packaging discharged — and w4-datum §3.2 already pins `divisorSheaf` as the second
dischargeable family (*"sections are `K(X)`-submodules with literal multiplication; (P2)
is ord bookkeeping. Needed for the fibrewise anchor (§4, FLV)"*). The discharge is
verified feasible by reading (FLV-2's content):

- **(P1) action:** `𝒪(W)` acts on `divisorSections D' W` by multiplication through the
  germ-at-η embedding; `ord_x(s·f) ≥ ord_x f` since integral sections have
  `ord ≤ 1` (`ord_algebraMap_stalk_le_one`, `DivisorSheaf.lean:79`). Natural in `W`
  because restrictions are inclusions.
- **(P2a) denominator clearing:** `f ∈ 𝒪(D')(W ⊓ D(g)) ⟹ gᵐf ∈ 𝒪(D')(W)` for `m`
  large: the zero set of `g ≠ 0` in `W` is finite (`ordZ_support_finite`), `ord_x g ≥ 1`
  there and `= 0` on `W ⊓ D(g)`; max over the finite set. (`g = 0`/empty-open corners:
  the `divisorSections` ⊥-guard.)
- **(P2b) defect annihilation is TRIVIAL for this family:** restrictions of
  `divisorSheaf` between nonempty opens are injective (submodules of `K(X)`), so
  `res f = 0 ⟹ f = 0`.

**Hence the gate:** FLV-2 (and only FLV-2) gates on w4-1. This is consistent with the
w4-datum §4.1 sequence (w4-5 → w4-1 → {w4-2, w4-4} → w4-3): FLV was already scheduled
after the port. Staged fallbacks in §4 keep the rest of FLV land-able in parallel.

### 2.4 Routes weighed and rejected (the honest costs)

- **(a) Dévissage with strict drop.** Monotonicity is landed-for-free
  (`HModule.surjective_map_f hS 1` on `devissageSES`, `ChiSlice.lean:112` +
  `skyModule_subsingleton_hModule_one`: `H¹(𝒪(D−x)) ↠ H¹(𝒪(D))`), but the strict-drop
  step — "if `h¹ ≠ 0`, some point `x` makes `h⁰` not jump" — needs a point avoiding a
  base locus: over finite fields even the classical argument needs care, and any honest
  proof smuggles in either duality or precisely the adelic/lattice computation of §2.1.
  Rejected as the primary; its monotonicity half IS used (as a Subsingleton-transport
  surjection) in FLV-4's reduction.
- **(b) The lattice route.** DECIDED, as sharpened above. Its honest cost: the w4-1
  gate (FLV-2) plus submodule-coercion friction (§5.2). Everything else is landed
  calculus.
- **(c) Crude-uniform Riemann `n₀(C)` / adapted covers (w4-datum §2.3).** Gives a
  per-curve uniform bound but needs the "finite complement is affine" brick and
  per-class covers, is strictly field-level anyway, and buys nothing over (b) for the
  strata route. Not needed; remains the recorded alternative if the pinned-cover
  carrier fights (w4-datum §5.6).
- **(d) Sharp `deg > 2g−2`.** Serre duality — a mountain, off-route (route rule 5 /
  keystone-funnel). Rejected; nothing downstream needs sharpness.
- **(N) Numerical Čech-χ dévissage (the discovered w4-1-independent fallback).** One can
  avoid the Ext-carrier entirely: prove by a Čech-level six-term/snake count that
  `c(D) := dim (N ⧸ (Q₀ ⊔ Q₁))` satisfies the same one-point ledger as `χ` (quotient
  dimensions at a point are `residueDeg` — Dedekind counting), with base case
  `c(0) = g` from the landed structure-sheaf `h1CokEquiv`; then `c(D) = h¹(𝒪(D))`
  numerically for ALL `D` by `induction_devissage`, and the exhaustion closes as before.
  Cost: ~2 bricks (M/L) duplicating ledger machinery at the Čech level. **Held in
  reserve as FLV-2's fallback (fb-ii); do not build speculatively.** Its existence means
  FLV cannot be walled by w4-1 — the worst case is bounded extra work, not a redesign.

### 2.5 The reduction from an abstract twist class to the fiber family (FLV-class ⟸ FLV-fiber)

FLV-fiber only covers twists by `n • F` for `F` *this* π's fiber. The datum's `Θ_n`
reaches the fiber over `K` as an abstract class of degree `n·deg π`; identifying it with
a fiber divisor of the base-changed map would need a `(P1 k) ⊗_k K ≅ P1 K` seam —
**avoided entirely** by the following reduction, which proves FLV-class for ANY `θ` with
`classDeg θ ≥ 1`:

1. Fix `D₀` with `picClass D₀ = λ` ((S)), run FLV-fiber on the curve's own
   `π := exists_isFinite_toP1` over `K` (via `BaseChangeInstances` when `X = C_K`):
   get `m₀` with `Subsingleton H¹(𝒪(D₀ + m•F))` for `m ≥ m₀`; `d' := deg F ≥ 1`
   (effective, nonzero — `deg_single'`/`residueDeg_pos` calculus).
2. For `n` given, set `m(n) := ⌊(n·classDeg θ − g̃)/d'⌋` (`g̃ := −χ(𝒪) + 1` bookkeeping)
   so `W_n := ` any witness of `θⁿ·(picClass F)⁻ᵐ⁽ⁿ⁾` has `deg W_n ≥ g̃`, hence
   `h⁰(𝒪(W_n)) ≥ 1` by the landed `riemann_inequality`; a nonzero global section `f`
   (through the landed `HModule F 0 ≃ F(⊤)` and `mem_divisorSections`) gives an
   **effective** `E_n := W_n + divOf f` in the same class (`picClass_divOf`).
3. `picClass (D₀ + m(n)•F + E_n) = λ·θⁿ`, and peeling `E_n` point-by-point
   (`E ≥ 0`, ℕ-induction on `deg E`; `E ≠ 0 ⟹ ∃x, 0 ≤ E − single x 1`) transports
   `Subsingleton` along the landed slice surjections `H¹(𝒪(A)) ↠ H¹(𝒪(A + x))`:
   `Subsingleton H¹(𝒪(D₀ + m(n)•F)) ⟹ Subsingleton H¹(𝒪(D₀ + m(n)•F + E_n))`.
4. `m(n) → ∞`, so `n₀ := ` the least `n` with `m(n) ≥ m₀` works; any other witness `D`
   of `λθⁿ` has the same h¹ by W6-lite.

No finrank arguments anywhere in the reduction — surjections transport `Subsingleton`
directly. All cited names landed (`riemann_inequality` `ChiLedger.lean:137`,
`surjective_map_f` `ChiSlice.lean:112`, `picClass_add/divOf` bridge file, E-i/E-ii
`Degree.lean`).

---

## §3 W6 PINNED — the split, and the collapse

The w4-datum AMENDMENT resurrected "sub-claim (i)" as W6. Reading against the landed API
**splits it in two, with different fates**:

### 3.1 W6-lite — h⁰/h¹ of a class (COLLAPSED: a few lines, stops being a campaign)

`Sheaf.h0_congr` and `Sheaf.h1_congr` **already exist** (`Chi.lean:98,102`), as does the
iso-level `HModule.mapEquiv` (`Chi.lean:57`) and the multiplication iso
`mulEquivDivisorSheaf : 𝒪(D) ≅ 𝒪(D − div g)` (`MulEquiv.lean`). So the exact statement
FLV's outer quantifier needs is a carbon copy of the landed
`chi_divisorSheaf_eq_of_picClass_eq` (`Degree.lean:80`) with `h1_congr` (and `h0_congr`)
in place of `chi_congr`, plus the `Subsingleton` transport through `mapEquiv`:

```
theorem h1_divisorSheaf_eq_of_picClass_eq  (h : picClass K D = picClass K D') :
    Sheaf.h1 (X.divisorSheaf K D) = Sheaf.h1 (X.divisorSheaf K D')          -- + h0 twin
theorem subsingleton_hModule_one_of_picClass_eq (h : picClass K D = picClass K D') :
    Subsingleton (HModule (X.divisorSheaf K D) 1) →
    Subsingleton (HModule (X.divisorSheaf K D') 1)
```

Proof: extraction (X) + `mulEquivDivisorSheaf` + congr — verbatim the landed χ proof.
**Decision: W6-lite is an S-brick on landed API, land it now, and record on the G-D2
worksheet that the resurrected W6, in the form FLV itself consumes, has collapsed.**

### 3.2 W6-full — the engine seam (REAL, M, owned by the datum lane, NOT by FLV)

What did *not* collapse: the w4-datum §4.2 wording — identify the ENGINE's fibre
cohomology (the cocycle-glued sheaf presenting `λ_K`, w4-1's constructor) with the
ledger's h⁰/h¹ (of `divisorSheaf` of a witness). Pin it as:

> **(W6-full)** For a meromorphic presentation `P : X.MeromorphicPresentation` (landed
> structure: pointed cover + `f : ι → K(X)ˣ` with the ratio/cocycle property), an
> isomorphism of sheaves of `K`-modules
> `gluedSheaf P ≅ X.divisorSheaf K (presentationDivisor K P)`
> where `gluedSheaf P` is w4-1's cocycle-glued constructor on `P`'s cover with cocycle
> the ratios of `P` — components `s ↦ f_i·s` (the `mulEquivDivisorSheaf` mechanism,
> chartwise); **plus** the transport "cohomologous cocycles ⟹ isomorphic glued sheaves"
> (the m-chart generalization of the landed 2-cover `congrCoeff` pattern,
> `RelativeTwoCover.lean:87`).

Consumers: the datum's fibrewise anchor — transporting FLV's `Subsingleton` from the
witness `divisorSheaf` to the engine's fiber sheaf, discharging CBC-2/CBC-3's
`H¹(X_t, L_t) = 0` hypothesis (Kleiman lines 98–102). FLV's own statements never
mention glued sheaves, so **W6-full is scheduled with w4-2 (cbc-lite completion), after
w4-1 fixes the constructor**; its exact spelling depends on that constructor and must
not be frozen here. FLV does not gate on it; the datum's *use* of FLV does.

---

## §4 Sub-bricks, sizes, delegability, fallbacks, consumption map

Sizes per recon convention (S ≤ ~150 lines, M ~150–350, L ~350–500). All bricks
field-level, on the abstract pack unless said otherwise; kernel discipline §"Discipline".

- **W6-lite [S, Opus, deps: NONE — land now].** §3.1's three lemmas next to
  `Degree.lean`'s χ-twin. Also closes the degree-lane AMENDMENT debt in its FLV-facing
  form (comment on the G-D2 worksheet at landing).
- **FLV-0 [S→M, Opus, deps: w4-5 for the re-exposed overlap-=-basicOpen lemmas —
  else include them] — the fiber toolkit.** `u : K(X)ˣ` from the chart coordinate
  (`germGenericUnits` + w4-5's unit-on-overlap), `fiberDivisor K π := (divOf u)⁺`
  (positive-part calculus on `CurveDivisor` — respect the `single`-calculus discipline,
  never raw `Finsupp` in binop positions), the ord table of §2.2 (`≥ 0` on `V₁`, `= 0`
  on the overlap, `≤ 0` on `V₀`), `supp ⊆ V₁ ∖ V₀` finite, `0 < deg (fiberDivisor)` and
  **pole existence `fiberDivisor ≠ 0`** — two candidate discharges, spec picks after a
  probe: (i) transcendence of `u` over `K` vs `Module.Finite K H⁰(𝒪)` (works on the
  abstract pack); (ii) at the curve layer: `u ∈ Γ(⊤) ≅ K` would make a fiber of the
  finite `π` all of `X`. COORDINATION: w4-5 owns the class/degree side of the twist
  (`Θ_n`, `deg = n·deg π`, two-cover triviality) and must stay field-generic; FLV-0 owns
  the `K(X)ˣ`/ord side. No duplicate statements.
- **FLV-1 [M, Opus, deps: FLV-0] — the lattice identities.** The three submodule
  equalities of §2.1 (`𝒪(D+n•F)` over `V₀`, overlap, `V₁ = u⁻ⁿ•M₁` — via
  `mem_boundedSections`-level ord bookkeeping; check whether `MulEquiv.lean`'s
  section-level `mulByUnit` is public, else re-derive the two-line ord identity),
  monotonicity `Aₙ ≤ Aₙ₊₁`, exhaustion `⨆ₙ Aₙ = ⊤` (pole-clearing at the finite fiber
  set), the general-`F` `range_diff_eq`. Everything stated as submodule facts in
  `K(X)` first, then transported to the section-module quotients — D1 discipline.
- **FLV-2 [M, Opus from a tight spec, deps: **w4-1** + FLV-1] — the carrier.**
  `QcohOn (X.divisorSheaf K D) Vᵢ` discharge ((P1)/(P2a)/(P2b) per §2.3) + the two
  `Subsingleton (HModule' … Vᵢ 1)` instances + the named equiv
  `HModule (divisorSheaf K D') 1 ≃ₗ[K] N ⧸ Aₙ` for each twist. STRONG RECOMMENDATION:
  attach FLV-2 to w4-1's acceptance as the port's first external instance — it exercises
  the fresh `QcohOn` interface immediately and catches drift while the port session is
  live. FALLBACKS if w4-1 slips or the interface fights: (fb-i) land FLV-3 with the two
  `Subsingleton (HModule' …)` instances as explicit hypotheses (acceptable staged
  landing; FLV-4 then carries them too); (fb-ii) Route N of §2.4 (w4-1-independent,
  ~2 bricks M/L) — reserve.
- **FLV-3 [M, FABLE — the heart; deps: FLV-1, FLV-2] — FLV-fiber.** The stabilization
  endgame: the general "increasing ℕ-chain, `⨆ = ⊤`, finite-codim base ⟹ eventually
  `⊤`" lemma (images in `N ⧸ A₀`, `IsNoetherian` from `FiniteDimensional`,
  `monotone_stabilizes`; finite codim at the base from the landed
  `moduleFinite_hModule_divisorSheaf_one` through FLV-2's equiv), then
  `subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1` exactly as in §1.2.
- **FLV-4 [M, Opus, deps: FLV-3, W6-lite] — FLV-class + the reduction.** §2.5's steps:
  effective-witness-from-degree (`riemann_inequality` + section↦`divOf` bookkeeping +
  `picClass_divOf`), effective-peeling `Subsingleton` transport (slice surjection +
  ℕ-induction on `deg E`), the `m(n)` arithmetic, the curve-layer statement, the `C_K`
  smoke test (mirror `BaseChangeInstances` item 6), and the §1.2 rank corollary.
  Blueprint the campaign at this brick (source note: this is Serre-vanishing-on-ℙ¹
  specialized through a finite cover — check `hartshorne-algebraic-geometry` III.5.2 /
  `papaioannou-algebraic-rr` for an honest match before anchoring; cite Kleiman 4.8
  only for the strata *consumption*, lines 64–90).

Dependency order: `W6-lite ∥ (w4-5 → FLV-0 → FLV-1)` → [w4-1] → FLV-2 → FLV-3 → FLV-4.
Everything except FLV-2/3/4 is launchable before the port lands.

**Consumption map (who cites what):**

| FLV deliverable | Consumer |
|---|---|
| FLV-class (`exists_subsingleton…classDeg`) | w4-6 datum: strata `P^φ_m` fibrewise membership + exhaustion of the nested opens (Kleiman 4.8.2/4.8.3, lines 64–90); the a-posteriori `QuasiCompact J.hom` argument |
| FLV-class through **W6-full** (w4-2's seam) | CBC-2's "iso unconditionally when `H¹ = 0`" and CBC-3's `H¹(C_R, L) = 0` hypothesis at fibers (recon §0.2); w4-3/G-CBC-6's fibrewise input (Kleiman 3.10 (v)⟹(i), line 100) |
| Rank corollary (`h⁰ = deg − g + 1`) | CBC-3 / w4-3: the rank of Kleiman's `Q`, hence the `ℙ(Q)` chart dimension |
| FLV-fiber (conditional-on-π form) | reusable directly if the datum later pins the `P1`-base-change identification; also any future per-point vanishing need |
| W6-lite | FLV-4 (witness-independence); G-D6/degAt convenience; closes the G-D2 AMENDMENT in its FLV-facing form |
| `QcohOn (divisorSheaf)` instance (FLV-2) | w4-1's port: its second discharge family, per w4-datum §3.2 — shared deliverable |

**Hypothesis-supplier note for the datum spec-writer:** FLV-class takes
`1 ≤ classDeg K θ`. At a fiber, `θ := ` the `Θ_1`-fiber class; its degree is `deg π ≥ 1`
by w4-5's degree lemma transported to the fiber — that transport ("degree of the
pulled-back class", degAt/G-D6 territory) is the consumer's obligation, deliberately
outside FLV.

## Discipline (inherited, binding)

All standing kernel/elaboration rules (handoff 2026-07-14, both protocol sections;
parallel-prover lake spinlock). Specific to this campaign: (1) D1 — every lattice
comparison is a `Submodule K X.functionField` fact FIRST; if a proof is gluing sections,
it has left the route — stop and restate. (2) The submodule-of-submodule friction
(§5.2) is the named elaboration hazard: quotient carriers `F(V₀⊓V₁) ⧸ range moduleDiff`
vs `K(X)`-submodule lattice — bridge ONCE through named opaque defs (`fiberLattice`-style
`Q₀ Q₁ₙ Aₙ` + comap/map lemmas), never inline. (3) `CurveDivisor` arithmetic through the
`single`-calculus only (the landed `binop%` gotcha). (4) K explicit-first per the
RiemannRoch convention; `Subsingleton` conclusions, never bare `finrank = 0`. (5) Files
≤ 500 lines; lean_verify (MCP) axiom checks; no new axioms.

## §5 Honest risks — what reading could not settle

1. **The `QcohOn` interface does not exist yet** (w4-1 unlanded). The (P1)/(P2)
   discharge of §2.3 is verified feasible *against the w4-datum §3.2 pin*, not against
   compiled code. If the port ships a different packaging (e.g. constructor-only per
   w4-datum §5.3), FLV-2 renegotiates — mitigations: attach FLV-2 to w4-1's acceptance;
   fallbacks fb-i/fb-ii. This is the campaign's only external gate.
2. **Coercion friction.** `N ⧸ Aₙ` lives on `ModuleCat.of K (divisorSections …)`
   carriers; ranges of `moduleDiff` vs submodules of `K(X)` is the classic
   submodule-of-submodule quagmire. Bounded but real; it is why FLV-3 is Fable-graded.
3. **Pole existence** (`fiberDivisor ≠ 0`): both discharge routes (§4 FLV-0) are
   sketches; the transcendence route needs a `K(t) ↪ K(X)` seam whose landed form I did
   not verify (check `P1Charts`/`RationalToP1` at spec time). If both fight, FLV-fiber
   takes `fiberDivisor K π ≠ 0` as a hypothesis and the curve layer discharges it for
   the constructed π — acceptable, ugly, recorded.
4. **`linearEquiv₀` (`HModule F 0 ≃ F(⊤)`) generality**: FLV-4's effective-witness step
   uses it for `divisorSheaf`; the recon table asserts it general in `F`
   (`OverOpen.lean:269` adjacency) but I did not re-read that file this pass.
5. **Positive-part calculus on `CurveDivisor`**: mathlib `Finsupp` lattice ops exist,
   but the tree's opaque-wrapper discipline may force a small bespoke `posPart` +
   lemmas in FLV-0. Cosmetic risk only.
6. **Sharpness debt is knowingly taken**: per-class `n₀` forces the strata bookkeeping
   in w4-6 (increasing unions of opens; Kleiman line 88). That cost was accepted by the
   w4-datum default before this worksheet; nothing here worsens it. If a uniform bound
   is ever wanted, route (c)/(d) notes stand.

*End of worksheet. Deliverable of record for w4-4's WORKSHEET-FIRST obligation
(w4-datum §4.1); binding for the FLV brick specs; W6's split (§3) to be echoed on the
G-D2 worksheet and the roadmap subitems by the orchestrator.*
