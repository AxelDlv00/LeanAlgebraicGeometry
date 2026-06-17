# Blueprint Writer Report

## Slug
rpf-placeholder-note

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_RelPicFunctor.tex

## Changes Made

### 1. Five sync\_leanok-deterring `% NOTE (iter-199 plan agent)` annotations

For each of the five blocks whose Lean closure at b80f227 is a placeholder body, I inserted a single LaTeX comment block flagging the placeholder shape, the gating Mathlib gap, and an explicit "DO NOT promote to \leanok" instruction to the deterministic `sync_leanok` phase and the review agent.

- **`def:rel_pic_sharp`** (Lean: `AlgebraicGeometry.Scheme.PicSharp`)
  NOTE placed immediately after `\end{definition}`. Flags the constant-PUnit-functor placeholder body `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of PUnit)`, names the `Scheme.Modules` monoidal-structure gap, and tells `sync_leanok` not to promote.
- **`lem:rel_pic_sharp_functorial`** (Lean: `AlgebraicGeometry.Scheme.PicSharp.functorial`)
  NOTE placed immediately before `\begin{proof}` (after the existing `% SOURCE QUOTE PROOF:` block). Flags the zero-AddMonoidHom placeholder AND the additional `sorryAx` typeclass leak via the codomain's `Zero` instance (because that instance derives from the sorry-body `addCommGroup`). Same `DO NOT promote` instruction.
- **`thm:rel_pic_sharp_presheaf`** (Lean: `AlgebraicGeometry.Scheme.PicSharp.presheaf`)
  NOTE placed immediately before `\begin{proof}` (after the existing `% SOURCE QUOTE PROOF:` block). Flags that the body is `PicSharp _C`, i.e.\ a re-export of the constant-PUnit placeholder above. Same `DO NOT promote` instruction.
- **`def:rel_pic_etale_sheafification`** (Lean: `AlgebraicGeometry.Scheme.PicSharp.etSheaf`)
  NOTE placed immediately after `\end{definition}`. Flags that the sheafification machinery (`presheafToSheaf etaleTopology AddCommGrpCat` / `plusPlusSheaf`) is correctly invoked but applied to the wrong (constant-PUnit-functor) input. Same `DO NOT promote` instruction.
- **`thm:rel_pic_etale_sheaf_group_structure`** (Lean: `AlgebraicGeometry.Scheme.PicSharp.etSheaf_group_structure`)
  NOTE placed immediately before `\begin{proof}` (after the existing `% SOURCE QUOTE PROOF:` block). Flags the zero-natural-transformation `Nonempty` witness `⟨0⟩`, and explicitly states that the Lean statement type has been weakened to bare `Nonempty (presheaf C ⟶ etSheaf.obj)` to admit this trivial witness. `DO NOT promote to \leanok-on-the-canonical-statement` instruction.

### 2. Type-weakening resolution for `thm:rel_pic_etale_sheaf_group_structure` — path (a)

Per the directive's recommendation for parsimony, I applied **resolution path (a)**: weakened the existing block's prose to match the Lean `Nonempty (presheaf C ⟶ etSheaf.obj)` type, and added a separate forward-looking theorem block stating the canonical morphism + universal property.

