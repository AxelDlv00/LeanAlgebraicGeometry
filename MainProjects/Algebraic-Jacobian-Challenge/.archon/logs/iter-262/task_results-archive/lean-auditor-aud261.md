# Lean Audit Report

## Slug
aud261

## Iteration
261

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **[L43–44] Status header claims "ONE tracked typed-sorry residual"** but the file now has THREE sorries (L715 `exists_tensorObj_inverse`, L2480 `sheafificationCompPullback_comp`, L2598 `pullbackTensorMap_restrict`). The two new iter-261 sorries (`sheafificationCompPullback_comp`, `pullbackTensorMap_restrict`) were added without updating the "ONE" count. This actively misleads any reader auditing the file's sorry state.
  - **[L132] Module layout note** also only lists `exists_tensorObj_inverse (sorry)` for this file, missing the two D3′ sorries. Consistent stale omission.
  - **New decl `sheafificationCompPullback_comp` (~L2439)**: comment block is accurate. Proof opens `apply (…).homEquiv.injective`, `erw [Adjunction.homEquiv_leftAdjointUniq_hom_app]`, then `rw [homEquiv_unit, comp_unit_app, comp_unit_app]` before `sorry`. The stated goal ("REMAINING: transport the two `pullbackComp` factors across the adjunctions") matches the actual reduced goal state. Sorry is honestly labeled.
  - **New decl `pullbackTensorMap_restrict` (~L2503)**: very long comment block (iter-256 handoff + iter-257 findings + iter-261 opening). Comment claims the proof is "now OPENED to the paste-ready form" and that `simp only [pullbackTensorMap, tensorObjIsoOfIso]` + `Functor.map_comp` unfolding runs before `sorry` — consistent with the actual code at L2595–2598. The iter-257 analysis of why the unit-analog mirror doesn't transfer is plausible and relevant. Sorry is honestly labeled.
  - All three sorry declarations have explicit typed `sorry` (not bare `sorry` hiding an omitted body); comment coverage is thorough.
  - Long multi-paragraph block-comments in proof bodies are project style (not an antipattern here per project conventions).

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **[L24–35] File-module header: `sliceDualTransport` labeled "HELD (iter-258)"** — stale by 3 iterations. The in-body code at L247–317 shows iter-261 work: route-2 was sanctioned and partially executed. Leg-A (`toFun`'s categorical `.map` reindex) is built and typechecks; the body has been restructured to a `LinearEquiv.toModuleIso` with 7 typed sorry bullets. The header should read "PARTIAL (iter-261, route-2 leg-A built, 7 typed sorries)".
  - **[L444] In-body comment in `dual_restrict_iso`**: says "its `.hom` is currently a `sorry`" — now inaccurate. The body of `sliceDualTransport` is no longer a single `sorry`; it is a partially-built `LinearEquiv` (leg-A done, 7 typed sorries for the remaining fields). The spirit is correct (the isoMk naturality square can't yet be discharged), but the literal description is wrong.
  - **Sorry count**: 8 sorries total — 7 in `sliceDualTransport` (L305, 307, 309, 311, 313, 315, 317) and 1 naturality-square sorry in `dual_restrict_iso` (L448). Each sorry is preceded by a comment identifying the specific obstacle. The count is consistent with the stated route-2 partial build.
  - **`dual_restrict_iso` header (L15–22)**: says "one sorry remains at the identified Step-4 presheaf residual" — partially accurate (L448 is the assembly naturality sorry), but the 7 sorries in `sliceDualTransport` (the component that feeds Step-4) are not accounted for here. Not a contradiction, but the count of "one" is an undercount of the total sorries in the file.
  - **`dual_isLocallyTrivial` (L524–533)**: "TRANSITIVELY PARTIAL (depends on `dual_restrict_iso` Step-4 sorry)" — accurate. The three-step chain assembles and compiles; it inherits the `dual_restrict_iso` residual.
  - **`homOfLocalCompat` (L705–874)**: described as "CLOSED (iter-256), axiom-clean" — confirmed accurate. No sorry in the body; the `set_option backward.isDefEq.respectTransparency false` annotation is appropriate (used only for this declaration and flagged in the history). L766 "no sorry remains in this declaration" — accurate.
  - The 7 typed sorry bullets in `sliceDualTransport` each carry a concise description of the remaining obstacle (codomainMap friction (a)/(b), naturality, invFun, map_add', map_smul', left_inv, right_inv). This is good practice for typed scaffolds.

---

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

- **outdated comments**: none
- **suspect definitions**: 1 flagged (minor)
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - **NEW SCAFFOLD FILE.** 5 typed `sorry` declarations + 1 real def. All sorry proofs carry detailed proof sketches explaining why the content is absent from Mathlib. Docstrings are accurate.
  - **[L6] `import Mathlib`**: full Mathlib import. Not wrong, but expensive; project convention elsewhere uses targeted imports. Minor bad practice.
  - **[L89] `CechNerve` signature**: takes `(𝒰 : X.OpenCover) (F : X.Modules)` with no `[Finite 𝒰.I₀]` or `[Separated X]` — consistent with the nerve being defined for any cover (the module docstring says "When `X` is separated each intersection is affine" but this is an informal comment about the well-behavedness of the nerve, not a hypothesis). OK.
  - **[L118] `CechComplex` signature**: takes `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules)` with no `[QuasiCompact f]`, `[IsSeparated f]`, or `[Finite 𝒰.I₀]`. The module docstring says "Throughout, `f : X ⟶ S` is a quasi-compact, separated morphism" but these conditions are not in the `CechComplex` signature. Minor signature-docstring mismatch; the hypotheses may be implicit (e.g. in the blueprint's "throughout") but Lean readers expect them in the type.
  - **[L144] `CechAcyclic.affine` hypothesis `[IsAffineHom f]`**: the theorem is about Serre vanishing on affine `X`. The `[IsAffineHom f]` hypothesis (which makes `f` affine) is stronger than Serre vanishing requires; Serre vanishing needs only `[IsAffine X]` and the structure of the Čech complex. This may be intentional (to ensure the complex lives over an affine base in the relative setting), but the blueprint docstring says "for quasi-coherent `F` and separated quasi-compact `f`" as the general hypothesis, making the affine-hom restriction here more restrictive than advertised. Minor potential over-hypothesis.
  - **[L209–211] `cechHigherDirectImage`** — the only non-sorry definition. It computes `(CechComplex f 𝒰 F).homology i`, where `CechComplex` is itself `sorry`. In Lean the definition type-checks and produces a value of type `S.Modules`, but the mathematical content is void since the underlying complex is sorry. The docstring says this "requires **no** enough-injectives hypothesis" — true at the type-signature level, accurate for the intended type design. The dependence on a sorry base is expected for a scaffold file and is not an excuse-comment. Flagged as minor: a reader might be surprised that the "unconditional" definition is unconditionally void.
  - **[L181] `cech_computes_higherDirectImage`**: hypothesis `[HasInjectiveResolutions X.Modules]` is needed because `higherDirectImage` (from the companion file) is a derived functor. Honest.
  - **[L241] `cech_flatBaseChange`**: uses `Scheme.Modules.pullback g` which may or may not match the name in `LineBundlePullback.lean` — not audited for cross-file name resolution here (read-only scope), but the signature is plausible.
  - All sorry bodies include specific references to Stacks tags and honest explanations of the Mathlib absence.

---

## Must-fix-this-iter

None. No declaration claims a proof is closed when it contains a `sorry`, no weakened-wrong definitions, no axioms on non-trivial claims, and no excuse-comments admitting wrongness.

---

## Major

- `TensorObjSubstrate.lean:43–44` — Status header says "ONE tracked typed-sorry residual" but the file has THREE sorries post iter-261 (L715, L2480, L2598). The two new D3′ sorries were added without updating the count. Any reader auditing the file by its own header will undercount by 2.
- `TensorObjSubstrate.lean:132` — Module layout note lists only `exists_tensorObj_inverse (sorry)` for this file, missing the D3′ sorries. Consistent with the L43–44 stale count.
- `DualInverse.lean:24–35` — File-module header labels `sliceDualTransport` "HELD (iter-258)" — stale by 3 iterations. The actual state is PARTIAL iter-261 (route-2 leg-A built, 7 typed sorries). A reader following only the header would incorrectly believe the decl has not been worked since iter-258.

---

## Minor

- `DualInverse.lean:444` — In-body comment in `dual_restrict_iso` says `sliceDualTransport`'s ".hom is currently a sorry". Now inaccurate: the body is a partially-built `LinearEquiv.toModuleIso` with 7 typed sorry bullets, not a single sorry.
- `CechHigherDirectImage.lean:6` — `import Mathlib` (full); project elsewhere uses targeted imports. Not wrong, just expensive.
- `CechHigherDirectImage.lean:118` — `CechComplex` signature omits `[QuasiCompact f]`, `[IsSeparated f]`, `[Finite 𝒰.I₀]` that the module docstring implies are in force "throughout". Minor signature-docstring gap.
- `CechHigherDirectImage.lean:144` — `CechAcyclic.affine` includes `[IsAffineHom f]` which is more restrictive than Serre vanishing requires (only `[IsAffine X]` needed), and more restrictive than the file's "separated quasi-compact" preamble advertises.
- `CechHigherDirectImage.lean:209` — `cechHigherDirectImage` is a real def built on a sorry dependency (`CechComplex`). The docstring's "unconditional" claim is accurate at the type-signature level, but a first reader may be surprised the definition has no mathematical content yet.

---

## Excuse-comments (always called out separately)

None flagged. No declaration carries a comment admitting the code is wrong, temporarily placeholder, or "will fix later".

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: The three files are honestly scaffolded — all sorries are typed, labeled, and accompanied by proof sketches — but the **status headers in both TensorObjSubstrate.lean and DualInverse.lean are stale after iter-261's additions** and need updating to reflect the actual sorry counts and the current build state of `sliceDualTransport`.
