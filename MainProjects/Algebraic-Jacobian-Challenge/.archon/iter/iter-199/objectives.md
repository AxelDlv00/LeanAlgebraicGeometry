# Iter-199 prover-lane objectives

Reference-anchored per USER 2026-05-28 directive #3. All lanes
default to `mathlib-build` per USER directive #3.

## Lane 1 — WeilDivisor.lean (Lane WD-A4a-Noeth)

### Target

Build a new private helper
`AlgebraicGeometry.Scheme.rationalMap_order_finite_support_of_isNoetherian`
axiom-clean under `[IsNoetherian X]`.

### Recipe

Stacks 02RV / Hartshorne Lemma 6.1:

1. Pick a nonempty affine open `U = Spec R ⊆ X` on which `f` is
   regular (`R = Γ(U, 𝒪_X)`).
2. `R` is a Noetherian integral domain (from
   `[IsLocallyNoetherian X]` + `[IsIntegral X]`).
3. For each prime divisor `Y` whose generic point lies in `U`, the
   corresponding prime `𝔭_Y ⊂ R` is a height-1 prime. The
   height-1 primes containing `f` are precisely the minimal primes
   of `(f) ⊂ R`, which is a finite set
   (`Ideal.finite_minimalPrimes_of_isNoetherianRing`, Stacks 00KZ
   / Krull's Hauptidealsatz).
4. For prime divisors `Y` outside `U`: `X \ U` is a closed subset
   of `X`. Under `[IsNoetherian X]` (= locally Noeth + compact),
   `X` is Noetherian as a topological space (Stacks 04ZE), so
   `X \ U` has finitely many irreducible components. Each codim-1
   component contributes at most one nonzero order; bound by the
   `IsRegularInCodimensionOne` hypothesis on `X`.
5. Sum of finite + finite = finite.

### Mathlib pieces

- `Ideal.finite_minimalPrimes_of_isNoetherianRing` — height-1
  minimal primes are finite [verified].
- `Ideal.minimalPrimes_finset` — Finset version [verified].
- `TopologicalSpace.NoetherianSpace.finite_irreducibleComponents`
  — Noetherian space has finitely many irreducible components
  [verified].
- `Scheme.affineCover` / `Scheme.affineOpenCover` for picking the
  affine chart [verified].
- `Ring.ordFrac` valuation on `Frac R` for the order function
  [verified].

### Scope fence

- **DO NOT** modify the public `rationalMap_order_finite_support`
  declaration's signature or body. The public sorry at L325 (under
  `[IsLocallyNoetherian X]`) stays as documented gap.
- **DO NOT** touch L538 (`principal_degree_zero` non-constant
  branch) or L1108 (`degree_positivePart_principal_eq_finrank`).
  Both RR.1 / Route C, off-limits.

### Hard bar

Land `rationalMap_order_finite_support_of_isNoetherian` axiom-clean
({propext, Classical.choice, Quot.sound}).

### Push-beyond

- Scan §1-§2 for additional A.4.a substrate sharpening (e.g., a
  partial-bound version where the user supplies an explicit
  finset of "candidate" prime divisors).
- Probe whether the public-facing declaration's `sorry` body can
  be reduced to a single "produce `[CompactSpace X]`" gap that the
  USER can independently decide on.

### Blueprint

`chapters/RiemannRoch_WeilDivisor.tex` §"Principal divisors"
`lem:rationalMap_order_finite_support` (added iter-199).

---

## Lane 2 — AuslanderBuchsbaum.lean (Lane AB-gap1)

### Target

Build gap (1) substrate: a Mathlib-style API for **minimal free
resolutions over a Noetherian local ring** with the "matrix
coefficients land in 𝔪" property (Stacks 00LK /
`lemma-add-trivial-complex`).

### Recipe

Bruns-Herzog §1.5 + Stacks 00LK:

1. Define (or wire to Mathlib's
   `Module.FiniteFreeResolution` if it exists) the substrate
   `Module.MinimalFiniteFreeResolution` for a finite module `M`
   over a Noetherian local ring `(R, 𝔪)`: a finite free
   resolution `F → M` with each transition map's matrix having
   coefficients in `𝔪` (equivalently, `F ⊗_R κ` has zero
   differentials).
2. Prove the existence theorem: every finite `R`-module of finite
   projective dimension has a minimal finite free resolution of
   length equal to its projective dimension.
3. (Stretch) Prove the "trim trivial summands" lemma allowing any
   finite free resolution to be trimmed to minimal.

