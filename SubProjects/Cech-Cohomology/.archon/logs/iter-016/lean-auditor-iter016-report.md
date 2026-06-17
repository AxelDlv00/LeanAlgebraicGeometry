# Lean Audit Report

## Slug
iter016

## Iteration
016

## Scope
- files audited: 7
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 6-line import barrel. Clean.

---

### AlgebraicJacobian/Cohomology/HigherDirectImage.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Single declaration `higherDirectImage := ((pushforward f).rightDerived i).obj F`. Signature, body, and docstring are all consistent and correct.

---

### AlgebraicJacobian/Cohomology/AcyclicResolution.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 26–31 (module docstring)**: "The following declarations … will be constructed by the prover in `mathlib-build` mode: `InjectiveResolution.ofShortExact`, `rightDerivedShiftIsoOfAcyclic`, `rightDerivedIsoOfAcyclicResolution`." All three ARE constructed and proved in this file. The "will be constructed" framing is from the file's original draft and has not been updated.
  - **Lines 924–963 (status block "iter-006")**: The block says "TARGET 3 (the acyclic-resolution staircase) remains" and lists `rightDerivedIsoOfAcyclicResolution` under "REMAINING". That declaration is fully proved at lines 893–922 with no `sorry`. Every ingredient called out as "NOT yet built" — `rightDerivedOneIsoCokerOfAcyclic` (lines 689–725), the cosyzygy infrastructure (`cosyzygyShortComplex`, `cosyzygyShortExact`, `gCosyzygyIsoCocycles`, `cohomologyAppliedResolutionIso`) at lines 781–858 — is also present and proved. The status block is thoroughly stale and actively misleads a reader into thinking the main theorem of this file is still missing.
  - All proof bodies inspected: no `sorry`, no suspicious tactic chains (e.g. `combSign_flip`-style involution is used correctly in the horseshoe, `exact isIso_of_mono_of_epi` is appropriate for the quasiIso step, staircase induction is cleanly structured).

---

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- **outdated comments**: 5 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 elevated `maxHeartbeats` settings
- **excuse-comments**: none
- **notes**:
  - **Line 85–86** (inside `/-! ## Project-local Mathlib supplement — scheme-level Čech nerve backbone -/`): "The push–pull functor is the remaining gap: its `map_comp` requires the `pushforwardComp` / `pullbackComp` coherence isomorphisms… so `CechNerve` itself is left as the single genuine hole." But `pushPullMap_comp` is proved at line 627 (using `rawPushPullMap_comp` at lines 533–619), `pushPullFunctor` is assembled at lines 640–644, and `CechNerve` is defined at lines 698–701. The "remaining gap" framing is stale.
  - **Line 166** (inside the push-pull comment block): `pushPullMap_comp : pushPullMap F (h ≫ g) = pushPullMap F g ≫ pushPullMap F h  -- remaining`. Tagged as `-- remaining` but the lemma is proved.
  - **Lines 245–293** (`/- **Composition law of the push–pull functor `G` (contravariant) — remaining.**`): Long comment narrating why `pushPullMap_comp` is unproved. It is proved. The whole narrative ("left for a focused follow-up pass", "a ~150-LOC pentagon calculation") is stale.
  - **Lines 410–449** (`/- **Composition law `pushPullMap_comp` — reduced to an explicit clean pentagon, not yet closed.** … **Why it is not yet closed (next-prover dead-ends, all hit this iter):**`): The pentagon IS closed by `rawPushPullMap_comp` (lines 533–619). The "not yet closed" assertion and the dead-end narrative are stale.
  - **Line 744** (comment inside `CechComplex` definition): "The only remaining hole is `CechNerve` itself." `CechNerve` is defined at lines 698–701.
  - **Known sorry — line 778**: `cech_computes_higherDirectImage` is `sorry`. Per directive this is the frozen protected sorry; reported as known, not flagged as a surprise.
  - **Line 266**: "iter-271 breakthrough" — references the iter numbering of the original Algebraic-Jacobian-Challenge project; stale relative to this project's iter numbering. Minor historical artifact.
  - **Lines 404, 467, 533**: `set_option maxHeartbeats 1000000/4000000/1600000`. Very elevated heartbeat budgets on `pushPullMap_eq_raw`, `rawPushPullMap_self_gen`, `rawPushPullMap_comp`. Not wrong, but signals slow proofs that may become fragile against Lean/Mathlib version bumps.

