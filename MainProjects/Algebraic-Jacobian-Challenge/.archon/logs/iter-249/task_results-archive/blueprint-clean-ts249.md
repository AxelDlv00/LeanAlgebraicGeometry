# Blueprint-clean report — `Picard_TensorObjSubstrate.tex` (iter-249, slug ts249)

## Summary

Cleaned the § "The unit square (D2′): a mate-calculus telescope" region as directed. Two edits applied; four of the five modified blocks required no prose changes.

---

## What was stripped / rewritten

### 1. Proof of `lem:sheafification_comp_pullback_eq_leftadjointuniq` (new block)

- **Stripped**: `\emph{definitionally equal}` and trailing `definitionally` (Lean type-theory jargon for definitional vs. propositional equality — not standard mathematical English).
- **Replacement**: "share the same right adjoint" and "by definition" respectively. Mathematical content is preserved: both adjunctions have literally the same right adjoint (the claim formerly expressed as "definitionally equal" is now expressed as "on the nose, the same ... by definition").

### 2. Statement of `lem:epsilon_presheaf_to_sheaf_unit` (retyped block)

- **Stripped**: `\mathtt{Functor.LaxMonoidal}.\varepsilon` — typeclass jargon explicitly listed in the directive. Replaced with the plain phrase "lax-monoidal-unit equation".
- **Stripped**: `\mathtt{LaxMonoidal}` (standalone typeclass reference in "there is no `\mathtt{LaxMonoidal}` structure"). Replaced with plain "the sheaf-level pushforward carries no lax monoidal structure".
- **Simplified**: `\mathtt{PresheafOfModules.pushforward}` → `\mathtt{pushforward}` (the chapter consistently uses the short form for the presheaf pushforward; the fully-qualified module path was leakage from the Lean elaborator).

---

## Blocks with no prose changes needed

- **`\uses{}` update in `lem:leftadjointuniq_app_unit_eta`** (item 3): The added reference `lem:sheafification_comp_pullback_eq_leftadjointuniq` appeared correctly in both the statement and proof `\uses{}`; no prose leakage.
- **Step-7 narrative in `lem:eta_bridge_unit_square`** (item 4): The `(-).\mathrm{val}`-level phrasing is consistent with the chapter style; no leakage.
- **`\uses{}` reflow on `lem:pullback_tensor_iso_unit` proof** (item 5): The stray `\leanok` had already been removed cleanly from the `\uses{}` braces; the current single-line `\uses{}` on line 3348 is correct.

---

## LaTeX balance check (edited region, lines 3382–3742)

- `\begin{lemma}…\end{lemma}` pairs: all matched.
  - `lem:sheafification_comp_pullback_eq_leftadjointuniq`: opens line 3624, closes line 3644. ✓
  - `lem:leftadjointuniq_app_unit_eta`: opens line 3660, closes line 3680. ✓
  - `lem:epsilon_presheaf_to_sheaf_unit`: opens line 3701, closes line 3727. ✓
- `\begin{proof}…\end{proof}` pairs: all matched. ✓
- Display math `\[…\]`: all balanced in new blocks. ✓
- `\uses{…}` braces: no unclosed braces. ✓

---

## Marker discipline

- **No `\leanok` added or removed** anywhere.
- **No `\mathlibok` added or removed** anywhere.

---

## `\uses{}` edge integrity

- `lem:leftadjointuniq_app_unit_eta` now cites `lem:sheafification_comp_pullback_eq_leftadjointuniq` in both its statement and proof `\uses{}` — the new dependency is wired correctly.
- `lem:eta_bridge_unit_square` statement `\uses{}` correctly lists all five dependencies including `lem:leftadjointuniq_app_unit_eta` and `lem:epsilon_presheaf_to_sheaf_unit`.
- No other `\uses{}` edges were changed.
