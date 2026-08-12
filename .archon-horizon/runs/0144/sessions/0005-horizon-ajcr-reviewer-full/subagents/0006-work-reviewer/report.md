Memory filed as I-1981. No inbox `issue` is warranted — I found no real defect (no weakened statement, no smuggled content, no vacuity, no hidden `sorry`).

---

## Verdict: CONVERGING — honest, incremental, kernel-clean

The session made genuine forward progress and its three headline claims hold up under independent check. It landed the **existence half** of rank-one representability as a real reduction, correctly named the **uniqueness half** as the deferred interface, and its repairs are all statement-preserving. Nothing is faked.

## Findings (by the four questions asked)

**(a) Diff-level honesty of the four repaired files — CLEAN.** All repairs are proof-internal and statement-preserving:
- `Pic0AdmissibleDivisorQuasiProjective.lean`: one extra `unfold` target.
- `Pic0RankOneEvaluationZeroLocus.lean`: simp-set additions, pinned explicit args (`component_sectionsMapTop B' s`), a trailing `rfl`, and one `rw→erw` across a defeq projection gap. Types unchanged.
- `Pic0RankOneFibrePresentedProducer.lean` (`fst_comp_incl`): `change`+`rw` replaced by a `yonedaEquiv_comp/apply` rewrite chain ending in `rfl`. Type unchanged.
- `Pic0RankOneSplitOfPresentation.lean`: `congrArg`/`refine congrArg` bridges and `rwa→exact e ▸`. Types unchanged.

**(b) Stop-rule compliance of the two feats — COMPLIANT, a real reduction (not smuggling).** `existsUnique_abel_divFamZarAff_of_localPresentation` genuinely reduces rank-one `∃!`-representability to injectivity `RankOneDivisorUniqueness`:
- The **existence** conjunct is real work — effective-epi (sheaf) descent `DivFamZarAff.exists_descent_of_tensor_eq` (double-product agreement is exactly the right condition because divisor families are representable by `divRepAffGenusScheme`, so this is sheaf descent, not a stack cocycle) composed with the finite-glue producer, whose `habel` output matches the consumed hypothesis on the nose. The finite-glue theorem is a **first-time genuine consumer**, as claimed.
- The **cocycle** `mapAlgHom φL F' = mapAlgHom φR F'` is manufactured from `hu` at the tensor square (`hu` applied to `lam_sq`, whose rank-one membership is proven via `picRankOneOpen_map_mem`) — not assumed. Honest.
- `hu` is used both for the final uniqueness and to build the cocycle, but it is precisely the sanctioned missing item #1; the theorem does **not** restate the whole desired property as a hypothesis — it discharges existence and names only injectivity. All new lemmas take `PicRankOneOpen` membership as input, so they are **connected** to the public consumer, not disconnected carriers.

**(c) Hypotheses non-vacuously satisfiable — YES.** `PicRankOneLocalPresentation pi lam` is inhabited (`nonempty_localPresentation` from a native presentation), its `cover : Algebra.EtaleCover A` is the geometrically correct carrier, and at field bases the étale-cover carrier is a finite product of finite separable extensions (Artinian ⇒ `IsNoetherianRing`), so the theorem is non-vacuous exactly where rank-one membership is tested. The non-Noetherian general-base case is honestly listed as still open.

**(d) Direction — CORRECT.** This sits at the live frontier: `AJCR.review-plan` p4 (rank-one iso) is the active/blocked node, and existence-descent + the uniqueness interface is the intended p4→p5 bridge. The rank-one restriction in `RankOneDivisorUniqueness` is **load-bearing, not an artificial disjunction**: `Pic0ChartAbelNonInjective` (informal `review-phase0-baseline.md`) proves the widened Abel *chart* map is non-injective when `genus < degree` — off the rank-one locus — so restricting to `PicRankOneOpen` is exactly where injectivity can hold.

**Independent verification performed:**
- `lean_verify` on `existsUnique_abel_divFamZarAff_of_localPresentation` → `[propext, Classical.choice, Quot.sound]`, no warnings. This is the strongest single gate: no hidden `sorry`/axiom anywhere in its dependency cone (descent, finite glue, `effectiveEpi_specMap_of_faithfullyFlat`, PicEtAff separatedness).
- Oleans for all five touched files are newer than source, including `Pic0CriticalPath.olean` (built at HEAD), corroborating the full-build-green claim.

## Lower-severity notes (not defects)
- **Throughput on the split-membership packaging is thin.** `mem_picRankOneOpen_iff_isSplitWitness` merely pairs two already-landed directions, and `isSplitWitness_testPoint_of_mem` is a 2-line corollary. Honestly labeled as "consumer packaging," genuinely usable, but low-value bricks — watch that `IsSplitWitness` does not later become an I-1721 re-spelling of the openness obligation (the shipped `iff` is the thing that would expose it).
- **"Rooted in the critical path" = imported + `#check` + `#print axioms` audit**, not yet consumed by `pic0_representableBy`/`JacobianData`. The docstring says so plainly; just don't over-count these as on-path to the headline.

## What the next session should do first
Discharge `RankOneDivisorUniqueness` — that is now the entire remaining difficulty of rank-one representability. Recorded as durable memory **I-1981** with the two traps to self-check on that commit: (1) I-1664 — the `RelPicBaseLocalTriviality` per-prime localisation lemmas must glue back to global equality over `S` via a real cover of `Spec S`, not the trivial `f=1` converse the outer `∀S` already ranges over; (2) confront `Pic0ChartAbelNonInjective` — show the `PicRankOneOpen` restriction is the genuine reason injectivity is restored, not a datum-section-extraction lemma that renames the goal. Secondary: non-Noetherian-base existence, then the downstream `AbelInverse`/`IsOpen`/representability endpoints.

Relevant files (all absolute):
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorDescent.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/RelPicBaseLocalTriviality.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneSplitMembership.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepAffFaithfullyFlatDescent.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducerFiniteGlue.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/review-phase0-baseline.md` (documents the Abel non-injectivity that motivates the rank-one restriction)
