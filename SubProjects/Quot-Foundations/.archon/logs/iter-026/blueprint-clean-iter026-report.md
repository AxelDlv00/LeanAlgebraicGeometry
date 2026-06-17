# blueprint-clean — iter-026 report

**Status:** DONE — 4 targeted edits, no mathematical content altered, citation added.

---

## Chapter 1 — `Cohomology_FlatBaseChange.tex`

### Proof of `lem:base_change_mate_inner_eCancel`

**Edit (1 of 1):** Removed project-memory reference `fbc-subst-legs-literal-form-lock` from the "Order of operations (load-bearing)" paragraph; restated the obstruction purely mathematically.

- **Old:** `…the literal-form lock recorded in project memory \texttt{fbc-subst-legs-literal-form-lock}). Hence: distribute the unit…`
- **New:** `…the factors agree mathematically but differ in hidden index data, so head-symbol matching fails). Hence: distribute the unit…`

All mathematical content (which step must precede which, and why the locked literal form blocks the atoms) is preserved verbatim.

---

## Chapter 2 — `Picard_QuotScheme.tex`

### NOTE comment on `lem:qcoh_section_localization_basicOpen`

**Edit (1 of 3):** Scrubbed iteration tag and pipeline jargon from the NOTE comment.
- `% NOTE (iter-026):` → `% NOTE:`
- `gap 1 is the QUOT mathlib-build lane's explicit target this iter.` → `Gap 1 is the explicit open target.`

The mathematical content (Lean decl does not yet exist, two axiom-clean ingredients, remaining gap 1) is fully preserved.

### NOTE comment on `lem:qcoh_affine_isIso_fromTildeΓ`

**Edit (2 of 3):** Scrubbed iteration tag and pipeline jargon from the NOTE comment.
- `% NOTE (iter-026):` → `% NOTE:`
- Removed "; it is the explicit Mathlib-gradient target for the QUOT mathlib-build lane."

The mathematical NOTE (Lean decl does not exist, Mathlib has only `isIso_fromTildeΓ_iff` + global-Presentation case, substance is local→global direction of QCoh(Spec R) ≃ Mod R) is preserved.

**Edit (3 of 3):** Scrubbed "the mathlib-build lane develops it bottom-up." from the proof's closing sentence.
- **Old:** `…the Mathlib-absent content; the mathlib-build lane develops it bottom-up.`
- **New:** `…the Mathlib-absent content.`

### SOURCE QUOTE added for `lem:qcoh_affine_isIso_fromTildeΓ`

The gap1 block had a `% SOURCE:` comment naming "Properties of Schemes / Schemes" but no verbatim `% SOURCE QUOTE:`. A quote was retrieved from `references/stacks-schemes.tex` (lines 1279–1284, `lemma-quasi-coherent-affine`):

```
% SOURCE: [Stacks Project], "Schemes", Lemma \texttt{lemma-quasi-coherent-affine},
%   \S\,Quasi-coherent sheaves on affines (read from references/stacks-schemes.tex, L1279--1284).
% SOURCE QUOTE: "Let $(X, \mathcal{O}_X) = (\Spec(R), \mathcal{O}_{\Spec(R)})$
%   be an affine scheme. Let $\mathcal{F}$ be a quasi-coherent $\mathcal{O}_X$-module. Then
%   $\mathcal{F}$ is isomorphic to the sheaf associated to the $R$-module $\Gamma(X, \mathcal{F})$."
```

### Existing SOURCE QUOTE on `lem:isLocalizedModule_tilde_restrict` — verified

The blueprint quote "For every $f\in R$ we have $\Gamma(D(f), \widetilde M) = M_f$ as an $R_f$-module." matches verbatim lines 701–702 of `references/stacks-schemes.tex` (`lemma-spec-sheaves`, item (4)). No edit required.

---

## No spawned reference-retrievers

All needed source text was located in the existing `references/stacks-schemes.tex`. No external fetch was required.
