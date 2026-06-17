# blueprint-clean ts238 report

**Status: DONE — no issues remain**

---

## Chapter 1: `Cohomology_FlatBaseChange.tex`

### New blocks verified clean (no Lean tactic strings, correctly uncited)

- `lem:powers_restrictScalars` — pure math, no Lean syntax, no `% SOURCE` (correct: Archon-original)
- `lem:fromTildeGamma_app_isIso_of_localized` — pure math, no Lean syntax, no `% SOURCE` (correct: Archon-original)
- `lem:pushforward_spec_tilde_iso_conditional` — pure math, no Lean syntax, no `% SOURCE` (correct: Archon-original)

### Lean leakage found and fixed in the expanded proof of `lem:pushforward_spec_tilde_iso`

Four instances of Lean leakage in the "explicit formalization route over D(a)" section were fixed:

**Fix 1 — `\mathrm{eqToIso}` (two instances, movement (1)):**
- Old: "glued by an \(\mathrm{eqToIso}\) — except that the \(\mathrm{eqToIso}\) now rests on"
- New: "glued by a canonical isomorphism from the ring equation — except that the canonical isomorphism now rests on"

**Fix 2 — `\mathrm{eqToIso}` (one instance, movement (2) header):**
- Old: "The equation grounding the \(\mathrm{eqToIso}\) is the \(D(a)\)-shadow of"
- New: "The ring equation grounding this canonical isomorphism is the \(D(a)\)-shadow of"

**Fix 3 — `.app()` Lean accessor (movement (2) tail):**
- Old: `\((\operatorname{Spec}\varphi).\mathrm{app}(D(a))\)`
- New: `\((\operatorname{Spec}\varphi)^{\sharp}_{D(a)}\)` (consistent with notation used in the displayed ring equation just above)

**Fix 4 — `\mathrm{IsLocalizedModule}` typeclass + "Mathlib instance" (movement (3)):**
- Old: "carries the canonical Mathlib instance exhibiting it as the localization \(\mathrm{IsLocalizedModule}\,(\mathrm{powers}(\varphi a))\) over \(R'\). Apply ... to rewrite this as an \(\mathrm{IsLocalizedModule}\,(\mathrm{powers}(a))\) instance, over \(R\), ... yields exactly \(\mathrm{IsLocalizedModule}\,(\mathrm{powers}(a))\) on \(\Gamma(N, D(a))\) over \(R\)"
- New: "is canonically the \(\mathrm{powers}(\varphi a)\)-localization of \(M = \Gamma(\widetilde M, \top)\) over \(R'\). Apply ... to obtain the \(\mathrm{powers}(a)\)-localization over \(R\) of the same module, viewed by restriction of scalars. Transporting that localization property back ... yields the localization property at \(\mathrm{powers}(a)\) on \(\Gamma(N, D(a))\) over \(R\)"

### Pre-existing `% SOURCE QUOTE` blocks

All five pre-existing `% SOURCE QUOTE` blocks verified byte-intact:
- `def:pushforward_base_change_map` (lines 39–48)
- `lem:affine_base_change_pushforward` statement (lines 551–563)
- `lem:affine_base_change_pushforward` proof (lines 582–598)
- `thm:flat_base_change_pushforward` statement (lines 679–699)
- `thm:flat_base_change_pushforward` proof (lines 736–785)

No project-history references ("since iteration N", "our failed route") found in the new or surrounding content. `% NOTE:` comment (review-agent domain) was left untouched.

---

## Chapter 2: `Picard_TensorObjSubstrate.tex`

### Brace repair confirmed

The proof of `lem:islocallyinjective_whiskerleft_via_stalk` (lines 2232–2235) reads:

```latex
\begin{proof}
  \leanok
  \uses{lem:stalk_tensor_commutation, lem:stalk_linear_map,
    lem:W_implies_stalkwise_iso, lem:stalk_tensor_commutation_naturality_right}
```

- `\leanok` is on its own line, before `\uses{}` ✓
- `\uses{}` lists exactly the four required labels ✓
- No `\leanok` embedded inside the brace list ✓
- No other edits made to this chapter ✓

---

## No retriever spawn needed

All `% SOURCE QUOTE` blocks for cited lemmas are present and intact. The three new Archon-original blocks carry no citation (correct). No missing references detected.
