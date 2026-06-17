# Blueprint-writer directive — RiemannRoch_OcOfD.tex (literal-REF repair ONLY)

## Chapter
`blueprint/src/chapters/RiemannRoch_OcOfD.tex` (slug `RiemannRoch_OcOfD`, covers `AlgebraicJacobian/RiemannRoch/OcOfD.lean`).

## Task — surgical, ONE class of edit only
The blueprint-doctor flagged this chapter with **43 `literal-ref` findings**: the prose
contains literal `REF` placeholder tokens (rendered as `REF`, `(REF)`, `Theorem~REF`,
`REF of REF`, `REF below`, `REF and surrounding lemmas`, etc.) where a real `\cref{<label>}`
cross-reference was intended but never filled in. The chapter already uses `\cref{...}`
correctly in many places — these `REF` tokens are simply unfinished.

**Your ONLY task: replace each literal `REF` placeholder token with the correct
`\cref{<label>}`.** Nothing else.

### Hard scope boundary (do NOT cross)
- Do **not** add, delete, reorder, or reword any prose beyond what is strictly required to
  drop a single dangling `REF` token and insert its `\cref{}`.
- Do **not** touch any `\leanok`, `\mathlibok`, `\lean{}`, `\uses{}`, `\label{}`,
  `% SOURCE`, `% SOURCE QUOTE`, `\textit{Source: ...}`, statement bodies, or proof math.
- Do **not** change `\texttt{RR.1}`/`\texttt{RR.2}`/`\texttt{RR.3}`/`\texttt{RR.4}` mnemonics
  — they stay; you only fill the adjacent `(REF)`.
- Do **not** add `\leanok` anywhere (it is managed by the deterministic sync phase).
- This chapter is certified complete + correct; the only defect is the `REF` tokens. Leave
  every other byte unchanged.

## Resolved REF → label mapping (high-confidence; verify against context as you edit)

Chapter slugs:
- `RR.1` = `\cref{chap:RiemannRoch_WeilDivisor}` (Div(C), degree, order)
- `RR.2` = `\cref{chap:RiemannRoch_RRFormula}` (the χ / ℓ formula)
- `RR.3` = `\cref{chap:RiemannRoch_OCofP}` (the line bundle O_C(P) at a closed point)
- `RR.4` = `\cref{chap:RiemannRoch_RationalCurveIso}`

Line-by-line (line numbers approximate — match by surrounding text):
- "satellite of `\texttt{RR.2}` (REF)" → `\cref{chap:RiemannRoch_RRFormula}`
- "together with `\texttt{RR.1}` (REF)" → `\cref{chap:RiemannRoch_WeilDivisor}`
- "`\texttt{RR.3}` (REF)" (setup paragraph) → `\cref{chap:RiemannRoch_OCofP}`
- "Hartshorne~IV.1.3.5 chain consumed by REF of `\texttt{AbelianVarietyRigidity.tex}`"
  → `\cref{prop:rigidity_genus0_curve_to_AV}`
- "The χ-identity proof of REF in `\texttt{RR.2}`"
  → `\cref{thm:euler_char_eq_deg_plus_one_minus_genus}`
- "The existing `\texttt{RR.3}` chapter (REF) constructs" → `\cref{chap:RiemannRoch_OCofP}`
- "The REF below makes this bypass" → `\cref{lem:sheafOf_singlePoint}`
- "canonically isomorphic to REF" → `\cref{def:lineBundleAtClosedPoint}`
- "Proposition~6.15 (which the present chapter pins via REF)" → `\cref{lem:sheafOf_singlePoint}`
- "Div(C) is the one defined in REF of `\texttt{RiemannRoch\_WeilDivisor.tex}`"
  → `\cref{def:codim1_cycles}`
- "the prime-divisor data type is REF" → `\cref{def:prime_divisor}`
- "the order ord_Q(f) … is REF" → `\cref{def:order_at_point}`
- "the principal divisor div(f) … is REF" → `\cref{def:principal_divisor}`
- "the closed-point divisor [P] is REF" → `\cref{def:divisor_closed_point}`
- "The line bundle at a closed point already constructed in `\texttt{RR.3}` is REF"
  → `\cref{def:lineBundleAtClosedPoint}`
- "the present chapter's REF makes the comparison" → `\cref{lem:sheafOf_singlePoint}`
- "REF verifies that the general construction at D=[P] recovers" → `\cref{lem:sheafOf_singlePoint}`
- "supported on a finite set {Q : n_Q ≠ 0} (REF)" → `\cref{def:codim1_cycles}`
- "The closed-point specialisation O_C([P]) is REF of REF" →
  `\cref{def:lineBundleAtClosedPoint} of \cref{chap:RiemannRoch_OCofP}`
