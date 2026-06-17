# Blueprint Writer Report

## Slug
fbc-reframe

## Status
COMPLETE — all four corrections applied to the FlatBaseChange chapter; no markers touched.

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

- **Added lemma** `\lemma`/`\label{lem:pushforward_spec_tilde_iso}` (no `\lean{}` pin, per directive — Lean decl not yet built) — Correction 3. States the canonical iso of `(Spec R)`-modules `(Spec φ)_* (tilde M) ≅ tilde(restr_φ M)` for `φ : R → R'` and an `R'`-module `M`. Marked as **Archon-original / bespoke infrastructure** with NO `% SOURCE QUOTE`: the classical statement `schemes-lemma-widetilde-pullback` is only `\ref`-ed inside `stacks-coherent.tex`/`stacks-constructions.tex`; its verbatim text lives in the Stacks *Schemes* chapter, which is NOT in `references/`, so I could not produce a faithful quote. Prose names the classical fact (direct image of a QC sheaf along an affine morphism = restriction of scalars, the pushforward companion of the tilde pullback formula) without fabricating a quote.
  - Proof sketch added: N (statement-only brick; it is the next prover target).
- **Added remark** (immediately after the new lemma) — notes the single iso discharges BOTH (a) the Γ/global-sections comparison (apply the section functor to the iso) AND (b) quasi-coherence of the pushforward (tilde is QC + QC closed under iso), so no separate "pushforward preserves quasi-coherent" theorem is needed.
- **Revised** `lem:affine_base_change_pushforward` statement — Correction 1. Added an explicit paragraph stating the quasi-coherence hypothesis on `\(\mathcal F\)` is essential (a general `O_X`-module is not `\widetilde M` over an affine open, so the affine description + tensor-associativity step are unavailable without it).
- **Revised** `lem:affine_base_change_pushforward` proof — Correction 2. Replaced the stale `% NOTE:` ("missing affine dictionary … Mathlib gap" + "iso local on an affine cover") with the corrected reframe note (tilde full-faithfulness collapses iso-of-Spec-modules to iso-of-concrete-`ModuleCat R'`-map; single absent brick = `lem:pushforward_spec_tilde_iso`; closing algebra = `cancelBaseChange`). Rewrote the proof body in three stages: (i) locality first reduction → all-affine, flagging where quasi-coherence is used to write `F = tilde M`; (ii) reduction to a concrete `ModuleCat R'` map via full-faithfulness of `tilde` (essential image = QC; counit iso ⇔ QC; counit naturality gives `IsIso α ⇔ IsIso Γ(α)`), explicitly stating this avoids all section-level SMul/Module plumbing, with the prose construction hints (`f_top` conjugate to `φ` via Γ–Spec unit naturality; preimage of top = top, no transport; residual scalar identity via restriction-of-scalars + scalar-tower as in Mathlib's tilde treatment); (iii) identify `Γ(α)` via `lem:pushforward_spec_tilde_iso` and close by `(R'⊗_R A)⊗_A M ≅ R'⊗_R M` (no flatness).
- **Revised** `thm:flat_base_change_pushforward` statement — Correction 1. Added a paragraph stating the quasi-coherence hypothesis is essential (makes `f_*F` QC on the affine base = tilde of a module; lets the affine reduction write `F = tilde M`).
- **Revised** `thm:flat_base_change_pushforward` proof `% NOTE:` — Correction 4. Re-pointed it at `lem:pushforward_spec_tilde_iso` + the full-faithfulness reframe as the affine input (dropping the superseded "affine dictionary" framing); kept the genuine Čech/affine-cover SheafOfModules gap and the multi-lane-build characterization.

## Cross-references introduced
- `\uses{... lem:pushforward_spec_tilde_iso}` added to the proof of `lem:affine_base_change_pushforward` — target is the new lemma in this same chapter (verified present).
- The new `lem:pushforward_spec_tilde_iso` block carries no `\uses{}` (bespoke base infrastructure with no in-blueprint dependency), consistent with the directive.

## References consulted
- `analogies/fbc-dict.md` — the mathlib-analogist consult; source of all four corrections (QC hypothesis, tilde full-faithfulness reframe, the single absent object-iso brick, accessor/preimage construction hints).
- `references/summary.md` — confirmed `stacks-coherent` is the QC base-change source; no Stacks *Schemes* chapter present.
- `references/stacks-coherent.tex`, `references/stacks-constructions.tex` — grepped for `schemes-lemma-widetilde-pullback`; found only `\ref`s, not the statement text → cannot quote → new brick marked Archon-original (no fabricated quote). The existing verbatim `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks (from `stacks-coherent.tex`) were left byte-for-byte intact.

## Macros needed (if any)
- None. `remark` environment confirmed defined in `macros/common.tex` (`\newtheorem{remark}[theorem]{Remark}`); all begin/end environments balanced (lemma 5/5, theorem 1/1, definition 1/1, remark 1/1, proof 5/5).

## Reference-retriever dispatches (if any)
- None. The one potentially-citable classical source (`schemes-lemma-widetilde-pullback`, Stacks *Schemes* chapter) was not retrieved; the directive explicitly permits marking the brick Archon-original in that case, so no dispatch was warranted for a statement-only infrastructure block.

## Notes for Plan Agent
- The new `lem:pushforward_spec_tilde_iso` has no `\lean{}` pin by design (decl not yet built). When the prover lands the Lean decl, the pin should be added and `sync_leanok` will mark it.
- If a verbatim Stacks *Schemes* source for the affine-pushforward-of-tilde formula is later wanted, a reference-retriever should fetch the *Schemes* chapter (tag for `lemma-widetilde-pullback`); the brick prose currently stands as Archon-original without a `% SOURCE QUOTE`.
- Per directive I did not add/remove any `\leanok`/`\mathlibok` markers; the new lemma + remark blocks are intentionally unmarked.

## Strategy-modifying findings
(none — the QC-hypothesis fix is being applied to the Lean signatures this iter per the directive/consult; it sharpens but does not change the chapter's role in the strategy.)