### Mathlib pieces

- `Module.projectiveDimension` (= `CategoryTheory.projectiveDimension`
  on `ModuleCat`) [verified].
- `Module.Free`, `Module.Finite`, `Module.FinitePresentation`
  [verified].
- `ChainComplex ℕ (ModuleCat R)`,
  `CategoryTheory.ProjectiveResolution` [verified].
- Nakayama's lemma in `Mathlib.RingTheory.Nakayama` for the
  matrix-coefficients-in-𝔪 characterization [verified].

### Scope fence

- **DO NOT** carve `auslander_buchsbaum_formula_succ_pd` into
  case-split sorries (per iter-198 prover discipline: would
  inflate sorry count without closing any branch).
- **DO NOT** attempt gaps (2)-(3) substrate; iter-200+ planner
  schedule.

### In-passing fix

Update the stale docstring header on
`auslander_buchsbaum_formula_succ_pd` (L1241 area). Current text:
"All four pieces are absent:" — Gap (4) was closed iter-198, so
update to "Gap (4) `lemma-depth-drops-by-one` closed iter-198;
gaps (1)-(3) absent (this iter targets gap (1))". Also update
the stale re-engagement plan "iter-196 first slice: piece (4)" to
"iter-198 closed piece (4); iter-199 begins piece (1)".

### Hard bar

Land the minimal-resolution substrate axiom-clean.

### Push-beyond

- Begin gap (3) snake-lemma-on-minimal-resolution if gap (1) lands
  in single iter.
- Probe gap (2) "what is exact" Stacks 00MF as a candidate Mathlib
  upstream PR.

### Blueprint

`chapters/Albanese_AuslanderBuchsbaum.tex`
`lem:auslander_buchsbaum_formula_succ_pd` (added iter-199) +
§"Step 1: minimal free resolution".

---

## Lane 3 — CodimOneExtension.lean (Lane COE-stage6-iiA)

### Target

Build sub-gap (ii.A) Stacks 02JK closed-point case:
`Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler_of_isAlgClosed`
(intended Mathlib-style name) — over an algebraically closed
field `k̄`, the cotangent space at a closed point of a smooth
`k̄`-algebra equals the residue-field base change of the
Kähler differentials.

### Recipe

Stacks 02JK + iter-199 `mathlib-analogist coe-stacks02jk`
report (will provide structural-pattern guidance):

1. Set-up: `R` a smooth `k̄`-algebra, `𝔪 ⊂ R` a maximal ideal with
   `R/𝔪 = κ = k̄` (closed point).
2. The conormal sequence (Mathlib
   `KaehlerDifferential.exact_mapBaseChange_map`) gives exactness
   of `I/I² → κ ⊗_R Ω[R/k̄] → Ω[κ/k̄] → 0` where `I` is the
   kernel of `R → κ`.
3. `Ω[κ/k̄] = 0` since `κ = k̄` (the identity ring extension has
   trivial differentials).
4. The kernel of `κ ⊗_R Ω[R/k̄] → 0` is the whole space, so the
   map `m/m² → κ ⊗ Ω[R/k̄]` is *surjective* by exactness.
5. Injectivity: use the smoothness hypothesis to identify
   `m/m² → κ ⊗ Ω[R/k̄]` with `Module.Cotangent` → `Module.BaseChange`,
   which the
   `Algebra.IsStandardSmoothOfRelativeDimension` localization gives
   in terms of `Module.Free` structure (per iter-198 6.B-RHS
   substrate).

### Mathlib pieces

- `Algebra.KaehlerDifferential.exact_mapBaseChange_map` [verified].
- `KaehlerDifferential.kerToTensor` [verified].
- `Module.Cotangent`, `LocalRing.cotangentSpace` [expected;
  verify].
- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  [verified iter-198].
- `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified
  iter-198].
- `Module.Cotangent.equivQuotientMaximalIdealPow` (?) [expected;
  verify].

### Scope fence

- **DO NOT** attempt sub-gap (ii.B) Stacks 00OE Krull-dim formula
  this iter. Independent gap, ~200-300 LOC.
- **DO NOT** close the trailing sorry at L526 of
  `isRegularLocalRing_stalk_of_smooth` cold; the closure pattern
  documented at L606-L612 requires BOTH (ii.A) and (ii.B). Landing
  (ii.A) only narrows the trailing sorry to (ii.B).

### Hard bar

Land closed-point iso `cotangent_iso_residue_tensor_kaehler_of_isAlgClosed`
axiom-clean.

### Push-beyond

- Substantive progress toward (ii.B) Stacks 00OE.
- General-field variant of (ii.A) if closed-point case lands
  cleanly.

### Blueprint

`chapters/Albanese_CodimOneExtension.tex`
`subsec:stage6_subgap_decomposition` 6.B (existing).

### Mathlib-analogist findings (READ FIRST)

`mathlib-analogist coe-stacks02jk` returned a concrete 40-70 LOC
recipe (cutting the original 100-200 LOC estimate by ~half):

Use **`Algebra.FormallySmooth.iff_split_injection`** from
`Mathlib.RingTheory.Smooth.Basic` — it packages the missing
retraction (giving injectivity of `kerCotangentToTensor`) as an
iff-equivalent of `Algebra.FormallySmooth R A`. In our setting
(R = k̄, P = S_m, A = κ = k̄ at a k̄-rational closed point):

- The smooth-of-relative-dimension hypothesis on `S_m/k̄` already
  supplies `Algebra.FormallySmooth k̄ S_m`.
- `Algebra.FormallySmooth k̄ κ` is automatic since `κ = k̄`
  (identity algebra map).

3-step proof shape (per analogist):

1. retraction → injectivity via
   `Algebra.FormallySmooth.iff_split_injection`.
2. `Ω[κ/k̄] = 0` (since `κ = k̄`) +
   `exact_kerCotangentToTensor_mapBaseChange` → surjectivity.
3. bijective + linear-equiv-of-bijective → iso.

Extract as fresh private theorem
`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`
(NOT the originally-suggested `_of_isAlgClosed` name — the
`formallySmooth_residue` formulation is more reusable). Consume in
`isRegularLocalRing_stalk_of_smooth` via `LinearEquiv.finrank_eq`
against the iter-198 6.B-RHS substrate
(`finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension`).

The κ-linearity upgrade (from natively `S_m`-linear
`kerCotangentToTensor`) threads through
`IsLocalRing.instModuleResidueFieldCotangentSpace` +
`IsLocalRing.instIsScalarTowerResidueFieldCotangentSpace`. If
that snags, fall back to `Algebra.Extension.formallySmooth_iff_split_injection`
which carries the residue-field module structure cleanly via
`Algebra.Extension.CotangentSpace`.

Persistent notes: `analogies/coe-stacks02jk.md` (mathlib-analogist
writes this; read it before starting).
Full report: `task_results/mathlib-analogist-coe-stacks02jk.md`
(auto-archived to `logs/iter-199/`).

---

## Lane 4 — FGAPicRepresentability.lean (Lane FGA-sorry4)

### Target

Close Sorry 4 = `smoothProperQuotient` body, L354 (Rank 2 per
iter-198 `fga-sorry-order` chapter expansion).

### Recipe

Altman-Kleiman effective-equivalence-relation descent (FGA
Explained Ch.9 / Kleiman §4.x) + Stacks 09Y:

1. Set-up: an effective equivalence relation `R ⇒ X` on a smooth
   `k`-scheme `X` with `R` smooth proper over `k` and the action
   map `R → X × X` a closed immersion.
2. The descent: `X/R` exists as a scheme; the quotient map
   `X → X/R` is smooth and proper.
3. Concrete construction via Mathlib's `CategoryTheory.Quotient`
   on `Scheme.{u}` + smooth/proper instance derivation through
   the quotient functor.

### Mathlib pieces

- `CategoryTheory.Quotient` [verified].
- `AlgebraicGeometry.Smooth`, `AlgebraicGeometry.IsProper`
  [verified].
- `AlgebraicGeometry.Scheme.Quotient` (?) [expected; verify].

### Scope fence

- **DO NOT** modify any of the other 6 `⟨sorry⟩` instances in the
  file. They remain isolation points per the iter-198 carrier-
  soundness probe verdict CONFIRM.
- **DO NOT** modify the public `representable` signature or
  surrounding `[HasPicScheme C]` consumers.

### Hard bar

Close Sorry 4 axiom-clean.

### Push-beyond

- Scan Sorries 1-3 (Rank 1 per iter-198 chapter) for additional
  in-iter closures.
- Document any newly-discovered Mathlib gap encountered.

### Blueprint

`chapters/Picard_FGAPicRepresentability.tex` §"Sorry-by-sorry
closure order" (added iter-198) — find the Sorry 4 paragraph for
the concrete spec.
