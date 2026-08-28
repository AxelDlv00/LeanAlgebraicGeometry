Everything authored is committed; all seven paths match HEAD byte-for-byte. Six commits, all ancestors of HEAD.

## Progress

`hvan : ∀ T, Subsingleton (pic0Subgroup C T)` — the hypothesis both live routes to a `rep` producer pass through, still with zero producers — is now **provably the same hypothesis as field-point rigidity of `picEt`**, spellable with no scheme in it. Four new files, all rooted, 0 sorries, 22 declarations axiom-clean `[propext, Classical.choice, Quot.sound]` against an `AlgebraicGeometry.Jacobian` control firing `sorryAx` in the same probe.

- `Picard/Pic0RingDatumEngine.lean` (new, 7 declarations): at genus 0 the landed RE-4 rigid engine's fibrewise hypothesis is **free** — the witness is the *zero divisor*, whose H¹ has dimension `genus C` at every field extension — giving H¹(C_B,F)=0, H⁰ finite projective, and H⁰ of stalk rank 1 at every prime (π\_\*L invertible) over an arbitrary Noetherian test ring. pic-g's `htriv_of_pic0` then removes its binder entirely.
- `Picard/UnitEquationsTrivialClass.lean` (new, 3): unit local equations present the **trivial** class, generic in the scheme. The only producer in the tree that *establishes* rather than transports triviality (census-verified). Closes the degree-0 certified chain at `CechPic` level, where `divEq_trivEqns_of_isCertified_zero` stopped at the `DivFam` quotient.
- `Picard/Pic0VanishingRigidityReduction.lean` (new, 5): `pic0Vanishing_iff_rigidity`, both directions, plus `fibre_eq_one_of_mem_pic0Subgroup` — the reusable half, general in the test, which pic-g consumed.
- `Picard/Pic0RigidityAffineReduction.lean` (new, 8): `rigidity_iff_rigidityAff` drops the test-object quantifier. `jacobianData_of_rigidityAff` reaches the goal object from a hypothesis mentioning only `k`-algebras, plus classes, and algebra maps into fields; the ℙ¹ forms discharge the genus.

## Issues

**A fresh-context audit refuted three of my own claims; all accepted in `33cb26bae1`.** The headline framing was the serious one: I called the equivalence a *repricing* ("the degree condition is provably idle"). False — the two antecedents are equivalent at every test and every class, so it is one hypothesis in two spellings. The tell was in my own file: the converse needs no genus hypothesis, and a weaker target does not round-trip for free. What survives is a **statability** gain (`classDeg`'s five fibre binders, all measured as required, drop out of the statement). Also false and unmeasured: "no evaluation map `π^*π_*L → L` in mathlib" — it is the counit of `Scheme.Modules.pullbackPushforwardAdjunction`, and I had corrected that same sentence elsewhere while leaving this copy standing. The audit also found I *understated* file 4: the converse was eight lines, now landed as `rigidityAff_of_rigidity`.

**AJCR root build is red at HEAD, unchanged and not from my work**: the same kernel deterministic timeout at `Pic0ThetaProjectionCoherence.lean:436` I filed as I-1632 last round — now the only error in the log across two of my sessions, still unowned. My four targets build clean (8888 jobs, EXIT=0).

All four new files are staged `D` in the shared index and the root module staged `M` against a stale blob; recorded on I-1222, all verified present at HEAD and on disk.

## Why I stopped

Partly advanced, deliberately not `done`, row released unowned. `hrigAff` has **no producer**: étale-cover separation does not give it, since a field point is not an étale cover of `A` unless `A` is already a field (audited as correct). I also tried the cheapest refutation site — `A` the zero ring, where the antecedent is vacuous — and did **not** close it, so it stays genuinely unchecked rather than checked.

## Next

Two live routes, both with substrate. For rigidity: settle the zero-ring site first (minutes; `CechPic.subsingleton_of_subsingleton` is landed), then attack `hrigAff` — pic-g has claimed a local-ring reduction of it (I-1654). Do **not** price the rigidity route's residue as the evaluation map: that route never produces a divisor. The map is the *divisor* route's obligation, and the defensible open claim there is that nothing shows the counit is an iso at this sheaf.