- **Revised** `thm:rel_pic_etale_sheaf_group_structure` —
  - Kept the existing citation header (`% SOURCE:`, `% SOURCE QUOTE:`, `\textit{Source: ...}`) unchanged. The Kleiman quote still attests to the underlying mathematics that the forward-looking block formalizes.
  - Rewrote the prose body to state that the block currently records only the bare existence of a morphism of presheaves of abelian groups `\Pic^\sharp_{C/k} \to \Pic^\sharp_{(C/k)\et}` (nonempty hom-set), and explicitly cross-references the new `\cref{thm:rel_pic_etale_sheaf_unit_canonical}` for the canonical-morphism + universal-property version, noting it is deferred until the `Scheme.Modules` monoidal-structure gap is closed.
  - Rewrote the proof body to match the weakened statement: the canonical sheafification unit supplies a morphism, witnessing nonemptiness; full universal property is deferred to the forward-looking block's proof sketch.
  - Did NOT touch the existing `\leanok` marker (per directive's out-of-scope rule).
- **Added theorem** `\theorem`/`\label{thm:rel_pic_etale_sheaf_unit_canonical}` (no `\lean{...}` pin, no `\leanok`) —
  Title: "Canonical sheafification unit with universal property (forward-looking)".
  Statement: existence of a canonical morphism `\eta : \Pic^\sharp_{C/k} \to \Pic^\sharp_{(C/k)\et}` of presheaves of abelian groups, with the universal property characterising the pair as initial among `(\mathcal{F}, \Pic^\sharp_{C/k} \to \mathcal{F})` consisting of an étale sheaf of abelian groups and a presheaf morphism into it; consequently the abelian-group structure on the sheafification is uniquely determined.
  Citation: `% SOURCE: [Kleiman], "The Picard scheme", \S 2, df:Pfs + associated-sheaf paragraph (read from references/kleiman-picard-src/kleiman-picard.tex, L1311-L1328)` with verbatim `% SOURCE QUOTE:` matching the existing chapter quotes (df:Pfs body + the associated-sheaf paragraph through "associated to the relative Picard functor"). Visible `\textit{Source: ...}` line.
  Proof: standard sheafification + colimit-preservation of `\AddCommGroup \to \mathbf{Set}` argument.

### 3. Internal-consistency check refresh

- Updated the intro sentence in `\section{Internal-consistency check}` to acknowledge "six Lean-pinned declaration blocks (plus the forward-looking `\cref{thm:rel_pic_etale_sheaf_unit_canonical}`, which carries no `\texttt{\textbackslash lean\{\dots\}}` pin)".
- Added a bullet for `\cref{thm:rel_pic_etale_sheaf_unit_canonical}` listing its `\uses` set (`def:rel_pic_etale_sheafification`, `thm:rel_pic_sharp_presheaf`, `thm:rel_pic_etale_sheaf_group_structure`) and noting it is deferred until the `Scheme.Modules` gap is closed.
- Used `\texttt{\textbackslash lean\{\dots\}}` / `\texttt{\textbackslash uses\{\dots\}}` for the new prose discussing the macro names (safer than `\(\lean\)` / `\(\uses\)`, which expect mandatory arguments in print mode — see "Notes for Plan Agent" below).

### 4. Sections 3 and 4 of the directive (refresh + cleanup) — no chapter-side action

- **Directive §3 (refresh stale Lean-side cross-references).** The flagged staleness is a comment inside `RelPicFunctor.lean` itself (L505-508 of the Lean file); the chapter does not reference the absent pin, so no chapter-side action is required. The Lean comment is out of my write domain.
- **Directive §4 (optional internal-consistency cleanup).** I scanned the prose for stale `LineBundle.OnProduct` typed-sorry framing. The "Lean encoding" §`Gate annotation (iter-198 refresh)` paragraph (lines 716-734 in the modified file) already correctly attributes the residual gate to the `Scheme.Modules` monoidal-structure gap, and the surrounding text confirms `LineBundle.OnProduct` was concretized in iter-188. No staleness remains.

## Cross-references introduced

- `\cref{thm:rel_pic_etale_sheaf_unit_canonical}` added inside the prose body of the weakened `thm:rel_pic_etale_sheaf_group_structure` and inside its weakened proof — target label exists in this chapter (the new forward-looking block).
- `\cref{thm:rel_pic_etale_sheaf_unit_canonical}` listed as a new bullet in `\section{Internal-consistency check}`.
- Inside the new `thm:rel_pic_etale_sheaf_unit_canonical` block, the proof references Stacks tag 00WI and Kleiman \S 2 paragraph after df:Pfs (the same verbatim source quote shown in the citation header).

## References consulted

- `references/kleiman-picard-src/kleiman-picard.tex` — verified L1311-L1328 (the verbatim text of df:Pfs and the associated-sheaf paragraph following it) before drafting the `% SOURCE QUOTE:` of the new forward-looking block. The same verbatim is already used in the existing chapter for `def:rel_pic_etale_sheafification` and `thm:rel_pic_etale_sheaf_group_structure`; I confirmed it by re-reading the local source file rather than copying from chapter memory.

## Macros needed (if any)
None. All new prose uses existing project / leanblueprint macros (`\Pic^\sharp`, `\Sch`, `\AddCommGroup`, `\et`, `\cref`, `\texttt`, `\textbackslash`, etc.).

## Reference-retriever dispatches (if any)
None — the Kleiman text needed for the new forward-looking block was already in `references/kleiman-picard-src/kleiman-picard.tex` from prior iters.

## Notes for Plan Agent

- **Sync_leanok contract honoring NOTEs.** I assumed (per the directive) that the deterministic `sync_leanok` phase honors `% NOTE (iter-... plan agent): ... DO NOT promote ... \leanok ...` annotations as opt-out markers for `\leanok` promotion. If `sync_leanok` does NOT in fact scan for these NOTEs and instead operates purely on `\lean{...}` declaration presence + axiom-cleanliness of the Lean body, then on the next sync 4 of the 5 placeholder closures (`PicSharp`, `presheaf`, `etSheaf`, `etSheaf_group_structure`) — which are sorry-free at the source level — will still be falsely marked `\leanok`. Recommend confirming the sync_leanok scanner logic, or alternatively introducing a project-side `% leanok-skip` sentinel that the scanner recognises explicitly.

- **Pre-existing `\(\uses\)` constructions.** The chapter contains two pre-existing `\(\uses\)` constructions at lines 826 and 830 ("All \(\uses\) pointers resolve…", "not a \(\uses\) target"). The project's `print.tex` defines `\uses` as a one-argument macro (`\NewDocumentCommand{\uses}{m}{...}`), so these constructions invoke `\uses` without supplying the mandatory argument — they likely either fail or consume the following `\)` as the argument in print mode. They predate iter-199 and are out of scope for this directive; the new prose I added avoids the pattern by using `\texttt{\textbackslash uses\{\dots\}}`. Flagging in case a future writer or refactor wants to clean them up.

- **Pre-existing `\S~REF` placeholders.** The "Setup and motivation" section retains literal `\S~REF` placeholder text at lines 51, 52, 56 ("(\S~REF and \S~REF) verifies that the quotient is canonically…", "(\S~REF) takes the étale sheafification…"). These predate iter-199 and are out of scope for this directive. Flagging for a future iter to expand into proper `\cref{sec:...}` references.

- **Existing `\leanok` on `thm:rel_pic_etale_sheaf_group_structure`.** The block still carries `\leanok` (correctly, since the placeholder Lean closure does witness the now-weakened `Nonempty` statement axiom-cleanly). After the canonical sheafification unit is constructed and the Lean type is upgraded back to the full canonical morphism, the existing block's prose should be re-upgraded to match (the forward-looking block then folds in, or the forward-looking block's `\lean{...}` is retargeted at the same Lean name). I left both blocks pointing at the same Lean target conceptually so the future upgrade is a clean rebase.

## Strategy-modifying findings

None. The chapter's strategic role (A.1.c, sub-row of Route A, gate to A.2.c) is unchanged. The type-weakening resolution merely makes the prose honest about what the current iter-198 Lean closure formalizes, without altering the chapter's intended end-state; the forward-looking block records the eventual canonical statement so the strategy stays coherent.