---

### AlgebraicJacobian/Cohomology/CechAcyclic.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 109**: `sorry` in `CechAcyclic.affine`. Per directive this is the intentional, disclosed L1 blocker (categorical-to-module bridge). The scope comment at lines 79–108 is an honest description of the gap and does not attempt to disguise it as a temporary fix. Reported as known; not a surprise.
  - `CombinatorialCech` (constant-coefficient section, lines 135–255): all definitions and proofs are `private`, well-named, and correct. `combDifferential_comp` uses the standard sign-reversing involution on pairs `(j,i)` with the correct Fin combinatorics (`Fin.succAbove_succAbove_succAbove_predAbove`, etc.).
  - `CombinatorialCech.Dependent` section (lines 257–458): `depDiff`, `depHomotopy`, `depHomotopy_spec`, `depDiff_comp`, `depDiff_exact` all look structurally sound. The `depTransport` helper correctly isolates the only coefficient-transport friction. The `hcomm` hypothesis in `depDiff_comp` is the right abstraction of the coface-commutation property needed from localisations.
  - No `sorry` anywhere in the `CombinatorialCech` or `Dependent` namespaces.

---

### AlgebraicJacobian/Cohomology/PresheafCech.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lines 19–24 (module docstring)**: Lists 5 declarations "to be built (in order)": `sectionCechComplex`, `cechFreePresheafComplex`, `cechComplex_hom_identification`, `cechFreeComplex_quasiIso`, `injective_cech_acyclic`. Of these, `sectionCechComplex` is built here (line 333), `cechFreePresheafComplex` is built in `FreePresheafComplex.lean`, and the remaining three (`cechComplex_hom_identification`, `cechFreeComplex_quasiIso`, `injective_cech_acyclic`) are absent from the codebase. The docstring presents this as a sequential build plan — accurate as a roadmap — but a reader scanning declarations will find three named in the docstring that do not exist. Minor misleading potential.
  - `injective_toPresheafOfModules` (lines 215–224): proof is correct — uses `sheafificationAdjunction` as left-adjoint to `toPresheafOfModules`, infers `PreservesMonomorphisms` by `inferInstance`, then applies `Injective.injective_of_adjoint`.
  - `freeYonedaHomEquiv` (lines 244–248): `freeHomEquiv.trans yonedaEquiv` — correct composition of the two standard bijections.
  - `freeYonedaHomEquiv_apply` (lines 255–259): generator formula recorded correctly.
  - `freeYonedaHomAddEquiv` (lines 273–285): additive upgrade. The `map_add'` proof correctly decomposes `PresheafOfModules.add_app` then `ModuleCat.hom_add`. Looks sound.
  - `sectionCechCosimplicial` (lines 302–320): `map_id` uses `Subsingleton.elim (homOfLE _).op (𝟙 _)` to discharge the singleton-hom in `Opens`, then `simp`. `map_comp` assembles via `Pi.lift_π` and `← Functor.map_comp`. Both look correct.
  - `sectionCechComplex` (line 333–335): clean one-liner calling `alternatingCofaceMapComplex` on the cosimplicial object; `d² = 0` is inherited for free.
  - The planner strategy comment (lines 34–195) is long but serves as inline documentation for upcoming prover work; not an excuse-comment.

---

### AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lines 19–22 (module docstring)**: "this file owns the two free-complex declarations: `cechFreePresheafComplex` and `cechFreeComplex_quasiIso`." Only `cechFreePresheafComplex` is present; `cechFreeComplex_quasiIso` does not appear anywhere in the file or elsewhere in the project. The docstring overstates what the file delivers.
  - `freeYoneda` (line 111–112): `yoneda ⋙ PresheafOfModules.free X.ringCatSheaf.obj`. Correct composite.
  - `coverOpen`, `coverInterOpen` (lines 115–122): reasonable helper definitions.
  - `coverInterOpen_comp_le` (lines 127–129): `le_iInf fun k => iInf_le _ (α k)` — correct (reindexing a tuple shrinks the intersection).
  - `sigma_ι_eqToHom_transport` (lines 133–137): `subst e; simp` — correct dependent-index helper.
  - `cechFreeSimplicial` (lines 151–183): the simplicial object. `map_id` correctly uses `Subsingleton.elim` of the `homOfLE` to `eqToHom eo.symm`, then `eqToHom_map` and `sigma_ι_eqToHom_transport`. `map_comp` correctly chains `sigma_ι_eqToHom_transport` and `eqToHom_map`. Both simplicial identities look sound.
  - `cechFreePresheafComplex` (lines 193–195): definition via `alternatingFaceMapComplex` of `cechFreeSimplicial`. `d² = 0` comes from simplicial identities, no hand-rolling. Correct strategy.
  - `cechFreePresheafComplex_X` (lines 201–204): holds by `rfl`. Clean unfolding lemma.

