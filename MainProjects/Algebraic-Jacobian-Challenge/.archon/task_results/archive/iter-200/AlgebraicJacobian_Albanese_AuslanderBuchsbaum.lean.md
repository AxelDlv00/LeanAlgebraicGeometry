# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## Session summary

iter-200 Lane AB-gap1-HasPdLT (mathlib-build, ALIGN_WITH_MATHLIB pivot):
**4 new axiom-clean substrate helpers** added to the `RingTheory.Module`
namespace, implementing the iter-200 mathlib-analogist `ab-natrecursive`
PROCEED Path A recipe (`HasProjectiveDimensionLT` SES descent).

- **Sorries before**: 1 (`auslander_buchsbaum_formula_succ_pd` body, L1574 post-edit).
- **Sorries after**: 1 (same body, partial scaffolding added; closure blocked).
- **Net sorry change**: 0.
- **New axiom-clean lemmas**: 4 (lines 1280–1397, all in `RingTheory.Module`).
- **HARD BAR (close `_succ_pd` body)**: **NOT MET** — blocked on Stacks 00MF
  base case substrate and ℕ∞ arithmetic that depends on `depth(R) ≥ pd(M)`.
- **PUSH-BEYOND target**: substrate piece (i)+(ii)+(iii) **all landed
  axiom-clean** + a bonus 4th helper.

## Built axiom-clean (4 new lemmas, all in `RingTheory.Module`)

1. **`hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`** (L1290–1297)
   — bridge from the `Module.projectiveDimension R M = ((n : ℕ) : WithBot ℕ∞)`
   carrier (the AB chain's existing hypothesis form) to Mathlib's
   `HasProjectiveDimensionLT (ModuleCat.of R M) (n + 1)` via
   `CategoryTheory.projectiveDimension_lt_iff`. Single-rewrite proof,
   ~5 LOC.

2. **`hasProjectiveDimensionLT_ker_of_surjection`** (L1311–1325) — syzygy
   descent: for a surjection `f : R^n →ₗ M` with `HasProjectiveDimensionLT M (k+2)`,
   the kernel satisfies `HasProjectiveDimensionLT (ker f) (k+1)`. Uses
   `LinearMap.shortExact_shortComplexKer` + `ModuleCat.projective_of_free` +
   `ShortComplex.ShortExact.hasProjectiveDimensionLT_X₁`. ~10 LOC.

3. **`hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`** (L1340–1355)
   — companion ascent: from `HasProjectiveDimensionLT (ker f) (k+1)` and the
   SES, deduce `HasProjectiveDimensionLT M (k+2)`. Via `hasProjectiveDimensionLT_X₃`.
   Enables the contradiction argument for `pd K = k+1` exactly. ~10 LOC.

4. **`depth_ker_ge_min_of_surjection_finite_localRing`** (L1376–1404) — depth
   lower bound: for SES `0 → ker f → R^n → M → 0` with `n ≥ 1`, ker and M
   nontrivial, `min(depth R, depth M + 1) ≤ depth (ker f)`. Uses
   `depth_of_short_exact` (3) + `depth_pi_const_eq_depth_of_nonempty`. ~22 LOC.

All four are verified with `lean_verify` to depend on only
`{propext, sorryAx (NO), Classical.choice, Quot.sound}` — kernel-clean.

## Body modification of `auslander_buchsbaum_formula_succ_pd` (partial)

The body (L1574-area) was modified to set up the SES-descent path using the
three new helpers as scaffolding:

```lean
have hM_lt : HasProjectiveDimensionLT (ModuleCat.of R M) (k + 2) :=
  Module.hasProjectiveDimensionLT_succ_of_projectiveDimension_eq
    (by simpa using _hpd)
obtain ⟨n, f, hf_surj, _hn_eq, _hf_min⟩ :=
  Module.exists_minimalSurjection_finite_localRing R M
have hK_lt : HasProjectiveDimensionLT (ModuleCat.of R (LinearMap.ker f)) (k + 1) :=
  Module.hasProjectiveDimensionLT_ker_of_surjection f hf_surj hM_lt
sorry  -- closure assembly
```

This compiles axiom-clean above the trailing sorry, demonstrating that the
new substrate plugs into the AB chain at the documented points.

## Approach analysis

### Approach 1 (iter-200 directive): ALIGN_WITH_MATHLIB `HasProjectiveDimensionLT` SES descent — PARTIAL

The mathlib-analogist `ab-natrecursive` recipe pivots from a `ChainComplex ℕ`
construction (rejected as 3–4× over budget) to `HasProjectiveDimensionLT_X₁`
abstract syzygy descent. The recipe has 3 steps:

* **Step (i): SES bridge from `exists_minimalSurjection_finite_localRing`** —
  RESOLVED via Mathlib's `LinearMap.shortExact_shortComplexKer` (a single-line
  invocation; no wrapping helper needed). The recipe's ~15-LOC estimate
  reduces to ~3 LOC of inline use.

