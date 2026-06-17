# Blueprint Writer Report

## Slug
a1c-relpic

## Status
COMPLETE — new chapter `Picard_RelPicFunctor.tex` written with all six
declaration blocks from the directive, full citation discipline,
$\uses{}$ graph wired to A.1.b, and a verification flag noted for the
abelian-group-valued étale sheafification on the Lean side. No
strategy-modifying findings.

## Target chapter
`blueprint/src/chapters/Picard_RelPicFunctor.tex` (NEW; did not exist
before this iter).

## Changes Made
- **Added chapter scaffolding** — `\chapter{The relative Picard functor
  and its \'etale sheafification}`, `\label{chap:Picard_RelPicFunctor}`,
  `% archon:covers AlgebraicJacobian/Picard/RelPicFunctor.lean`. Two
  STRATEGY / planner-directive notes at top mirroring the convention
  of sibling chapters `Picard_LineBundlePullback.tex` and
  `Picard_FGAPicRepresentability.tex`.
- **Added section** `sec:relpic_setup` — motivation block linking to
  `\cref{chap:Picard_LineBundlePullback}` and naming the two
  responsibilities of the chapter (group refinement + étale sheafification).
- **Added lemma** `\lemma`/`\label{lem:rel_pic_sharp_groupoid}`/
  `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup}` — the
  abelian-group structure descends from $\Pic(C \times_k T)$ through
  $\pi_T^*\Pic(T)$ to the quotient $\Pic^\sharp_{C/k}(T)$.
  - Proof sketch added: Y — appeals to tensor-product abelian-group
    structure (Stacks tag 01CR / Hartshorne II~\S 6) and the tensor
    preservation of pullback.
- **Added definition** `\definition`/`\label{def:rel_pic_sharp}`/
  `\lean{AlgebraicGeometry.Scheme.PicSharp}` — the
  group-valued relative Picard presheaf
  $T \mapsto \Pic(C \times_k T)/\pi_T^*\Pic(T)$ as a functor
  $(\Sch/k)^{op} \to \Ab$.
- **Added lemma** `\lemma`/`\label{lem:rel_pic_sharp_functorial}`/
  `\lean{AlgebraicGeometry.Scheme.PicSharp.functorial}` — the
  naturality maps of `thm:pullback_natural` are abelian-group
  homomorphisms with respect to the structure of
  `lem:rel_pic_sharp_groupoid`.
  - Proof sketch added: Y — tensor preservation + pre-existing
    set-valued naturality, one-step strengthening.
- **Added theorem** `\theorem`/`\label{thm:rel_pic_sharp_presheaf}`/
  `\lean{AlgebraicGeometry.Scheme.PicSharp.presheaf}` — the assembly
  step: the three lemmas above package as a functor
  $(\Sch/k)^{op} \to \AddCommGroup$, the group-valued presheaf.
  - Proof sketch added: Y — three-line assembly.
- **Added definition** `\definition`/
  `\label{def:rel_pic_etale_sheafification}`/
  `\lean{AlgebraicGeometry.Scheme.PicScheme}` — the étale-sheafification
  $\Pic^\sharp_{(C/k)\et} := (\Pic^\sharp_{C/k})^{\sim_\et}$, with
  Kleiman's Exercise `ex:Alr` cited for the algebraically-closed-point
  triviality remark.
- **Added theorem** `\theorem`/
  `\label{thm:rel_pic_etale_sheaf_group_structure}` — étale
  sheafification preserves the abelian-group target, i.e.\ the
  sheafification is itself a presheaf $(\Sch/k)^{op} \to \AddCommGroup$.
  - Proof sketch added: Y — appeals to the standard plus-construction
    pattern with values in an algebraic category; Lean side uses
    Mathlib `CategoryTheory.Sheafification` with target $\AddCommGroup$.
  - This block has no $\lean{...}$ tag because it is an auxiliary
    statement (no project-side Lean target named in the directive); it
    flows downstream into the encoding section.
- **Added section** `sec:relpic_lean_encoding` — five-bullet
  Lean-encoding map (one bullet per directive-named Lean signature) plus
  a verification flag for the Mathlib `Sheafification`-with-$\AddCommGroup$
  API at the pinned commit.
- **Added section** `sec:relpic_out_of_scope` — five-bullet out-of-scope
  list pointing forward to A.2.c, A.3, the comparison theorem
  (Kleiman \S 2 th:cmp), the Albanese, and the group-scheme refinement on
  the representing object.
