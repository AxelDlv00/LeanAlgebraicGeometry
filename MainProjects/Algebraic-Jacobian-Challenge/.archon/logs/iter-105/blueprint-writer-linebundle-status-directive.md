# Blueprint Writer Directive

## Slug
linebundle-status

## Target chapter
blueprint/src/chapters/Picard_LineBundle.tex

## Strategy context

Phase C1 plans to refactor `def LineBundle X` in `AlgebraicJacobian/Picard/LineBundle.lean` from the current global-sections approximation `CommRing.Pic (X.presheaf.obj (op ⊤))` to the geometric `MonoidalCategory.Invertible` of `X.Modules`. The C1 refactor is scheduled to follow Phase A/B closure. lean-auditor-iter104 flagged the current Lean def as **critical** excuse-comment: it is admitted by its own docstring (L33–56 and L71–84 of `Picard/LineBundle.lean`) to be a strict subgroup of the true Picard group on non-affine schemes (e.g. trivial for projective space whereas the true Pic is ℤ).

The blueprint-reviewer-iter105 must-fix-this-iter finding: `Picard_LineBundle.tex` currently presents the **geometric/post-C1 target** definition at L10–14 (line bundles = invertible quasi-coherent `O_X`-modules, w.r.t. tensor product in the symmetric monoidal category) as the meaning of `\lean{AlgebraicGeometry.Scheme.LineBundle}`. This is the Lean-state mismatch: the chapter describes the post-C1 target, the Lean side carries the pre-C1 approximation. The acknowledgement currently lives in `Picard_Functor.tex` § "Forward-compatibility note" (L75) and `Modules_Monoidal.tex` L72 only — NOT in `Picard_LineBundle.tex` itself, which is the chapter owning the affected `\lean{...}` hint.

## Required content

### Change 1 — Add a Lean-state status note to `Picard_LineBundle.tex`

Add a new `% NOTE` block + `\begin{remark}` or `\paragraph{Status note (Phase C1).}` block immediately AFTER the `\begin{definition}[Line bundle]` ... `\end{definition}` of `\def:Scheme_LineBundle` (L10–14, where the chapter currently has `\lean{AlgebraicGeometry.Scheme.LineBundle}` and `\leanok`).

The status note must:

1. **Acknowledge the Lean-state mismatch**: state explicitly that the current Lean code at `AlgebraicJacobian/Picard/LineBundle.lean` defines `LineBundle X` as `CommRing.Pic (Γ(X, ⊤))` (the Picard group of the global-sections ring), NOT as `Invertible` of `X.Modules` (the geometric definition this chapter describes).
2. **Quote the consequence**: state that the current Lean definition is, by `Stacks 0AGS`, **the true Picard group when `X` is affine** but a **strict subgroup** of the true Picard group when `X` is non-affine (concrete example: `Pic(ℙⁿ_k) = ℤ` while the current Lean def gives `CommRing.Pic k = trivial`).
3. **Cite the cross-chapter acknowledgements**: point at `Picard_Functor.tex` § "Forward-compatibility note" and `Modules_Monoidal.tex` § "Status of W.IsMonoidal" where the dependent chapters acknowledge the approximation and refuse to compound the error downstream (`representable` is kept `sorry`, etc.).
4. **Name the C1 refactor**: state that the Phase C1 refactor (scheduled per `STRATEGY.md`) will rewrite the Lean body to the geometric definition this chapter describes (`MonoidalCategory.Invertible (X.Modules)`), at which point the `\leanok` markers on `\thm:Scheme_Pic_commGroup` and `\thm:Scheme_Pic_pullback` (currently accurate for the approximation-level Lean code) will need to be re-confirmed against the refactored bodies.

The note should be ~10–15 lines of prose. Use standard `\paragraph{Status note...}` formatting; no new macros required.

### Change 2 — Update the `\leanok` markers on `\thm:Scheme_Pic_commGroup` (L23) and `\thm:Scheme_Pic_pullback` (L40)

Per blueprint marker rules, `\leanok` means the Lean side is closed against the chapter's statement. Both theorems are CURRENTLY `\leanok` because the proofs land against the approximation-level definition. But the chapter's prose describes the geometric/post-C1 statement (e.g. "tensor product over $O_X$", "pull-back of $O_Y$-modules along $f$"), which is what the post-C1 refactor will need to re-establish.

This is a marker semantics question: do the current `\leanok`s reflect "the Lean-side theorem of this name is closed against the chapter's geometric statement"? Strictly, NO — they reflect closure against the approximation. But removing `\leanok` would suggest a sorry in the Lean code that isn't there.

**The correct fix**: KEEP the `\leanok` markers but add a single-line `% NOTE: \leanok holds for the current approximation-level Lean body; the C1 refactor will re-establish against the geometric statement.` immediately above each of the two `\leanok` lines. This preserves the marker semantics (Lean side compiles, file is closed) while flagging that the proof body changes substantively under C1.

### Out of scope this round

- **Do NOT** rewrite the `\def:Scheme_LineBundle` definition itself — the geometric definition is what the chapter should describe post-C1. The status note is what records the current Lean-state mismatch.
- **Do NOT** add any new theorems or definitions to this chapter. C1 is queued for a future iter.
- **Do NOT** modify the `\lean{AlgebraicGeometry.Scheme.LineBundle}` hint — it points at the right Lean name; only the body changes under C1.
- **Do NOT** modify `Picard_Functor.tex` or `Modules_Monoidal.tex` (those are out of scope; the status note in this chapter references them as cross-chapter acknowledgements but does not modify them).

## References

None — the status note is documentary, summarizing the existing Lean docstring + cross-chapter acknowledgements that already exist in the project.

## Expected outcome

After this edit:
- `Picard_LineBundle.tex` carries a clear status note documenting the Lean-state mismatch (current approximation vs post-C1 geometric target).
- The `\leanok` markers remain on `\thm:Scheme_Pic_commGroup` and `\thm:Scheme_Pic_pullback`, each preceded by a `% NOTE:` flagging the C1 refactor will re-establish the proofs.
- The chapter goes from `correct: partial` to `correct: true` on the Lean-state-mismatch axis (the C1 refactor remains a separate strategy-driven future change).
- Cross-chapter acknowledgements in `Picard_Functor.tex` and `Modules_Monoidal.tex` remain unmodified.

## Verification

After your edit, confirm:
- The status note is present immediately after `\def:Scheme_LineBundle`'s `\end{definition}`.
- The status note mentions: (a) current Lean body = `CommRing.Pic Γ(X, ⊤)`, (b) Stacks 0AGS / affine vs non-affine, (c) the projective-space counterexample, (d) the C1 refactor target.
- Both `\thm:Scheme_Pic_commGroup` and `\thm:Scheme_Pic_pullback` retain their `\leanok` markers with a `% NOTE:` line above each.
- No other content is modified in this chapter.
- The chapter still compiles (no LaTeX errors).
