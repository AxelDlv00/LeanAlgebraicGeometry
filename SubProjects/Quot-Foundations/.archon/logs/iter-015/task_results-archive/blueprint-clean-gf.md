# Blueprint-clean report — GF chapter, iter-015

**Chapter:** `blueprint/src/chapters/Picard_FlatteningStratification.tex`
**Status:** CLEAN — all purity issues resolved

---

## Issues found and fixed

### 1. "formalisation content" meta-language (Localisation transport sub-step)

**Location:** proof of `lem:gf_torsion_reindex`, Localisation transport paragraph.

**Old:** "Making the two agree is the genuine formalisation content of this step, and it proceeds as follows."

**Fix:** "Making the two agree is the mathematical content of this step, which proceeds as follows."

---

### 2. "The existential in the goal" — Lean proof-state language

**Location:** proof of `lem:gf_torsion_reindex`, Action-diamond subtlety paragraph.

**Old:** "The existential in the goal asks for an \(A_g\)-module structure…"

**Fix:** "The conclusion of the lemma requires an \(A_g\)-module structure…"

---

### 3. "see the structure note above" — dangling reference to a `%`-comment

**Location:** proof of `lem:gf_polynomial_core`, enumeration item 3.

**Old:** "…to \(A_g\) (see the structure note above)."

**Fix:** "…to \(A_g\)." — the parenthetical referenced a `% LEAN PROOF STRUCTURE` comment invisible in the rendered document.

---

### 4. Subsection intro — "project-bespoke helpers" and "Mathlib transport API"

**Location:** `\subsubsection{Module-structure transport helpers (reindex)}` intro paragraph.

**Old:** "The following project-bespoke helpers package those three transport principles. They are general module-theory facts, proved directly from the Mathlib transport API; no external source is cited."

**Fix:** "The following helper lemmas package those three transport principles. They are general module-theory facts; no external source is cited."

---

### 5. Lean API names in `lem:gf_pullback_module_transport` proof

**Location:** proof body, parentheticals `(Mathlib's \texttt{Module.Finite.equiv})` and `(\texttt{smul\_assoc})`.

**Fix:** Removed both parentheticals; rephrased the sentences to name the mathematical operations ("transporting module-finiteness across the \(R\)-linear isomorphism \(e\)" and "applying associativity of the scalar action on \(M\)").

---

### 6. Lean API names in `lem:gf_finite_of_quotient_ringequiv` proof

**Location:** proof body, parentheticals `(\texttt{AlgEquiv.ofRingEquiv})`, `(\texttt{Module.Finite.equiv})`, `(\texttt{Module.Finite.trans})`.

**Fix:** Removed all three; prose is self-explanatory without them.

---

### 7. Lean API names in `lem:gf_islocalizedmodule_restrictscalars` proof

**Location:** proof body, parentheticals `(\texttt{IsScalarTower.algebraMap\_smul})`, `(\texttt{Module.End.isUnit\_iff})`, `(\texttt{IsLocalizedModule.mk})`.

**Fix:** Removed all three; rephrased to plain mathematical statements of what is being verified.

---

## Markers preserved

All `\label{}`, `\lean{}`, `\uses{}`, and `\mathlibok` markers are unchanged. No `\leanok` was added or removed. All `% SOURCE` / `% SOURCE QUOTE PROOF` comments retained verbatim. All `% NOTE` and `% LEAN SIGNATURE` comment blocks retained as-is (they are inside `%`-comments and are within scope).

## Remaining `\texttt{}` in rendered text

Only in `\section{Mathlib status}` (lines 1353–1371), which is an explicitly technical section listing Mathlib declarations by name. This is appropriate for a blueprint Mathlib-status section and was left unchanged.

## Out-of-scope

All other chapters; all `.lean` files. No `\leanok` synchronisation was performed (owned by `sync_leanok`).