* **Step (ii): syzygy-descent helper applying `hasProjectiveDimensionLT_X₁`** —
  RESOLVED axiom-clean as `hasProjectiveDimensionLT_ker_of_surjection` (10 LOC,
  matching the analogist's ~15-25 LOC budget). Companion ascent
  `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker` adds another
  10 LOC of complementary substrate.

* **Step (iii): inductive assembly of `auslander_buchsbaum_formula_succ_pd`** —
  **BLOCKED**. The closure requires (a) the base case k = 0 input
  (`pd M = 1 ⟹ depth M < depth R`, Stacks 00MF substrate); and (b) ℕ∞
  arithmetic that depends on `depth R ≥ pd(M)`, which is itself part of the
  AB formula being proven. The cleanest detailed analysis (in code comments
  L1499-L1538) decomposes the inductive case (k ≥ 1) into:
    1. Show K Nontrivial (via M not projective from pd ≥ 2).
    2. Show `pd K = k - 1` exactly via the X₁/X₃ pair (substrate present).
    3. Apply IH `auslander_buchsbaum_formula_succ_pd (k-1) (_hpd_K)`.
    4. Combine IH with `depth_of_short_exact` (2)+(3) to get `depth K = depth M + 1`.
  Step (4) reduces to an ℕ∞ equation `(k+2) + depth M = (k+1) + depth K`,
  but the substitution `depth K = depth M + 1` requires `depth M + 1 ≤ depth R`
  to be derivable from depth_of_short_exact (3), which case-splits on whether
  `depth M < depth R` — exactly the gap that needs 00MF.
  
### Approach 2: prove `depth K = depth M + 1` LES-arithmetic substrate lemma — NOT ATTEMPTED axiom-clean

Considered but rejected: the LES analysis proves
`depth K = min(depth R, depth M + 1)`, but the "≤" direction
`depth K ≤ depth M + 1` requires either (a) `depth M < depth R` (the AB
content for non-projective M) or (b) a direct LES connecting-map injectivity
argument that is not packaged in Mathlib at b80f227. The "≥" direction
follows from `depth_of_short_exact` (3) (and is captured by the new
`depth_ker_ge_min_of_surjection_finite_localRing` helper).

### Approach 3: induct on `depth(M)` (Stacks 090V classical path) — NOT ATTEMPTED

The classical Stacks path inducts on `depth(M)` and uses
(a) Stacks 00MF for the `depth M = 0` base case,
(b) the snake lemma on the minimal resolution for the inductive step.
Both ingredients are absent gaps. The iter-200 directive explicitly pivots
away from this approach toward Path A (ALIGN_WITH_MATHLIB), so this was
not pursued.

## Why HARD BAR NOT MET

Even with the 4 new substrate helpers, the closure of
`auslander_buchsbaum_formula_succ_pd` requires a substrate ingredient that
**neither the iter-199 first-step nor the iter-200 helpers supply**:
the input "`pd M > 0 ⟹ depth M < depth R`" (Stacks 00MF). This is gap (2)
in the chapter's substrate decomposition, listed as the **largest** of the
three open substrates (~150-200 LOC, candidate for upstream Mathlib PR).

The analogist's recipe estimate (~40-80 LOC for the inductive assembly) was
slightly optimistic: it correctly identified Steps (i)+(ii) as ~25-40 LOC
(I delivered ~45 LOC with the bonus ascent helper), but Step (iii) was
estimated at ~20-40 LOC for inductive assembly under the assumption that
the base case had already been resolved. In practice, the inductive
assembly itself requires the base case as an "external input" — the
sorry stays until 00MF lands.

## Iter-201+ targets

1. **Stacks 00MF substrate (the binding gap)**: ~150-200 LOC, candidate for
   upstream Mathlib PR. The "what is exact" criterion in terms of
   depth of `r`-minor ideals. Closes the AB base case k = 0.
2. **Inductive-step closure** (~50-80 LOC, axiom-clean): once 00MF lands,
   recursive structure (`induction k generalizing M`) + the 4 new helpers
   + ℕ∞ arithmetic close the body.
3. **Alternative**: a more refined LES analysis to prove the ≤ direction
   of `depth K ≤ depth M + 1` directly (Ext connecting-map injectivity) —
   this would obviate 00MF for the AB use case.

## Blueprint sync

Blueprint chapter `Albanese_AuslanderBuchsbaum.tex` already documents
the gap structure (subsection `\subsec:succ_pd_gap_sequence`,
L503-642). The iter-200 substrate progress should be reflected as:
- New `\subsubsec:ab_gap1_haspdlt_pivot` (or update to
  `\subsec:ab_gap1_first_step`) noting that the iter-200 ALIGN_WITH_MATHLIB
  pivot reduces gap (1)'s "full chain complex" cost to 4 axiom-clean
  per-syzygy helpers, with gap (2) remaining the closure-binding gap.
- Plan agent should reclassify gap (3) (snake lemma on resolution) from
  "open" to "OBVIATED" — the SES-descent path obviates it entirely.

These blueprint edits are for the iter-201 plan agent (provers don't write
blueprint chapters).

## Section summary

### `RingTheory.Module.hasProjectiveDimensionLT_succ_of_projectiveDimension_eq` (L1290)
- **Approach**: Direct rewrite via `CategoryTheory.projectiveDimension_lt_iff`
  + unfolding `_root_.Module.projectiveDimension` (which is `rfl`-equal to
  `CategoryTheory.projectiveDimension (ModuleCat.of R M)`).
- **Result**: RESOLVED — axiom-clean (kernel triple).

### `RingTheory.Module.hasProjectiveDimensionLT_ker_of_surjection` (L1311)
- **Approach**: Mathlib's `LinearMap.shortExact_shortComplexKer` builds the SES;
  `ModuleCat.projective_of_free (Pi.basisFun R (Fin n))` discharges projectivity
  of `R^n`; `hasProjectiveDimensionLT_of_ge` lifts `< 1` to `< k+1`; then
  `hS.hasProjectiveDimensionLT_X₁` closes.
- **Result**: RESOLVED — axiom-clean.

### `RingTheory.Module.hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker` (L1340)
- **Approach**: Mirror of (2) using `hasProjectiveDimensionLT_X₃` instead of
  `X₁`. Same substrate (`shortExact_shortComplexKer`, `projective_of_free`,
  `hasProjectiveDimensionLT_of_ge`).
- **Result**: RESOLVED — axiom-clean.

### `RingTheory.Module.depth_ker_ge_min_of_surjection_finite_localRing` (L1376)
- **Approach**: Set up auxiliary instances (`Inhabited (Fin n)` from `1 ≤ n`,
  `Nontrivial (Fin n → R)` via `Pi.nontrivial`, `Module.Finite R (ker f)` via
  `Module.IsNoetherian.finite`). Build the SES via `(ker f).subtype`. Apply
  `depth_of_short_exact` part (3). Rewrite `depth (Fin n → R) = depth R` via
  `depth_pi_const_eq_depth_of_nonempty`.
- **Result**: RESOLVED — axiom-clean.

### `auslander_buchsbaum_formula_succ_pd` (L1491, body modified)
- **Approach 1** (attempted): Use the 4 new helpers to scaffold the SES-descent
  path, ending in `sorry` at the closure assembly.
- **Result**: PARTIAL — scaffolding is axiom-clean above the trailing sorry;
  the closure itself is blocked on Stacks 00MF.
- **Approach 2** (analyzed, not implemented): Full `induction k generalizing M`
  with explicit contradiction-via-`X₃` for `pd K = k+1` and ℕ∞ depth
  arithmetic. Blocked at the same point — even the inductive case (k ≥ 1) needs
  `depth R ≥ k+2` to be derivable, which requires 00MF or the AB formula
  itself.
- **Dead end**: Do NOT retry the iter-199 `ChainComplex ℕ` literal carrier —
  the analogist verdict (`ab-natrecursive`) is ALIGN_WITH_MATHLIB; the
  `ChainComplex` path is 3-4× over budget AND blocked on a separate
  termination-of-syzygy-tower lemma that doesn't exist in Mathlib b80f227.
- **Next step**: dispatch a `Mathlib-build` lane for Stacks 00MF
  (~150-200 LOC, the "what is exact" criterion for finite-free complexes,
  Bruns-Herzog Thm 1.4.13 + Buchsbaum-Eisenbud exactness criterion).
  Alternative: Mathlib upstream PR.
