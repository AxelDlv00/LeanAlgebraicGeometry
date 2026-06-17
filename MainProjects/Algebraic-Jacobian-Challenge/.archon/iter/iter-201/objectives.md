# Iter-201 objectives — detailed per-lane breakdown

## Dispatch shape

3 prover lanes + 5 plan-phase subagents (already dispatched).

## Lane WD-A4a-Sub-build-2 — `RiemannRoch/WeilDivisor.lean`

Prover mode: **mathlib-build**. Priority-1 (A.4.a root). Reference:
**Stacks 02RV / 02ME** + iter-200 task report Sub-build 2 preview.

### Substrate handoff (from iter-200 prover)

iter-200 +8 axiom-clean decls landed at L153-L305:

- `Scheme.PrimeDivisor.ext` (L153)
- `Scheme.PrimeDivisor.restrictToOpen` (L162) +
  `restrictToOpen_point` (L182)
- `Scheme.PrimeDivisor.ofOpen` (L174) + `ofOpen_point` (L187)
- `Scheme.PrimeDivisor.equivOpen` (L195)
- `Scheme.PrimeDivisor.stalkIso` (L210) — wrapper around Mathlib's
  `Scheme.Opens.stalkIso`
- `Scheme.IsRegularInCodimensionOne.instOpen` (L305) — open-immersion
  descent via `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing`

### iter-201 recipe (~30-50 LOC HARD BAR + ~20-30 LOC PUSH-BEYOND)

HARD BAR — `Ring.ordFrac` transport across ring iso:
```
lemma Ring.ordFrac_ringEquiv {R S : Type*} [CommRing R] [IsDomain R]
    [IsNoetherianRing R] [Ring.KrullDimLE 1 R]
    [CommRing S] [IsDomain S] [IsNoetherianRing S] [Ring.KrullDimLE 1 S]
    (e : R ≃+* S)
    (K_R K_S : Type*) [Field K_R] [Field K_S]
    [Algebra R K_R] [IsFractionRing R K_R]
    [Algebra S K_S] [IsFractionRing S K_S]
    (e_K : K_R ≃+* K_S)  -- compatible with e on R-image
    (x : K_R) :
    Ring.ordFrac S (e_K x) = Ring.ordFrac R x := …
```

Build via Mathlib's `IsFractionRing.ringEquivOfRingEquiv` and the
naturality of `Ring.ordMonoidWithZeroHom` at the base ring.

PUSH-BEYOND — scheme-level wrapper consuming the iter-200
`Scheme.PrimeDivisor.stalkIso`:

```
lemma Scheme.PrimeDivisor.ordFrac_stalkIso
    {X : Scheme} [IsIntegral X] [IsLocallyNoetherian X]
    {U : X.Opens} (Y : X.PrimeDivisor) (hYU : Y.point ∈ U)
    -- (typeclass thread: IsRegularInCodimensionOne U.toScheme; iter-200 instOpen)
    (f : X.functionField) :
    Ring.ordFrac (U.toScheme.presheaf.stalk (restrictToOpen U Y hYU).point)
      ((functionFieldOfOpenIso U Y).symm f) =
    Ring.ordFrac (X.presheaf.stalk Y.point) f := …
```

Lift through the iter-200 `stalkIso U Y hYU` + the function-field iso
`X.functionField ≃ U.toScheme.functionField` (Mathlib provides this iso
for integral X via the irreducibility of the generic point lying in
any non-empty open).

### Scope fence

- **Do NOT** touch L843 (`principal_degree_zero` non-constant branch)
  — Route C PAUSED.
- **Do NOT** touch L1413 (`degree_positivePart_principal_eq_finrank`)
  — Route C PAUSED.
- Public sorry at L535 (non-zero branch) stays as documented gap;
  closure awaits Sub-builds 2+3 (this iter = Sub-build 2 only).

### Why not skeletize / fine-grained

Substrate-build pattern; mathlib-build is the right mode for
"build axiom-clean substrate that consumers will plug into next iter".

## Lane AB-Stacks-00MF-or-LES — `Albanese/AuslanderBuchsbaum.lean`

Prover mode: **mathlib-build**. Priority-1 (A.4.b root). Reference:
**Stacks 00MF** (Path A) OR **LES-injectivity in Ext-chain** (Path B).
The mathlib-analogist `ab-stacks00mf` dispatched parallel; if Path B
is feasible per the analogist, follow it; else default Path A.

