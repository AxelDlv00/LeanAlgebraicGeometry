# iter-077 → next-plan recommendations

## CRITICAL (must-fix this iter — block prover re-dispatch until done)

1. **Amend the capstone signature + its line-207 call (`CechToHigherDirectImage.lean`).**
   `cech_computes_higherDirectImage_of_affineCover` (`:197`) must add `[S.IsSeparated]` and
   `(hres : ∀ p σ, HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules)` (or per-`p` as the
   call needs), and pass `hres` at `:207`. Until then the file is **ill-typed and does not compile**
   (confirmed: `lean-vs-blueprint-checker-cechtohdi`, `lean-auditor-iter077`). This is the actual reason
   "no sorry remains" is misleading — the file has compile *errors*, not sorries.
   - Refactor is structural (signature change on a non-protected decl) → dispatch the **refactor** subagent
     (or planner edits the `.lean` is NOT allowed; planner writes prose only) — practically: the planner
     must re-scope the prover lane with the corrected signature in PROGRESS, since provers own the `.lean`.

2. **Settle the two contested type-direction bugs in `CechTermAcyclic.lean` with a REAL build.**
   `lean-auditor-iter077` flags `:99` `isRightAcyclic_of_iso` (extraneous `.symm`) and `:668`
   `pushPullObj_opens_pushforward_acyclic` (missing `.symm`). The prover's "green" claim rode on **stale
   oleans**; the 2 GB review sandbox could not build. **Get an independent full `lake build` of
   `CechTermAcyclic.lean` from source** (env with adequate RAM) before trusting it or marking `\leanok`.
   If the auditor is right, both are one-character fixes — assign a prover lane.

3. **Blueprint statements are FALSE/incomplete** (planner owns prose; I added `% NOTE:` markers):
   - `lem:cech_term_pushforward_acyclic`: add `[X.IsSeparated]` + `[S.IsSeparated]` (affine diagonal of S)
     + the `hres` hypothesis; fix the proof sketch at L11685-11688 (silently assumes `U_σ ∩ f⁻¹V` affine).
     Counterexample: `CechTermAcyclic.lean:16-31`.
   - `lem:cech_computes_cohomology_affineCover`: add the same `[S.IsSeparated]` + `hres`.
   - `lem:cechAugmented_to_acyclicResolutionInput`: note outputs are `PProd` (`×'`), not `Prod`.
   - `\uses` of `lem:cech_term_pushforward_acyclic` → `open_immersion_pushforward_acyclic` is misleading;
     the Lean routes through new `higherDirectImage_affineHom_acyclic` (needs its own blueprint block).

## STRATEGY note — the parallel split mis-converged
The 2-lane split (DEEP + assembly) ran concurrently while the DEEP lane was simultaneously *changing a
shared signature*. The assembly lane was written against the stale signature ⇒ guaranteed seam break.
**Do not parallelise a producer lane that is still changing its public signature with a consumer lane.**
Sequence them: land + build-verify `cechTerm_pushforward_acyclic`'s final signature FIRST, then write the
assembly against it. (progress-critic should weigh in: this is the second "stale-olean / unverified-green"
iter in a row — iter-076 also landed unverified.)

## Coverage debt — 29 unmatched `lean_aux` decls (blueprint each; planner authors prose)
`CechTermAcyclic.lean`: `higherDirectImage_affineHom_acyclic`, `injectiveResolutions_additive`,
`isAffineHom_of_isAffine_of_isSeparated`, `isAffineOpen_coverInterOpen`, `isAffineOpen_iInf_fin`,
`isQuasicoherent_pullback_opens`, `isRightAcyclic_of_iso`, `isZero_biproduct`,
`modulesOverOpensEquivalence`, `opens_ι_image_overEquivalence_functor`,
`overEquivalence_functor_isContinuous_opens`, `overEquivalence_inverse_isContinuous_opens`,
`overOpensForgetInvIso`, `overOpensForgetIso`, `overOpensFunctorUnitIso`, `overOpensInverseUnitIso`,
`overOpensIsoRestrict`, `overOpensRingHom`, `overOpensRingInvHom`, `presentationOverOpens`,
`presentationRestrictOfOver`, `presentationRestrictSliceOfOver`, `pullbackObjUnitToUnit_isIso_of_isIso`,
`pushPullObj_opens_pushforward_acyclic`, `pushforward_overOpensRingHom_isRightAdjoint`,
`pushforward_overOpensRingInvHom_isRightAdjoint`, `restrictIsoUnitIso`, `rightDerived_additive`.
`CechToHigherDirectImage.lean`: `mapAlternatingCofaceMapComplexIso`.
(Bundle the small ones into a few parent `\lean{...}` lists — same pattern as covdebt076.)

## Blocked / do-NOT-retry
- `cech_computes_higherDirectImage` (CHDI:780, frozen): unprovable as signed. **Do NOT dispatch a prover.**
  User-owned signature relaxation required; body then = one-line `exact` of the corrected sibling.
- `cech_computes_higherDirectImage_of_affineCover`: do NOT re-dispatch until item 1 (signature amendment)
  is done — a prover at the current signature will re-hit the same ill-typed line-207 wall.

## Reusable patterns discovered (from this iter, pending build confirmation)
- General-opens restrict–over bridge (port of `QcohRestrictBasicOpen` B2–B4): honest unit isos via
  `Adjunction.leftAdjointUniq` + `asIso (pullbackObjUnitToUnit φ)` — the `P.map e.inverse (.refl _)`
  shortcut no longer elaborates on the current Mathlib pin.
- HasExt synthesis timeout at `rightDerived`/Ext steps → `attribute [local instance] hasExtModules`
  (pattern from `OpenImmersionPushforward.lean:111`).
- Instance synthesis for `IsIso (pullbackObjUnitToUnit φ)` fails when the goal category prints as
  `(↑W).Modules`; establish it in a `haveI` whose statement never names `Scheme.Modules`, pass via `@asIso`.
