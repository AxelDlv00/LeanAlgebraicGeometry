# Blueprint Reviewer Directive

## Slug
iter111

## Strategy snapshot

The project formalizes the Jacobian of a smooth proper geometrically
irreducible curve over a field, following Christian Merten's challenge
(`references/challenge.lean`). The 9 protected declarations in
`archon-protected.yaml` are the deliverables.

End-state framing (post-iter-110): the project will ship with **7 named
Mathlib-gap sorries + 1 budget-deferred sorry**. The unconditional core
(Rigidity, Genus definition, Čech-cohomology API, FunctorAb additive
wrapping) compiles end-to-end; the framework-conditional layers
(`Pic`, `PicardFunctor`, `Pic.pullback`, the Jacobian arc) carry
transitive dependence on named Mathlib gaps.

The 7 named Mathlib gaps:
1. `instIsMonoidal_W` (`Modules/Monoidal.lean` L173) — varying-ring `stalk_tensorObj`. Load-bearing post-C1.
2. `cotangentExactSeq_structure.h_exact` (`Differentials.lean` L636) — sheaf-of-modules exactness criterion.
3. `nonempty_jacobianWitness` (`Jacobian.lean` L179) — Hilbert/Quot schemes + finite-group quotients.
4. `PicardFunctor.representable` (`Picard/Functor.lean` L181) — gated on (3).
5. `SheafOfModules.pullback_tensorObj` (`Picard/LineBundle.lean` L82) — `μ`-iso of absent `(SheafOfModules.pullback _).Monoidal`.
6. `SheafOfModules.pullback_oneIso` (`Picard/LineBundle.lean` L96) — `ε`-iso of the same absent instance.
7. `serre_duality_genus` (`Differentials.lean` L877) — Serre duality + dualizing sheaf + trace morphism absent.

1 budget-deferral: `BasicOpenCech.lean` L1846 `h_loc_exact` Step 2 transport
(mechanizable from `IsLocalizedModule.{Away,pi,prodMap}` but parked).

**This iter (iter-111) intends to open Phase B with a prover lane on
`AlgebraicJacobian/Differentials.lean` targeting L122
`relativeDifferentialsPresheaf_isSheaf`** (the sheaf-condition theorem
for the relative cotangent presheaf). Blueprint chapter
`Differentials.tex` `\thm:relative_kaehler_isSheaf` was expanded
iter-110 with explicit Mathlib lemma names (`KaehlerDifferential.tensorKaehlerEquiv`,
`Presheaf.isSheaf_iff_isSheaf_comp`, basis-to-opens descent recipe) +
Stacks 01UM/02HQ/02HW + Hartshorne II.8 refs. This iter you must verify
the chapter passes the HARD GATE for iter-111 dispatch.

The other prover-viable Phase B targets (L718, L735) are iter-112+
candidates conditioned on L122 closure.

## Routes

Single route. Phase B opening on L122 is the linear next step; no
alternative routes for this objective.

## References

- `references/challenge.lean`: authoritative formal statement of the
  protected signatures.
- `analogies/serre-duality.md`: iter-110 mathlib-analogist finding on
  L877 (out of scope for iter-111).
- `analogies/c1-route.md`: iter-108/109 mathlib-analogist finding on
  the C1 promotion (background context for Picard/LineBundle).

## Focus areas

- `Differentials.tex` — must pass HARD GATE for iter-111 L122 dispatch.
  Verify `\thm:relative_kaehler_isSheaf` proof block (~L28-47 in current
  state) is detailed enough for a prover to formalize without inventing
  helper lemmas. Specifically: is the basis-to-opens descent step
  pinned to a concrete Mathlib lemma name? Are the localisation
  compatibility steps unambiguous?
- `Picard_Functor.tex` — iter-110 writer flagged 2 stray references at
  L10 NOTE and L88 closing paragraph that were not addressed last iter.
  Confirm whether these are blocking or informational.

## Known issues

- 4 of 5 must-fix chapters from iter-110 have been addressed by
  blueprint-writers (`Picard_Functor.tex`, `Picard_FunctorAb.tex`,
  `Differentials.tex`, `Cohomology_MayerVietoris.tex`); the 5th
  (`Picard_LineBundle.tex`) was addressed by plan-agent direct edits.
  Do NOT re-flag the same items unless they remain genuinely
  unresolved.
- The L877 `serre_duality_genus` block in `Differentials.tex` (L214-224)
  is intentionally short (named Mathlib gap; no proof-sketch expansion
  needed). Do NOT flag this as `complete: partial`.
- The deferred-in-prose lemmas in `Differentials.tex` (L126-129
  `\lem:sheafOfModules_exact_iff_stalkwise` deferred parallel to
  `instIsMonoidal_W`; L131-135 `\lem:sheafOfModules_epi_of_epi_presheaf`
  routine; L137-145 `\lem:derivation_postcomp_comp` Mathlib-shape)
  are intentionally left as prose-only because the active prover
  surface does not consume them this iter. Do NOT flag as missing.