- "their agreement at D=[P] is REF below" → `\cref{lem:sheafOf_singlePoint}`
- "the section condition of REF reduces" → `\cref{def:sheafOf}`
- lemma title "[Sheaf at a single closed point is the line bundle of REF]"
  → `\cref{def:lineBundleAtClosedPoint}`
- "viewed as a Weil divisor [P] via REF" → `\cref{def:divisor_closed_point}`
- "the invertible sheaf O_C([P]) of REF agrees" → `\cref{def:sheafOf}`
- "the line bundle of the closed point O_C(P) of REF" → `\cref{def:lineBundleAtClosedPoint}`
- "P is identified with the prime divisor it determines by REF" → `\cref{def:divisor_closed_point}`
- "On the REF side, the same conditions" → `\cref{def:lineBundleAtClosedPoint}`
- "extracted by REF of `\texttt{RR.3}`" → `\cref{lem:lineBundleAtClosedPoint_globalSections_iff}`
- "a prime divisor REF on a smooth curve" → `\cref{def:prime_divisor}`
- "The construction of REF is presheaf-by-hand" → `\cref{def:sheafOf}`
- "`\texttt{RR.1}` (REF and surrounding lemmas)" → `\cref{chap:RiemannRoch_WeilDivisor}`
- bullet "sheafOf (REF)" → `\cref{def:sheafOf}`
- bullet "sheafOf\_zero (REF)" → `\cref{lem:sheafOf_zero}`
- bullet "sheafOf\_singlePoint (REF) — the REF comparison at D=[P], upstream of REF's
  consumption in RR.3": first → `\cref{lem:sheafOf_singlePoint}`; second ("the REF comparison")
  → `\cref{lem:sheafOf_singlePoint}` (it IS the comparison lemma; if that reads redundantly,
  use `\cref{def:lineBundleAtClosedPoint}`); third ("upstream of REF's consumption")
  → `\cref{thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero}`.
- bullet "sheafOf\_ses\_single\_add (REF)" → `\cref{lem:sheafOf_ses_single_add}`
- "invoked inside the proof of REF at the single instance" → `\cref{lem:sheafOf_ses_single_add}`
- "the analogue of REF for general D" → `\cref{lem:lineBundleAtClosedPoint_globalSections_iff}`
- "handled in `\texttt{RR.3}` via REF" → `\cref{lem:sheafOf_singlePoint}`

### Genuinely ambiguous — use judgment, rephrase if no clean target
- "Hartshorne's Proposition~6.13(a) (quoted in REF of REF) then guarantees …": there is **no
  project label** for Hartshorne 6.13(a). 6.13(a) (locally-free-rank-1 ⇒ invertible) is the
  content of the **Invertibility** paragraph of this chapter. Resolve to
  `\cref{sec:sheaf-property-correctness}` (single ref), i.e. rewrite "(quoted in REF of REF)"
  → "(see \cref{sec:sheaf-property-correctness})". If that reads awkwardly, minimally rephrase
  to drop the dangling reference entirely.
- "(Hartshorne~II.6.13(a), REF), so $-\otimes …$ is exact": again no project label for
  6.13(a). Drop the `, REF` token: rewrite "(Hartshorne~II.6.13(a), REF)" → "(Hartshorne~II.6.13(a))".

## Full label inventory you may cite (all exist in the blueprint)
WeilDivisor: `def:codim1_cycles, def:prime_divisor, def:order_at_point, def:principal_divisor,
def:divisor_closed_point, def:divisor_degree, thm:divisor_degree_hom, lem:degree_single`.
This chapter: `def:sheafOf, lem:sheafOf_zero, lem:sheafOf_singlePoint, lem:sheafOf_ses_single_add,
sec:sheaf-property-correctness`.
OCofP (RR.3): `def:lineBundleAtClosedPoint, lem:lineBundleAtClosedPoint_globalSections_iff,
thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero, thm:lineBundleAtClosedPoint_h0_sub_h1_eq_two`.
RRFormula (RR.2): `thm:euler_char_eq_deg_plus_one_minus_genus, def:l_invariant, def:sheafOf`.
AVR: `prop:rigidity_genus0_curve_to_AV`.
Chapters: `chap:RiemannRoch_WeilDivisor, chap:RiemannRoch_RRFormula, chap:RiemannRoch_OcOfD,
chap:RiemannRoch_OCofP, chap:RiemannRoch_RationalCurveIso`.

## Verification before you finish
Run `grep -nE 'REF' blueprint/src/chapters/RiemannRoch_OcOfD.tex` — there must be **zero**
bare `REF` placeholder tokens left (the word "REF" must only ever appear inside `\cref{...}`
... it does not, so the file should contain no standalone "REF" at all). Confirm no
`\label{}`, `\lean{}`, `\uses{}`, `\leanok`, `% SOURCE`, or math was altered.

## Out of scope
Everything except replacing `REF` placeholder tokens. No new declarations, no proof edits,
no marker changes, no reference retrieval.
