# Blueprint Writer Directive (iter-172, slug `route-a1-retry2`)

## Target chapter

`blueprint/src/chapters/Picard_RelativeSpec.tex` (NEW chapter — does NOT yet exist).

## Iter-171 status

This is the **third dispatch** for this chapter. The iter-171 attempts both terminated without writing the chapter to disk:
- attempt 1 (`route-a1-decompose`): exited unsuccessful (likely API timeout during reference reading);
- attempt 2 (`route-a1-decompose-retry`): killed mid-investigation; logged "I have everything I need. Now I'll write" and was terminated 24 minutes into the run before producing any file edit.

**Optimisation for this iter**: prioritise WRITING THE CHAPTER over deep source-quotation exploration. The references have already been read in the prior attempts; treat the verbatim quotes as a stretch goal, NOT a gate. **Write the chapter first**, with `% SOURCE QUOTE: <verbatim>` placeholders where you do not yet have a verbatim block, and only fill in the quotes AFTER the structural body is on disk. Better an 80%-complete chapter on disk than a 100%-research-but-zero-chapter outcome (which is what the prior two attempts produced).

## Strategy context

Route A is the project's CRITICAL PATH for the positive-genus arm of `nonempty_jacobianWitness`. Route A has had **zero prover dispatch for 6 consecutive iters**. The smallest entry point is A.1.a `RelativeSpec` (a relative-spectrum functor `Spec_X : QCohAlg(X)ᵒᵖ → Sch/X`). This chapter unlocks iter-173 file-skeleton lane on `AlgebraicJacobian/Picard/RelativeSpec.lean`.

## Required content (verbatim from iter-171 directive — RE-USE IT)

The full original directive is at `.archon/logs/iter-171/blueprint-writer-route-a1-decompose-directive.md`. Re-read it for the structural recipe. Brief recap:

1. `% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean` at the top.
2. Section "Setup and motivation" — one paragraph.
3. **Definition** `def:qc_sheaf_of_algebras` / `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (Stacks 01LL).
4. **Theorem** `thm:relative_spec_exists` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` (Stacks 01LQ).
5. **Theorem** `thm:relative_spec_univ` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` (Stacks 01LQ universal property).
6. **Theorem** `thm:relative_spec_affine_base` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}` (Stacks 01LO — affine base reduces to absolute Spec of global sections).
7. **Theorem** `thm:relative_spec_base_change` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}` (Stacks 01LS).
8. **Theorem** `thm:relative_spec_functorial` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}` (Stacks 01LR or Hartshorne II Ex 5.17(b)).
9. Section "Lean encoding" — one paragraph naming `Mathlib.AlgebraicGeometry.AffineScheme.glueOpens` / `Scheme.GlueData` as the implementation backbone.
10. Section "Out of scope" — one paragraph.
11. `% SOURCE: Hartshorne II Exercise 5.17 + Stacks tags` block above the first theorem.
12. `\uses{}` annotations cross-linking theorems.

## Verbatim-quote source files (already in tree)

- `references/stacks-constructions.tex` — contains Stacks 01LL, 01LO, 01LQ, 01LR, 01LS (chapter "Constructions of Schemes" in the Stacks Project local mirror). The iter-171 retry verified this — it read parts of the file before being terminated.
- `references/hartshorne-algebraic-geometry.pdf` — Hartshorne II Ex 5.17 (a)-(c).

**Caveat from the iter-171 retry log**: the actual tag for "RelativeSpec exists" inside `references/stacks-constructions.tex` is **`lemma-glue-relative-spec` (tag 01LQ)**, NOT 01LL. 01LL is the SECTION label, not the existence-lemma tag. The retry log noted this. Use the correct tag in your `% SOURCE:` comment. Other observed tags from the retry log: `situation-relative-spec` (01LL-section), `lemma-spec-inclusion`, `lemma-transitive-spec`, `lemma-glue-relative-spec` (the actual existence lemma — likely 01LQ), `lemma-spec-base-change` (01LS area), `lemma-spec-affine` (01LO area, the affine base case).

## Time-budget guidance

Cap reference-reading at ~5 minutes. If a `% SOURCE QUOTE:` cannot be located in under 1 minute, leave a `% SOURCE QUOTE: TODO retrieve from references/stacks-constructions.tex tag XXXX` placeholder and proceed. The chapter is more valuable on disk with TODO placeholders than not on disk at all.

## Out of scope

- Do NOT add `\leanok` / `\mathlibok` markers (managed by sync_leanok / review).
- Do NOT touch other chapter files (write-domain restricted to `Picard_RelativeSpec.tex`).
- Do NOT modify `content.tex` (the plan agent updates that).
- Do NOT cite a source you have not just read locally. Use TODO placeholders if you genuinely could not read.

## Expected outcome

A NEW file `blueprint/src/chapters/Picard_RelativeSpec.tex` of ~150-250 lines on disk before your session ends, containing the 6 declaration blocks above. Verbatim quotes are a stretch goal, NOT a gate. The chapter's first line declares `% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean`. No `\leanok` / `\mathlibok` markers anywhere.

After landing the chapter, verify with one `Read` on the new file. Report what you wrote AND what you left as TODO placeholders.
