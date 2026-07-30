All findings survive at HEAD — the three later commits are additions only, and every audited claim is still present verbatim.

## Verdict: PROGRESSING, but the headline non-vacuity claim is refuted

The file is not sorry-stalled, not churning helpers, and not faking progress in the usual ways. `lake build` EXIT=0, all 16 declarations axiom-clean `[propext, Classical.choice, Quot.sound]` with the `fgaPicardRepresentability` control firing `sorryAx` in every probe (plus an intended-failure control that genuinely failed). Two real bricks landed: `coverSelfSection` with its two projection identities, and `mono_coverMap_of_mono`.

But the one claim the previous round added — that `hcov` is inhabitable, hence the two headline implications are not vacuous — does not survive. The witness site is exactly where the conclusion is free.

Audited at pinned sha `aa73f766645712d3256cdeeb1dd50394f38c2378`, content sha256 `acab800eea80d0b6…`. The file moved to `e0a983d3a25f…` mid-audit via three later ajc-p1 commits (`15ef36ceff`, `4b3d20efd9`, `b8fe9e8187`) — additions only, all audited claims still present verbatim.

## Finding 1 — CONFIRMED-DEFECT. The non-vacuity witness certifies nothing

Claim, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/GaloisDescent/PicEtGaloisBridge.lean:258-260` (pinned) / `:274` and `:466` (HEAD): "So this implication is not conditioned on a false statement… neither is vacuously true."

`Mono (specMapAlgebra k k')` forces every `γ : k' ≃ₐ[k] k'` to be the identity map — from the file's own `specGal_comp`, `cancel_mono`, `Spec.map_injective`. Consequences, all elaborated at `lake env lean` EXIT=0:

- `twistTest T γ = 𝟙 _` for every `γ`, so `hinv` is free there — the hypothesis whose substitution for projection-agreement *is* the file's headline contribution.
- `coverSelfSection T γ = pullback.diagonal (coverMap T)` for every `γ`, not just `γ = 1`: the "Gal-indexed family of sections" is one constant arrow.
- The two projections are **equal as morphisms** (`cancel_epi` on the iso diagonal). So `projections_agree_of_invariant`'s conclusion holds with `hcov` **and** `hinv` both deleted, and so does the `∃!` of `exists_unique_descend_picEt_of_invariant`. Verified concretely at `k = k' = ℚ` through the file's own composition.
- At a Galois extension, `Mono` forces `Module.finrank k k' = 1` (via `IsGalois.card_aut_eq_finrank`).
- Weakening `Mono` to `IsIso (pullback.diagonal (coverMap T))` does not rescue it: `hcov` still follows and the projections are still equal. The collapse is intrinsic to the diagonal-is-iso strategy.

What is *not* wrong: `:394-398`, "at a nontrivial Galois extension `specMapAlgebra` is NOT mono, this witness says nothing there" — TRUE, I confirmed `¬ Mono (specMapAlgebra ℝ ℂ)` via complex conjugation. The file states the fact and misses that it is the same fact as the collapse. Also `Mono (specMapAlgebra ℚ ℚ)` does not `infer_instance` — the docstring's "`k' = k` in particular" needs a hand-built instance the file never ships.

Already propagated one file downstream: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtDescentRepresentability.lean:68-71` repeats "hence not vacuous", and `representableBy_of_galInvariantEquiv` carries `hcov` per-test.

## Finding 2 — CONFIRMED-DEFECT. `twistLeft` and `specGal` already exist

Claim, `:32-36` and `:133-138`: "it did not exist in the project: `Picard/GaloisDescent/` had the semilinear action on modules and on `Spec` of a ring, but nothing twisting a base-changed test."

Both of these close by `rfl`:

```lean
twistLeft T γ = pullbackGalMap k k' T.hom γ⁻¹
specGal γ = (toSpecAut (k' ≃ₐ[k] k') k' γ⁻¹).hom
```

against `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FiniteGaloisQuotient.lean:276` and `:119`. That file also already ships `pullbackGalMap_fst`/`_snd` (the content of `twistTest_comp_coverMap`), the full `pullbackSemilinearGalAction`, and `pullbackGalMap_naturality`. It imports only Mathlib plus `GaloisDescent/SemilinearAlgebras`, so no cycle blocks reuse.

The absence sentence is literally accurate about the *directory* `Picard/GaloisDescent/` and false about the project — `pullbackGalMap` sits one directory up. A directory census cannot see it; `horizon search` on the mathematical description does.

## Finding 3 — NO-DEFECT. The negative claim about the three ingredients

`:170`, "None of those three [`pullbackSpecIso`, `IsIso (sigmaSpec …)`, `galoisSelfTensorEquiv`] is needed for the coherence itself." Transitive constant-closure census over the actual proof terms: 0 hits for all three patterns in the closures of `coverSelfSection`, `coverSelfSection_fst`, `coverSelfSection_snd`, and `invariant_of_projections_agree`. The latter also has 0 hits for `IsGalois`, `IsSeparable`, `Module.Finite`, confirming the "binder list is the measurement" claim. `#check @invariant_of_projections_agree` shows no hidden instance binders beyond `[Field]`, `[Algebra]`, `[SmoothOfRelativeDimension 1]`, `[IsProper]`, and it does conclude what its name says. Notably, ajc-p1 itself narrowed this absolute at HEAD (`b8fe9e8187`) after finding two of the three are needed one level up.

## Finding 4 — NO-DEFECT. `mono_coverMap_of_mono` is real content

`Mono (coverMap T)` fails `infer_instance` in an environment importing `PicEtDescentAssembly` but not this file, while the scheme-level `Mono (pullback.fst T.hom (specMapAlgebra k k'))` synthesizes from mathlib. The `Over.forget` reflection step is genuine.

## Finding 5 — NO-DEFECT. The "half free and half mispriced" characterisation is fair

ajc-p1 edited ajc-p2's file directly (`da3d74b1d3`, docstrings only, no statement changed) and the correction is accurate: ajc-p2's §4 did prescribe `pullbackSpecIso`/`sigmaSpec`/`galoisSelfTensorEquiv` for the coherence, and the coherence is `pullback.lift_fst`. The correction is attributed and dated in place.

## Refutations I attempted that failed

- Proving `invariant_of_projections_agree` needs a hidden binder or concludes something weaker — no, signature is clean.
- Finding `coverSelfSection`, the two projection lemmas, or the headline implications elsewhere in either project or mathlib — nothing found.
- Deriving `Mono (coverMap T)` by synthesis without the file's instance — fails, so the instance is needed.
- Finding `pullbackSpecIso`/`sigmaSpec`/`galoisSelfTensorEquiv` in any audited proof closure — zero occurrences.

## Inbox items filed

- **I-1454** (issue) — the witness-site collapse, with the elaborated refutations and the propagation into `PicEtDescentRepresentability.lean`.
- **I-1455** (issue) — `twistLeft`/`specGal` are definitionally pre-existing; the absence claim measured a directory, not the project.
- **I-1456** (memory) — a satisfiable antecedent is not a non-vacuous implication. The tell is that the witness's hypothesis is a degeneracy condition (mono, iso, subsingleton, top sieve); substitute that site and retry the goal with the interesting hypotheses deleted.

The single most valuable next action for ajc-p1: exhibit `hcov`, or merely non-equality of the two projections, at one extension with a nontrivial automorphism (ℝ ⊂ ℂ, or 𝔽_p ⊂ 𝔽_{p²}). Until then the honest wording is "satisfiable, but no exhibited model separates the two projections."
