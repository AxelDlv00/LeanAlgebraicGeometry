# Blueprint Writer Directive

## Slug
differentials-cosmetic-iter116

## Target chapter
blueprint/src/chapters/Differentials.tex

## Strategy context

This is a **prose-only cosmetic cleanup pass** unrelated to any strategic decision. The blueprint chapter is otherwise sound (iter-115 + iter-116 blueprint-reviewer audits both PASS with this single class of finding). The plan agent is dispatching this writer in parallel with the iter-116 mandatory critics; do not block on or wait for any other dispatches.

## Required content

Two cosmetic Mathlib-name corrections in the chapter prose:

1. **Line ~59** (the proof of `\lem:relative_kaehler_isSheafUniqueGluing`, Step 1, paragraph naming the localisation map of Kähler differentials). The chapter currently writes `\texttt{KaehlerDifferential.isLocalizedModule\_map}`; the correct Mathlib b80f227 name is **`KaehlerDifferential.isLocalizedModule`** with **no `_map` suffix**. Source: `Mathlib.RingTheory.Kaehler.TensorProduct` (verified iter-115 + iter-116 plan-phase via `lean_loogle`; the instance has signature `IsLocalizedModule p (↑R (KaehlerDifferential.map R S A B))` — i.e. it *operates on* `KaehlerDifferential.map`, but the name itself is just `KaehlerDifferential.isLocalizedModule`).

2. **Line ~73** (the same proof, Step 1, paragraph naming Mathlib's quasi-coherent module sheaf `\widetilde{\,\cdot\,}`). The chapter currently writes `\texttt{AlgebraicGeometry.Modules.tilde}`; the correct Mathlib b80f227 name is **`AlgebraicGeometry.tilde`** (namespace `AlgebraicGeometry`, not `AlgebraicGeometry.Modules`). Source: `Mathlib.AlgebraicGeometry.Modules.Tilde:87` (verified iter-115 + iter-116 plan-phase). Note: the *file path* is `Mathlib/AlgebraicGeometry/Modules/Tilde.lean` (so the chapter prose `(\texttt{Mathlib.AlgebraicGeometry.Modules.Tilde})` for the module path is correct), but the *declaration namespace* inside that file is `AlgebraicGeometry`.

Apply BOTH corrections in this single edit. Do not change anything else in the chapter.

### Optional bonus correction (only if it falls out of the same edit pass)

**Line ~168** (`\def:relative_kaehler_sheaf` block) carries a soft "morally quasi-coherent" prose remnant that the iter-115 + iter-116 reviewers both flagged as soon-severity. If you have the chapter open and the wording rephrases naturally to "the Lean object is quasi-coherent on each affine chart by construction; the `IsQuasicoherent` typeclass on the assembled sheaf is not yet registered" (or equivalent), apply that tightening. **Skip if it requires more than a few words of rewording** — this is a soon-severity item, not must-fix-this-iter.

## Out of scope

- Do not touch any other chapter (`Differentials.tex` only).
- Do not touch the Lean file `AlgebraicJacobian/Differentials.lean` (writer-side write domain is blueprint chapters only). The iter-116 blueprint-reviewer noted that the same misnaming `KaehlerDifferential.isLocalizedModule_map` is propagated in the Lean file's inline narrative comments at L72, L112, L246; that's flagged for a future doctor/refactor pass and is outside your write domain.
- Do not change the recipe in § "Unique-gluing form" (Step 1 / Step 2 / Step 3) — the iter-114 mathlib-analogist-verified recipe is the source of truth and was confirmed correct by iter-115 + iter-116 reviewers.
- Do not change the `\thm:serre_duality_genus` block (iter-115 / iter-116 reviewers confirmed it matches the Lean signature).
- Do not change the `[gap]` annotation in Step 2 of the unique-gluing proof — the iter-116 user escalation is asking the user about whether to build the missing Mathlib bridge, refactor away the gap, or declare it as named gap #8; none of these decisions changes the present-state truth that the bridge is missing in Mathlib b80f227.
- Do not modify `\leanok` markers (those are managed by the deterministic `sync_leanok` phase; writer agents must not touch them).

## References

- `Mathlib.RingTheory.Kaehler.TensorProduct` — the `KaehlerDifferential.isLocalizedModule` instance (no `_map` suffix).
- `Mathlib.AlgebraicGeometry.Modules.Tilde:87` — the `AlgebraicGeometry.tilde` declaration (namespace `AlgebraicGeometry`).

## Expected outcome

The chapter `Differentials.tex` reads with the two corrected Mathlib names in the proof of `\lem:relative_kaehler_isSheafUniqueGluing` Step 1. Diff size: 2 small text replacements (likely <5 lines net change), plus optional bonus rewording on L168 if it falls out of the pass. Iter-117 mandatory blueprint-reviewer dispatch should re-verify and report `complete: true × correct: true` on this chapter.

## Notes for the writer

- This is a tiny edit. Do not over-think it.
- Do not spawn child reference-retriever subagents — the references are already on disk and the names have been verified by the plan agent.
- Report any cross-chapter inconsistencies you happen to notice in your "Notes for Plan Agent" section (the iter-116 reviewer already noted line-reference drift in `Cohomology_MayerVietoris.tex:1198` and `Picard_Functor.tex:88` — those are separate writer dispatches, not yours).
