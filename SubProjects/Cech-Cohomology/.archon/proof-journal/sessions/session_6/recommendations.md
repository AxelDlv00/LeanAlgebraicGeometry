# Recommendations for the next plan iter (post iter-006)

## 1. TARGET 3 is the sole remaining P4 work — effort-break it, do NOT re-dispatch the monolith
`CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`
(`lem:acyclic_resolution_computes_derived`): `(Rⁿ G)(A) ≅ Hⁿ(G(J•))` for an acyclic resolution
`J•` of `A`. This is a **separate multi-lemma construction**, not one step. The prover correctly
declined to leave a sorry-bearing partial def. Effort-break into TWO leaves, mirroring how the
horseshoe was decomposed:

- **(a) Part-2 base case of the dimension shift**: `(R¹ G)(A) ≅ coker(G(J) → G(Z))` for a SES
  `0 → A → J → Z → 0` with `J` acyclic. The current `rightDerivedShiftIsoOfAcyclic` /
  `rightDerivedShiftIsoOfSplitResolutionSES` deliver only the `δIso` for `k ≥ 1`. Build (a) as a
  sibling using `hSG.homology_exact₂/₃` at degrees 0,1 and `Functor.rightDerivedZeroIsoSelf`.
  **This is also the missing part (2) of `lem:acyclic_dimension_shift`** (see §3 — the blueprint
  lemma already states it; the Lean does not yet cover it).
- **(b) Cosyzygy SES infrastructure**: `Zᵐ := ker(Jᵐ → Jᵐ⁺¹)`, the SES `0 → Zᵐ → Jᵐ → Zᵐ⁺¹ → 0`
  (short exact because `J•` resolves `A`), plus `H⁰(G(J•)) ≅ G(A)` and `Hⁿ(G(J•)) ≅ (R¹ G)(Zⁿ⁻¹)`.

Then compose `rightDerivedShiftIsoOfAcyclic` down the staircase `(Rⁿ G)(A) ≅ (R¹ G)(Zⁿ⁻¹)` and
close with (a). **Suggested input signature** (from the prover): `J : CochainComplex 𝒜 ℕ`,
`[∀ n, G.IsRightAcyclic (J.X n)]`, `A : 𝒜`, `π : (single₀).obj A ⟶ J` with `[QuasiIso π]`,
`G` additive + left-exact. The blueprint chapter `Cohomology_AcyclicResolution.tex` has the
theorem block (`lem:acyclic_resolution_computes_derived`) but it needs the (a)/(b) sub-lemma
chain blueprinted before a prover can be sent — dispatch an **effort-breaker** on this target,
granularity "one level", cutting along the (a) base-case / (b) cosyzygy seam above.

## 2. Closest-to-completion / reusable patterns
- The P4 lane is now ~one decomposition away from done: ingredients (a) and (b) are both standard
  homological algebra with verified Mathlib inputs (`homology_exact₂/₃`, `rightDerivedZeroIsoSelf`,
  `HomologicalComplex.cyclesMk`/kernel forks). No new missing-from-Mathlib lemma is anticipated
  (unlike `quasiIso_τ₂`, which this iter resolved).
- **Reusable proof patterns discovered** (also in PROJECT_STATUS Knowledge Base): the homology
  four-lemma `isIso_of_mono_of_epi` over `mapComposableArrows₅` windows; the clean-domain
  ascription fix for `Mono (I.ι.f 0)`; the `change`-to-clean-biproduct fix for `twistedBiprod`
  projections.

## 3. Blueprint↔Lean faithfulness: split part (2) of `lem:acyclic_dimension_shift` (MAJOR)
`rightDerivedShiftIsoOfAcyclic` is axiom-clean and `\leanok`, but the blueprint lemma
`lem:acyclic_dimension_shift` states **two** parts and the Lean delivers only **part (1)** (the
k≥1 shift isos). Part (2) — `(R¹G)(A) ≅ coker(G(J)→G(Z))` — is not in the Lean signature. A
`% NOTE (iter-006 review): PARTIAL COVERAGE` has been added to the block. **Planner action**:
either split part (2) into its own `\lean{}`-tagged block (it equals TARGET 3 ingredient (a), so
this is natural), or narrow the lemma statement to part (1). Leaving it as-is risks the `\leanok`
reading as "the cokernel base case is done" when it is not.

## 4. Coverage debt — blueprint blocks for prover-created helpers (lean_aux, 1-to-1 doctrine)
`archon dag-query unmatched` reports 50 uncovered Lean decls (of 53). The **new this-iter**
helpers in `AcyclicResolution.lean` needing blueprint entries:

| Lean name | Relies on |
|---|---|
| `HomologicalComplex.HomologySequence.quasiIso_τ₂` | Mathlib four-lemma `mono_of_epi_of_mono_of_mono`, `epi_of_epi_of_epi_of_mono`, `mapComposableArrows₅`, `mono/epi_homologyMap_of_…_not_rel` |
| `CategoryTheory.InjectiveResolution.horseshoeι` (+ `_f_zero`) | `CochainComplex.fromSingle₀Equiv`, `horseshoeβ_comp_d` |
| `CategoryTheory.InjectiveResolution.mono_horseshoeβ` | `mono_biprod_lift_factorThru_of_exact`, `mono_of_isLimit_fork I.isLimitKernelFork` |
| `CategoryTheory.InjectiveResolution.horseshoeφ` (+ `_comm₁₂`, `_comm₂₃`, `_τ₁/₂/₃`) | `ShortComplex.homMk`, `single₀_hom_ext`, biproduct calc |
| `CategoryTheory.InjectiveResolution.quasiIso_horseshoeι` | `quasiIso_τ₂`, `hses.map_of_exact (single₀ 𝒜)`, `mono_horseshoeβ` |
| `CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES` (iter-004, still uncovered) | resolution-level engine reused by `rightDerivedShiftIsoOfAcyclic` |

Plus the iter-005 twisted-biproduct cluster (`twistedBiprod`, `twistedBiprodD`, `horseshoeτZero`,
`horseshoeH`, `horseshoeMid`, `horseshoeSES`, `shortExact_of_degreewise_splitting`, …) and the
pre-existing `AlgebraicGeometry.*` helpers (`pushPull*`, `rawPushPullMap*`, `coverCechNerve*`).
The planner writes the informal prose; the review agent does not author these blocks. Priority:
`quasiIso_τ₂` and `rightDerivedShiftIsoOfSplitResolutionSES` first (they are load-bearing for the
P4 chain and TARGET 3).

## 5. Stale comment cleanup in `CechHigherDirectImage.lean` (lean-auditor MAJOR, not P4)
Two comment blocks (L184 and L246–449) claim `pushPullMap_comp` is unimplemented; it is fully
proved in the same file at **L627**. These mislead future provers about P1's status. Have a
prover/refactor strip or correct them when that file is next touched. Not on the P4 critical path.

## 6. Do NOT re-assign (blocked / done)
- `cech_computes_higherDirectImage` (L811) and `CechAcyclic.affine` (L774) — the two remaining
  global sorries (P5/P3). P5 needs P3 + the completed P4; P3 is blocked by the standard-cover vs
  general-cover statement gap recorded in prior iters. Do not dispatch P5 until P4 (TARGET 3) lands.
- `ofShortExact`, `ofShortExact_resolvesMiddle`, `rightDerivedShiftIsoOfAcyclic`, `quasiIso_τ₂` —
  **done, axiom-clean**. Do not re-dispatch.
