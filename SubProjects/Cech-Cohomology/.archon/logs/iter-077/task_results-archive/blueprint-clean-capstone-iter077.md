# Blueprint Clean Report — capstone-iter077

**Target:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Scope:** Five lemma blocks near `lem:cech_computes_cohomology` (~L11700+)

---

## Changes made

### 1. `lem:cechAugmented_to_acyclicResolutionInput` — statement (L11889–11891)

**Removed** the Lean-specific parenthetical `(Lemma~\ref{lem:cech_augmented_resolution}: \(\mathrm{IsZero}\) of \(H_p\) for all \(p\))`.

This was an implementation annotation naming the Lean/Mathlib predicate `IsZero`; the mathematical meaning (homology vanishes in every degree) was already expressed in the surrounding prose. Replaced with the plain cross-reference `(its homology vanishes in every degree; Lemma~\ref{lem:cech_augmented_resolution})`.

---

### 2. `lem:cech_computes_cohomology_affineCover` — statement, cover description (L11948–11950)

**Removed** the Lean hypothesis-name annotation `(\(h_{\mathfrak{U}} : U_i\) affine for every \(i\))`.

This named the Lean hypothesis `hU` in signature style; the mathematical condition (all members affine) is fully conveyed by the preceding English phrase. Deleted the parenthetical entirely.

---

### 3. `lem:cech_computes_cohomology_affineCover` — statement remark paragraph (L11960–11970)

**Replaced** the project-history paragraph containing the phrases "frozen statement", "current signature", and "frozen signature" — all Archon/Lean implementation terms — with a clean mathematical remark.

*Old text (key offending phrases):*
> "The frozen statement Lemma~\ref{lem:cech_computes_cohomology} asserts the same conclusion but its **current signature** omits... so the honest assembly is recorded here under the correct hypotheses. Once those two hypotheses are restored to the **frozen signature**, its proof body reduces verbatim to the assembly below."

*Replacement:* A concise mathematical note that the separatedness + affineness of the $U_i$ forces all intersections affine (the Stacks hypothesis), with a reference to `lem:cech_computes_cohomology` where that hypothesis is assumed directly, and a counterexample showing the statement fails without these conditions.

---

### 4. `lem:cech_computes_cohomology_affineCover` — proof, first paragraph (L11979–11986)

**Removed** two Lean identifiers:
- `\((e, \mathrm{hexact})\)` — the Lean pair constructor/binder name `hexact` is an implementation detail. Replaced by the plain English phrase "the resolution data:".
- `hypothesis \(h_{\mathfrak{U}}\)` — Lean hypothesis name. Replaced by "The affineness of every \(U_i\)".

---

### 5. `lem:cech_computes_cohomology_affineCover` — proof, second paragraph (L11990–11991)

**Replaced** `\(\operatorname{cechComplexOnX}\,\mathfrak{U}\,\mathcal{F}\)` — the Lean function identifier `cechComplexOnX` — with the mathematical reference "the {\v C}ech complex on \(X\) of Definition~\ref{def:cech_complex_on_X}".

---

## Blocks left untouched

- `lem:cech_term_pushforward_acyclic` (L11633–11705): statement and proof are clean; `% SOURCE QUOTE PROOF` block properly placed outside the lemma environment. No Lean leakage.
- `lem:rightAcyclic_finite_prod` (L11817–11841): `\textit{Project-local.}` is a citation attribution convention, not Lean or project-history; proof is clean abstract algebra.
- `lem:pushforward_mapHC_cechComplexOnX` (L11843–11881): clean; `\textit{Project-local.}` retained.
- All `\leanok` / `\mathlibok` markers: untouched throughout.
- `\mathrm{cycles}`, `\mathrm{ExactAt}`, `\mathrm{rightDerived}`, `\operatorname{Nonempty}`: retained as established project notation used consistently across the chapter.

---

## Outcome

All five target blocks now read as timeless, standalone mathematics. No Lean tactic strings, hypothesis names, Lean function identifiers, or project-iteration narrative remain in the prose.