### Substrate handoff (from iter-200 prover + iter-199)

iter-200 +4 axiom-clean SES-descent helpers landed:

- `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq` (L1290)
- `hasProjectiveDimensionLT_ker_of_surjection` (L1311)
- `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker` (L1340)
- `depth_ker_ge_min_of_surjection_finite_localRing` (L1376)

iter-199 +1: `exists_minimalSurjection_finite_localRing` (the
per-syzygy step; gap (1) closed iter-199).

Body of `auslander_buchsbaum_formula_succ_pd` at L1517 scaffolded
up to L1571 axiom-clean; trailing sorry at L1574. The setup:

```lean
have hM_lt : HasProjectiveDimensionLT (ModuleCat.of R M) (k + 2) := …
obtain ⟨n, f, hf_surj, _hn_eq, _hf_min⟩ :=
  Module.exists_minimalSurjection_finite_localRing R M
have hK_lt : HasProjectiveDimensionLT (ModuleCat.of R (LinearMap.ker f)) (k + 1) :=
  Module.hasProjectiveDimensionLT_ker_of_surjection f hf_surj hM_lt
sorry  -- closure assembly
```

### iter-201 recipe (Path A or Path B per analogist)

**Path A — Stacks 00MF substrate (~150-200 LOC, mathlib-build):**

1. Define `Matrix.minorIdeal {R} (φ : Matrix m n R) (r : ℕ) : Ideal R`
   as `Ideal.span` over the `Finset` of all `Fin r → Fin m × Fin r → Fin n`
   sub-matrix determinants.
2. Prove the Buchsbaum-Eisenbud exactness criterion: a complex
   `R^{r_{i+1}} →φ_{i+1}→ R^{r_i} →φ_i→ R^{r_{i-1}}` is exact at
   `R^{r_i}` iff `rank φ_{i+1} + rank φ_i = r_i` and
   `depth(I(φ_i)) ≥ i` where `I(φ_i)` = ideal of `rank(φ_i)`-minors.
   Use Koszul-complex induction on `i`.
3. Derive corollary `pd M > 0 ⟹ depth M < depth R` from (2) applied
   at `i = 1` of the start of a minimal resolution of `M`.

**Path B — LES-injectivity sidestep (~50-80 LOC, if analogist names
a feasible path):**

1. From the iter-200 SES `0 → ker f → R^n → M → 0` plus the LES of
   `Ext^*_R(κ, -)`, derive
   `depth(ker f) ≤ depth(M) + 1` via an Ext-connecting-map
   injectivity argument that uses the start of the LES.
2. Combine with the iter-200 lower bound
   `depth_ker_ge_min_of_surjection_finite_localRing` for the equality
   `depth(ker f) = depth M + 1`.
3. Combine with the iter-200 helpers
   `hasProjectiveDimensionLT_ker_of_surjection` +
   `…_succ_of_hasProjectiveDimensionLT_ker` for the pd contradiction
   pinning `pd(ker f) = k` exactly.
4. Apply IH (`auslander_buchsbaum_formula_succ_pd` at `k`) to
   `ker f` to get `k + depth(ker f) = depth R`.
5. Rearrange `k + (depth M + 1) = depth R` to
   `(k+1) + depth M = depth R`.

### HARD BAR

Close `auslander_buchsbaum_formula_succ_pd` body axiom-clean +
remove `private` (per blueprint NOTE iter-201 option (1)).

### PUSH-BEYOND

If HARD BAR met, the main theorem
`auslander_buchsbaum_formula` (L1594) becomes axiom-clean
automatically (it currently delegates to the helper through
`auslander_buchsbaum_formula_succ_pd`); attempt
`auslander_buchsbaum_formula` axiom-clean inductive step too.

### Why mathlib-build

The Path A 00MF substrate is itself a project-side Mathlib-style build;
mathlib-build's no-sorry invariant guides incremental landings. Path B
is also a substrate-build (the LES-injectivity lemma is a project-local
substrate).

## Lane COE-Stage6.B-Jacobian — `Albanese/CodimOneExtension.lean`

Prover mode: **mathlib-build**. Priority-2 (A.4.c.0). Reference:
**Stacks 00SW / 00OW** + iter-200 task report Step 3 residual recipe
+ iter-201 mathlib-analogist `coe-stacks00sw` verdict.

### Substrate handoff (from iter-200 prover)