---

## Must-fix-this-iter

None.

The sorry items are both disclosed in the directive:
- `CechAcyclic.lean:109` — intentional pin for the L1 categorical bridge; honest scope comment.
- `CechHigherDirectImage.lean:778` — frozen protected sorry on the signature-frozen `cech_computes_higherDirectImage`.

No excuse-comments, no weakened-wrong definitions, no parallel Mathlib APIs, no unauthorized axioms, no suspect proof bodies were found.

---

## Major

- `AcyclicResolution.lean:26–31` — Module docstring says three declarations "will be constructed by the prover" but all three are already fully proved in the file. Reader is led to think the file is skeletal when it is complete.
- `AcyclicResolution.lean:924–963` — Status block titled "iter-006" says "REMAINING (TARGET 3): `Functor.rightDerivedIsoOfAcyclicResolution`" and itemises its missing ingredients. The declaration is proved at lines 893–922; every ingredient called out as absent is present and proved. This is an actively misleading factual error in a high-visibility block.
- `CechHigherDirectImage.lean:85–86` — "The push–pull functor is the remaining gap … `CechNerve` itself is left as the single genuine hole." Both `pushPullFunctor` and `CechNerve` are now defined (lines 640–644 and 698–701). Stale factual error in the section intro.
- `CechHigherDirectImage.lean:166` — `-- remaining` tag on `pushPullMap_comp` in the comment block. Proved at line 627.
- `CechHigherDirectImage.lean:245–293` — Large block claiming `pushPullMap_comp` is "remaining" and a "~150-LOC pentagon calculation … left for a focused follow-up pass." The law is proved; the block is misleading.
- `CechHigherDirectImage.lean:410–449` — Block saying the pentagon is "not yet closed" with dead-end analysis. Closed by `rawPushPullMap_comp` at lines 533–619.
- `CechHigherDirectImage.lean:744` — "The only remaining hole is `CechNerve` itself." Stale; `CechNerve` is defined at lines 698–701.
- `PresheafCech.lean:19–24` — Module docstring lists `cechComplex_hom_identification`, `cechFreeComplex_quasiIso`, and `injective_cech_acyclic` as declarations to be built but none exists anywhere in the codebase. A reader expecting to find or navigate to these names will be confused.
- `FreePresheafComplex.lean:19–22` — Module docstring says this file "owns the two free-complex declarations" including `cechFreeComplex_quasiIso`, which is absent.

---

## Minor

- `CechHigherDirectImage.lean:404` — `set_option maxHeartbeats 1000000` on `pushPullMap_eq_raw` (which holds by `rfl`). A 1M heartbeat budget on a `rfl` proof is a smell; this may trigger on elaboration overhead rather than a hard kernel reduction but is worth investigating.
- `CechHigherDirectImage.lean:467` — `set_option maxHeartbeats 4000000` on `rawPushPullMap_self_gen`. Very high; signals potential elaboration fragility.
- `CechHigherDirectImage.lean:533` — `set_option maxHeartbeats 1600000` on `rawPushPullMap_comp`. Elevated; indicates the proof is near the default limit.
- `CechHigherDirectImage.lean:266` — "iter-271 breakthrough" references iteration numbering from the parent Algebraic-Jacobian-Challenge project; this project is at iter-016. Minor historical artifact, not incorrect on its own merits.

---

## Excuse-comments (always called out separately)

None found. No declaration carries a comment admitting it is wrong, temporary, or a placeholder.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 9 (all stale comments; no wrong definitions or suspect bodies)
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The proof code is sound — sorry count matches the directive's two known intentional pins, no suspect bodies, no axioms, no parallel API misuse — but seven major stale comments in `AcyclicResolution.lean` and `CechHigherDirectImage.lean` create a false picture of what work remains: they describe `pushPullMap_comp`, `CechNerve`, and `rightDerivedIsoOfAcyclicResolution` as open when all are now proved.