- **Added section** `sec:relpic_consistency_check` — `$\uses$` graph
  audit confirming every cross-reference resolves either inside this
  chapter or inside the on-disk `Picard_LineBundlePullback.tex`. No
  forward reference to an off-disk chapter.

## Cross-references introduced
- `\uses{def:line_bundle_on_product, def:pullback_along_projection,
  thm:relative_pic_quotient_well_defined}` in
  `lem:rel_pic_sharp_groupoid` — all three labels live in
  `Picard_LineBundlePullback.tex` (verified by reading the on-disk file).
- `\uses{def:line_bundle_on_product, def:pullback_along_projection,
  thm:relative_pic_quotient_well_defined, lem:rel_pic_sharp_groupoid}`
  in `def:rel_pic_sharp` — first three from A.1.b on disk, the fourth
  from inside this chapter.
- `\uses{def:rel_pic_sharp, lem:pullback_compose,
  lem:rel_pic_sharp_groupoid, thm:pullback_natural}` in
  `lem:rel_pic_sharp_functorial` — `lem:pullback_compose` and
  `thm:pullback_natural` live in `Picard_LineBundlePullback.tex`
  (verified).
- `\uses{def:rel_pic_sharp, lem:rel_pic_sharp_functorial,
  lem:rel_pic_sharp_groupoid, thm:pullback_natural}` in
  `thm:rel_pic_sharp_presheaf` — three internal + one external
  (`thm:pullback_natural` on disk in A.1.b).
- `\uses{def:rel_pic_sharp, thm:rel_pic_sharp_presheaf}` in
  `def:rel_pic_etale_sheafification` — both internal.
- `\uses{def:rel_pic_etale_sheafification, thm:rel_pic_sharp_presheaf}`
  in `thm:rel_pic_etale_sheaf_group_structure` — both internal.
- `\cref{chap:Picard_LineBundlePullback}` and
  `\cref{chap:Picard_RelativeSpec}` cited in the strategy notes and
  Lean-encoding section — both chapter labels confirmed by reading the
  on-disk chapter headers.
- `\cref{chap:Picard_FGAPicRepresentability}` cited in the Lean
  encoding + out-of-scope section as a forward pointer; this chapter is
  on disk (verified) so the `\cref` resolves.

## References consulted
- `references/summary.md` — confirmed the index entry for
  `kleiman-picard.md`/`kleiman-picard.pdf` as the Route~A primary source
  and the Section→PDF page map.
- `references/kleiman-picard.md` — read the §2 / §4 location map
  (`df:Pfs` at L1311, `th:cmp` at L1384, `th:main` at L2155).
- `references/kleiman-picard-src/kleiman-picard.tex` — verbatim quotes
  drawn from L1274--L1290 (`df:aPf` + the ``prepared presheaf''
  paragraph), L1311--L1318 (`df:Pfs`, the named étale sheaf
  $\Pic_{(X/S)\et}$), L1320--L1328 (the ``associated sheaf'' paragraph
  that justifies the sheafification step), L1350--L1361 (Exercise
  `ex:Alr`, the algebraically-closed-point isomorphisms), and a
  glance at L2043--L2074 + L2155--L2166 to confirm that Kleiman's
  Main Theorem represents $\Pic_{(X/S)\et}$ (not the bare presheaf).
  Every `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` block in the
  chapter copies text verbatim from this file (line ranges named in the
  `% SOURCE:` parenthetical).
- `references/stacks-coherent.md` — read; confirmed it covers
  \emph{only} tag 02KH (flat base change of $R^if_*$), \emph{not}
  any étale-sheafification tag. No verbatim quote drawn from this file
  in the chapter; the directive's pointer to it is therefore noted as
  not-applicable in ``Notes for Plan Agent'' below.
- `blueprint/src/chapters/Picard_LineBundlePullback.tex` — confirmed
  every label I `\uses{}` cross-references actually lives there
  (`def:line_bundle_on_product`, `def:pullback_along_projection`,
  `lem:pullback_compose`, `thm:relative_pic_quotient_well_defined`,
  `thm:pullback_natural`).
- `blueprint/src/chapters/Picard_RelativeSpec.tex` — confirmed
  `chap:Picard_RelativeSpec` is the label of the on-disk chapter.
- `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` —
  confirmed `chap:Picard_FGAPicRepresentability` is on disk; this
  chapter $\uses{}$ no labels inside it (only a `\cref` commentary
  pointer).
- `blueprint/src/macros/common.tex` — confirmed that `\Sch`, `\Pic`,
  `\Hom`, `\Spec`, `\AddCommGroup`, `\op` are all already defined; no
  new macros required.

