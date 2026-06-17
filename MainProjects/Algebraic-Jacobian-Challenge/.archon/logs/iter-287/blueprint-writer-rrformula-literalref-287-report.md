# Blueprint-writer report — RiemannRoch_RRFormula.tex literal-REF repair (iter-287)

**Slug:** rrformula-literalref-287
**Chapter:** `blueprint/src/chapters/RiemannRoch_RRFormula.tex`
**Scope:** surgical — replace each literal `REF` placeholder token with the correct `\cref{<label>}`. Nothing else.

## Result
All 37 literal `REF` occurrences (35 prose/NOTE sites, two of which were `(REF, REF)` pairs) were
replaced with their resolved `\cref{}` macros. Final verification:

```
grep -nE 'REF' blueprint/src/chapters/RiemannRoch_RRFormula.tex  →  exit 1 (zero matches)
```

No literal `REF` substring survives anywhere in the file.

## Replacements applied (by resolved label)
- `prop:rigidity_genus0_curve_to_AV` — L23 (bridge-consumer), L899 (downstream classification)
- `def:divisor_degree` — L26 (RR.1 degree map), L780 (closed-point contributes 1)
- `thm:euler_char_eq_deg_plus_one_minus_genus` — L53 (NOTE), L61 (NOTE), L189, L857, L930
- `thm:riemannRoch_genus_zero` — L59 (NOTE), L935
- `def:genus` — L80, L721
- `def:l_invariant` — L124, L864
- `def:Scheme_HModule` — L131
- `def:codim1_cycles` — L158, L175, L704 (first of pair)
- `def:divisor_closed_point` — L705 (second of pair)
- `def:eulerChar_curve` — L178, L263, L319, L404, L862
- `lem:euler_char_shortExact_add` — L192, L760, L796
- `lem:euler_char_iso` — L195, L758, L800
- `lem:euler_char_skyscraperSheaf` — L198, L770, L803
- `thm:divisor_degree_hom` — L707, L781
- `thm:principal_deg_zero` — L902, L948

The two `% NOTE` comment-block sites (L53, L59, L61) had their `REF` token replaced in place,
keeping the leading `%` so the `\cref{}` stays commented out (clears the literal token without
uncommenting anything).

## Scope adherence
- Only `REF` → `\cref{}` substitutions were made; each `Edit` `old_string` contained the literal
  `REF` and was replaced by exactly one (or, for the L704–705 pair, two) `\cref{}` macros.
- No `\leanok`, `\mathlibok`, `\lean{}`, `\uses{}`, `\label{}`, `% SOURCE`, `% SOURCE QUOTE`,
  `\textit{Source: ...}`, statement bodies, proof math, or `\texttt{RR.1}`..`RR.4` mnemonics were
  altered by these edits.
- The file carried substantial pre-existing uncommitted changes (substrate-lemma prose,
  `$`/`\(` math-delimiter normalizations) from prior iterations; those were left untouched —
  none of them involve a `REF` token.

## Verification
- `grep -nE 'REF'` → no matches (exit 1). ✅
- All target labels confirmed to exist per directive (local + cross-chapter).
