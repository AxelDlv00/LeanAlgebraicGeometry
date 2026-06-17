# blueprint-clean — iter-016 report

**Chapters audited:**
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (2255 lines)
- `blueprint/src/chapters/Picard_FlatteningStratification.tex` (1457 lines)
- `blueprint/src/chapters/Picard_QuotScheme.tex` (1934 lines)

---

## Edits made

### 1. `Cohomology_FlatBaseChange.tex` — duplicated sentence fragment in proof of `lem:base_change_mate_codomain_read` (line 1159)

**Issue:** The proof of `lem:base_change_mate_codomain_read` contained a garbled duplication:

```
...Lemma~\ref{lem:pullback_fst_snd_specMap_tensor} enters. By that lemma
By Lemma~\ref{lem:pullback_fst_snd_specMap_tensor}, the first projection \(g'\) is the
```

"By that lemma" (a dangling fragment from an earlier draft) was left on its own line immediately before the replacement sentence "By Lemma~\ref{...},". This is a copy-edit artifact: a partial rewrite left the old fragment in place.

**Fix:** Removed the orphaned "By that lemma\n" phrase. The text now reads:

```
...Lemma~\ref{lem:pullback_fst_snd_specMap_tensor} enters. By
Lemma~\ref{lem:pullback_fst_snd_specMap_tensor}, the first projection \(g'\) is the
```

No statement, `\label`, `\lean{}`, `\uses{}`, or `\leanok`/`\mathlibok` marker was changed.

---

## Checks passed (no action needed)

### Lean tactic / Lean-name leakage in rendered prose
Searched all three files for Lean tactic keywords (`simp`, `exact`, `refine`, `rw [`, `apply `, `intro `, `induction`, `cases`, `ring`, `omega`, `linarith`, `sorry`) in rendered (non-comment) lines. All occurrences are:
- In `%`-comment lines (LaTeX comments, non-rendering), which are intentional formalization hints — `% LEAN DEPS:`, `% LEAN SIGNATURE`, `% RECIPE`, `% NOTE`, etc.
- Or appear as ordinary English words in mathematical prose ("exact sequence", "ring map", "induction on").

No Lean tactic syntax was found in rendered prose.

### Project-history verbosity in rendered prose
Searched for `iter-0NN`, "failed route", "previous iteration", "since iter". All occurrences are in `%`-comment blocks and are non-rendering. None appear in rendered prose.

### LaTeX environment balance
All `\begin{...}` / `\end{...}` pairs balance exactly in all three files (checked programmatically after stripping comments).

### `% SOURCE:` / `% SOURCE QUOTE:` pairing
All per-statement `% SOURCE:` annotations in the three files have corresponding `% SOURCE QUOTE:` or `% SOURCE QUOTE PROOF:` within the following block. The chapter-level `% SOURCE:` comment at line 3 of `Cohomology_FlatBaseChange.tex` is a bibliographic attribution note for the whole chapter, not a per-statement derivation, and does not require a verbatim quote.

### Preserved markers (per directive)
- All `% RECIPE:` and `% LEAN DEPS:` comments are intact.
- All `\mathlibok` anchors are intact.
- All `\lean{...}` pins on Route 2 QUOT blocks are intact.
- All existing `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` comments are intact.
- No `\leanok` markers were added or removed.
- No `\label`, `\lean{}` pins, or `\uses{}` sets were changed.

---

## Summary

One rendered-prose edit (duplicate fragment removal). All three chapters are now purity-clean.
