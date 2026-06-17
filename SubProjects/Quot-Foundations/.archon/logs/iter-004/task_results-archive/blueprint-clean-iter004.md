# blueprint-clean — iter-004 post-writer purity pass

## Status: COMPLETE

---

## Files touched

- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — 3 fixes
- `blueprint/src/chapters/Picard_FlatteningStratification.tex` — 2 fixes

---

## Fixes applied

### Cohomology_FlatBaseChange.tex

**Fix 1 — Wrong `\uses` on `lem:pullbackIsoEquivalenceOfIso`.**
The plan-agent block carried `\uses{def:pushforward_base_change_map}`, which is a
false dependency (the lemma states that pullback along an iso is an equivalence of
module categories; it has no logical relation to the pushforward base-change map
definition). Removed.

**Fix 2 — Lean-orientation prose in `lem:base_change_mate_regroupEquiv` proof.**
The proof opened with "Write the route in the Lean orientation \(A \otimes_R R'\)".
"Lean orientation" is implementation-specific language. Changed to "Work in the
convention with order \(A \otimes_R R'\)", which conveys the same tensor-order
choice in neutral mathematical terms.

**Fix 3 — Lean-tactic leakage in `lem:base_change_mate_generator_trace` proof.**
The proof closed with "follows by rewriting along that equality and inferring the
iso instance for \(\operatorname{regroup}^{-1}\)". Both "rewriting along" (Lean `rw`)
and "inferring the iso instance" (typeclass instance synthesis) are Lean-tactic
idioms. Replaced with the mathematical statement: "follows since
\(\operatorname{regroup}^{-1}\) is a linear equivalence and hence an isomorphism."

### Picard_FlatteningStratification.tex

**Fix 4 — Lean-term argument syntax in `lem:gf_free_moduleFinite` proof.**
The proof cited `\texttt{Module.Finite.trans}~\(B~M\)`, supplying explicit Lean
universe-polymorphic arguments `B M` in math mode. Reduced to the bare identifier
`\texttt{Module.Finite.trans}`, consistent with the project's style of citing
Mathlib lemmas by name without explicit arguments.

**Fix 5 — Lean dot-notation terms in `lem:gf_splice_shortExact_localized_exact` proof.**
The proof concluded with `\texttt{LocalizedModule.map\_exact}) applied to
\(i.\mathrm{restrictScalars}\,A\) and \(q.\mathrm{restrictScalars}\,A\)`.
The Lean dot-notation expressions `i.restrictScalars A` and `q.restrictScalars A`
are Lean term-level leakage. Replaced with: "applied to \(i\) and \(q\) regarded as
\(A\)-linear maps via the scalar restriction along \(A \to B\)."

---

## Preserved (unchanged)

- All `% LEAN SIGNATURE` comment blocks on `lem:gf_noether_clear_denominators`
  (line 355) and `thm:generic_flatness` (line 562) — verified present.
- All `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` / `% NOTE` comments
  in both files — untouched.
- All `\textit{Source: …}` lines — untouched.
- All `\leanok` markers — no additions or removals.
- The `% --- Supporting infrastructure helpers ---` comment block for
  `lem:pullbackIsoEquivalenceOfIso` / `lem:pullback_isEquivalence_of_iso`.

---

## LaTeX / blueprint structural review

- All `\begin{lemma}` / `\end{lemma}` and `\begin{proof}` / `\end{proof}`
  environments are balanced in both files (no new mismatches introduced).
- `\uses` / `\ref` / `\cref` cross-references checked for the new blocks:
  - `lem:pullbackIsoEquivalenceOfIso` — no `\uses` (correct; pure bespoke infra).
  - `lem:pullback_isEquivalence_of_iso` — `\uses{lem:pullbackIsoEquivalenceOfIso}` ✓.
  - `lem:base_change_mate_codomain_read` statement — `\uses{..., lem:pullback_isEquivalence_of_iso}` ✓ (documented-use, not direct proof citation; acceptable).
  - L3 sub-lemmas referenced correctly from `lem:gf_splice_shortExact` assembly ✓.
  - `lem:gf_noether_clear_denominators` AlgHom statement — prose and proof clean ✓.

---

## No reference-retriever needed

All source citations already present; no missing quotes identified.