## Macros needed (if any)
None. All notation used (`\Sch`, `\Pic`, `\AddCommGroup`, `\Spec`,
`\Hom`, `\cref`) is in `macros/common.tex`. The Kleiman notation
`\Pic_{(X/S)\et}`, `\Pic_{(X/S)\zar}`, `\Pic_{(X/S)\fppf}` appears only
inside verbatim `% SOURCE QUOTE:` blocks (commented out, not parsed by
LaTeX); the body prose uses spelled-out ``étale'' / ``Zariski'' / ``fppf''
words or the project's existing `\Pic^\sharp_{(C/k)\et}` ad-hoc
subscript.

## Reference-retriever dispatches (if any)
None. The directive's two named sources (`references/kleiman-picard.pdf`
and `references/stacks-coherent.md`) are both already on disk; the
Kleiman LaTeX source `kleiman-picard-src/kleiman-picard.tex` supplied
every verbatim quote needed.

## Notes for Plan Agent

1. **Directive's reference to `references/stacks-coherent.md` was not
   actionable.** That file documents only Stacks tag 02KH (flat base
   change of higher direct images). It contains \emph{no} étale-sheafification
   tag. The relevant Stacks tag for ``sheafification of a presheaf of
   abelian groups is a sheaf of abelian groups'' is in the Sites
   chapter (Stacks tag 00WK / 00WL family, or 03DC for the general
   plus-construction), \emph{not} the Cohomology-of-Schemes chapter.
   No `% SOURCE` for this fact was inserted in the chapter; the
   `thm:rel_pic_etale_sheaf_group_structure` block cites Kleiman \S 2
   for the abelian-group target of the sheafification and labels the
   underlying ``sheafification preserves abelian groups in any
   Grothendieck topology'' as a standard fact handled by Mathlib's
   `CategoryTheory.Sheafification`. If the plan agent wants a Stacks
   tag pinned here, a follow-up `reference-retriever` for the Sites
   chapter (tag 00WK / 03DC) would close the gap; I did not dispatch
   one because the chapter's prose makes the structural appeal cleanly
   without it.

2. **Verification flag for Mathlib API.** The Lean-encoding section
   contains an explicit ``Verification flag'' for the prover: the
   abelian-group-valued sheafification on the étale site of $\Sch/k$
   needs to be checked against the Mathlib snapshot at the pinned
   commit. If the API is not yet wired (e.g.\ if Mathlib has the
   set-valued sheafification but not the abelian-group-valued one),
   the project-side fallback is to combine the set-valued
   sheafification with the $\AddCommGroup$ forgetful functor. The
   chapter does \emph{not} claim Mathlib presence; the verification is
   the prover's job at L344--L347 of the Lean-encoding bullet.

3. **`thm:rel_pic_etale_sheaf_group_structure` is not in the
   directive's ``Lean signature targets'' list.** The directive named
   five Lean targets (`PicSharp`, `PicScheme`, `PicSharp.functorial`,
   `PicSharp.addCommGroup`, `PicSharp.presheaf`); I added a sixth
   blueprint block ``Étale sheafification preserves the abelian-group
   structure'' (no `\lean{...}` tag) because the directive's
   ``Theorem: étale-sheafification preserves group structure''
   bullet explicitly asked for it as a separate statement. If the plan
   agent prefers, this can be folded into the body of
   `def:rel_pic_etale_sheafification` next iter as a structural remark.

4. **Mild scope check.** The directive's first sentence
   characterising the chapter says ``Set'' as the target category in
   the displayed definition, but the body subsequently builds the
   abelian-group refinement. I interpreted the ``Set'' arrow in the
   directive as the same Kleiman-style ``forget structure first, then
   add it'' presentation as the on-disk A.1.b chapter, and the chapter
   body says explicitly that the target is $\AddCommGroup$ /
   abelian groups (consistent with Kleiman \S 2 `df:aPf` + `df:Pfs`).
   No strategy-level conflict; flagging for transparency.

5. **Sibling chapter `Picard_FGAPicRepresentability.tex` already
   references this chapter** at its L9 (``...the \'etale-sheafified
   relative Picard functor (\cref{chap:Picard_RelPicFunctor}, A.1.c)...''),
   so the `\cref` cross-reference there will now resolve.

## Strategy-modifying findings

None. The chapter is a clean structural refinement of A.1.b followed by
a single sheafification step; both moves are direct Kleiman \S 2 transcription
(`df:Pfs` is verbatim the construction, and the associated-sheaf paragraph
L1320--L1328 is verbatim the sheafification step). No definition,
theorem, or hypothesis surfaced that would require updating
`STRATEGY.md`.