iter-200 +7 axiom-clean private substrate theorems landed at
L688-L800:

- Step 1: `ringKrullDim_localization_eq_height_atPrime` (L688)
- Step 2 LB: `MvPolynomial.maximalIdeal_height_ge_card_of_field` (L696)
- Step 2 UB: `MvPolynomial.maximalIdeal_height_le_natCard_of_field` (L717)
- Step 2 Fin n: `MvPolynomial.maximalIdeal_height_eq_card` (L727)
- Step 2 general: `MvPolynomial.maximalIdeal_height_eq_natCard` (L738)
- Capstone: `ringKrullDim_localization_atMaximal_MvPolynomial` (L767)
- Step 3 additive: `ringKrullDim_quotient_add_eq_of_regular_sequence` (L790)

Plus Stage 6.B (sub-gap ii.A, iter-199) `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`
+ 3 siblings axiom-clean.

Plus Stage 6 sub-gap (i) discharger
`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`
axiom-clean iter-198.

### iter-201 recipe (~30-60 LOC HARD BAR + ~30-50 LOC PUSH-BEYOND)

**HARD BAR — Step A: Jacobian-regular-sequence witness** (~30-60 LOC):

Build a project-local lemma of the shape:

```lean
lemma Algebra.SubmersivePresentation.relations_isRegular_in_localization
    {k S : Type*} [CommRing k] [CommRing S] [Algebra k S]
    (P : Algebra.SubmersivePresentation k S)
    (m : Ideal S) [m.IsMaximal] [SomeJacobianHypothesis P m]
    (Sm : Type*) [CommRing Sm] [Algebra S Sm]
    [IsLocalization.AtPrime Sm m] :
    RingTheory.Sequence.IsRegular Sm (P.relations.toList) := …
```

(refine signature per `coe-stacks00sw` analogist verdict.)

Build via Mathlib's existing pieces:
- `Algebra.SubmersivePresentation.jacobian_isUnit` (EXISTS): the Jacobian
  matrix is invertible modulo the maximal ideal.
- `RingTheory.Sequence.isRegular_cons_iff` (EXISTS): inductive construction
  for regularity.
- `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`
  (EXISTS): bridge between global regular-sequence and
  local-weakly-regular-in-maximal-ideal.

**PUSH-BEYOND — Step B: Scheme-to-algebra bridge + L1061 closure**
(~30-50 LOC):

(a) Extract the `SubmersivePresentation` from
`Algebra.IsStandardSmoothOfRelativeDimension Γ(Spec, U) Γ(X.left, V)`
via the iter-198 Stage 6 sub-gap (i) discharger
`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`.

(b) Identify the maximal ideal of `Γ(X.left, V)` corresponding to `z`.

(c) Bridge `Γ(Spec(.of kbar), U) = kbar` (definitional via `U = ⊤`
on the affine `Spec` chart).

(d) Chain through Step A + iter-200 capstone
`ringKrullDim_localization_atMaximal_MvPolynomial` (polynomial-ring side)
+ iter-200 additive form `ringKrullDim_quotient_add_eq_of_regular_sequence`
(quotient-side dimension drop) for
`ringKrullDim Γ(X.left, V)_{m} = n` (where `n = relativeDimension`).

(e) Close `IsRegularLocalRing (X.left.presheaf.stalk z)` via Mathlib's
`IsRegularLocalRing.iff_finrank_cotangentSpace` + the iter-199 Stage 6.B
`finrank_cotangentSpace_of_bijective_algebraMap_residue` substrate.

### Cascade target

If L1061 closes, the Lane T32 binding trigger fires;
`PROGRESS.md` Held lanes Lane T32 commits the iter-202 re-engagement
as Lane COE derivative (~60 LOC stalk-localisation +
`IsRegularLocalRing.isDomain`).

### Why mathlib-build

Stacks 00SW/00OW substrate-build + the L1061 closure is a layered
substrate landing. mathlib-build's no-sorry invariant guides the
substrate landing without re-introducing sorries.

## Subagent dispatches (plan-phase)

All 5 dispatched in parallel before this objectives file was
finalized. Verdicts will land in `.archon/task_results/` during
the iter-201 plan-phase. The prover lane directives above are
self-contained given the iter-200 prover handoffs + iter-201
blueprint expansions; the analogist verdicts (Lane COE Path A
refinement + Lane AB Path A-vs-B choice) feed back via the loop
for iter-202+ refinement.
