# Blueprint-writer report — RiemannRoch_OcOfD.tex literal-REF repair (iter-287)

**Slug:** `ocofd-literalref-287`
**Chapter:** `blueprint/src/chapters/RiemannRoch_OcOfD.tex`
**Status:** ✅ COMPLETE — all 43 literal-`REF` placeholder tokens replaced with real `\cref{}`.

## Outcome
- `grep -nE 'REF' blueprint/src/chapters/RiemannRoch_OcOfD.tex` → **exit 1, zero matches**.
  No standalone `REF` token remains anywhere in the chapter.
- File now contains **42 `\cref{...}`** references (the 43 dropped `REF` tokens collapsed
  onto 42 crefs because two ambiguous Hartshorne-6.13(a) cases were resolved without a cref —
  see below).
- All 18 distinct labels cited by the new crefs were verified to have a matching `\label{}`
  somewhere in `blueprint/src/chapters/` (no MISSING).

## Edits made (REF → \cref mapping applied)
Setup/motivation section:
- `RR.2 (REF)` → `\cref{chap:RiemannRoch_RRFormula}`
- `RR.1 (REF)` → `\cref{chap:RiemannRoch_WeilDivisor}`
- `RR.3 (REF)` → `\cref{chap:RiemannRoch_OCofP}` (two occurrences)
- "consumed by REF of AbelianVarietyRigidity.tex" → `\cref{prop:rigidity_genus0_curve_to_AV}`
- "χ-identity proof of REF" → `\cref{thm:euler_char_eq_deg_plus_one_minus_genus}`
- "The REF below makes this bypass" → `\cref{lem:sheafOf_singlePoint}`
- "isomorphic to REF" → `\cref{def:lineBundleAtClosedPoint}`
- "pins via REF" → `\cref{lem:sheafOf_singlePoint}`
- Standing-hypotheses chain: `def:codim1_cycles`, `def:prime_divisor`, `def:order_at_point`,
  `def:principal_divisor`, `def:divisor_closed_point`, `def:lineBundleAtClosedPoint`,
  `lem:sheafOf_singlePoint`
- "REF verifies that the general construction" → `\cref{lem:sheafOf_singlePoint}`

Definition / lemmas:
- "supported on a finite set (REF)" → `\cref{def:codim1_cycles}`
- closed-point specialisation "REF of REF" → `\cref{def:lineBundleAtClosedPoint} of \cref{chap:RiemannRoch_OCofP}`
- "agreement at D=[P] is REF below" → `\cref{lem:sheafOf_singlePoint}`
- "section condition of REF" → `\cref{def:sheafOf}`
- lemma title "line bundle of REF" → `\cref{def:lineBundleAtClosedPoint}`
- "via REF" (Weil divisor [P]) → `\cref{def:divisor_closed_point}`
- "O_C([P]) of REF" → `\cref{def:sheafOf}`
- "O_C(P) of REF" → `\cref{def:lineBundleAtClosedPoint}`
- "determined by REF" → `\cref{def:divisor_closed_point}`
- "On the REF side" → `\cref{def:lineBundleAtClosedPoint}`
- "extracted by REF of RR.3" → `\cref{lem:lineBundleAtClosedPoint_globalSections_iff}`
- "prime divisor REF on a smooth curve" → `\cref{def:prime_divisor}`

Sheaf-property / pins / out-of-scope:
- "construction of REF is presheaf-by-hand" → `\cref{def:sheafOf}`
- "RR.1 (REF and surrounding lemmas)" → `\cref{chap:RiemannRoch_WeilDivisor}`
- bullets: `def:sheafOf`, `lem:sheafOf_zero`, `lem:sheafOf_singlePoint`,
  `lem:sheafOf_ses_single_add`
- sheafOf_singlePoint bullet triple: `\cref{lem:sheafOf_singlePoint}` /
  `\cref{def:lineBundleAtClosedPoint}` (disambiguated to avoid self-redundant reading) /
  `\cref{thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero}`
- "proof of REF at the single instance" → `\cref{lem:sheafOf_ses_single_add}`
- "analogue of REF for general D" → `\cref{lem:lineBundleAtClosedPoint_globalSections_iff}`
- "handled in RR.3 via REF" → `\cref{lem:sheafOf_singlePoint}`

## Ambiguous cases (no project label for Hartshorne 6.13(a)) — resolved per directive
- "(quoted in REF of REF)" → rewritten to "(see \cref{sec:sheaf-property-correctness})".
- "(Hartshorne~II.6.13(a), REF)" → dropped the dangling token: "(Hartshorne~II.6.13(a))".

## Scope discipline
- No `\label`, `\lean`, `\uses`, `\leanok`, `\mathlibok`, `% SOURCE`, `% SOURCE QUOTE`,
  `\textit{Source: ...}`, statement bodies, or proof math were altered by me. Every edit's
  old/new string differed only in the `REF`→`\cref{}` substitution (plus the two ambiguous
  rephrasings above).
- `\texttt{RR.1}`–`\texttt{RR.4}` mnemonics left intact; only the adjacent `(REF)` filled.

## Note on `git diff` vs HEAD
`git diff` against HEAD shows additional, **pre-existing** uncommitted changes (several
`\uses{}` blocks and `$`-vs-`\(` math-delimiter normalisations) that were already present in
the working tree when I opened the file — these are prior-iteration work (cf. iter-286
math-delim fixes), **not** mine. My contribution is exclusively the REF→cref substitutions.
