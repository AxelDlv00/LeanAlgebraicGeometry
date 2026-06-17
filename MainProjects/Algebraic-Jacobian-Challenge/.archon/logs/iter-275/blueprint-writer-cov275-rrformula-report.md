# Blueprint Writer Report

## Slug
cov275-rrformula

## Status
COMPLETE

All five directive-named declarations now have an additive, faithful 1-to-1
coverage block, statement-level-wired into the chapter cone. No existing block
was touched. `leandag build` reports no `unknown_uses`, no new isolated nodes,
and all five `\lean{}` hints resolve (none in `unmatched_lean`).

## Target chapter
blueprint/src/chapters/RiemannRoch_RRFormula.tex

## Changes Made

Inserted between the closed-point skyscraper lemma
(`lem:euler_char_skyscraperSheaf`) and the `The main \(\chi\)-identity`
subsection. Two go into the substrate-lemmas flow; three form a new
`\subsection*{Inductive scaffolding via the divisor line bundle}`.

- **Added lemma** `\lemma`/`\label{lem:finrank_H0_toModuleKSheaf_eq_one}`/`\lean{AlgebraicGeometry.Scheme.finrank_H0_toModuleKSheaf_eq_one}` — `dim_{k̄} H⁰(C, 𝒪_C) = 1` (Hartshorne I.3.4 specialisation). **Axiom-clean in Lean** (`lean_verify`: only `propext, Classical.choice, Quot.sound`), so proof block is the one-line `Proved directly in Lean.`
- **Added lemma** `\label{lem:euler_char_of_shortExact_skyscraper}`/`\lean{…eulerCharacteristic_of_shortExact_skyscraper}` — `χ(F₂) = χ(F₁) + 1` for a SES whose cokernel is a closed-point skyscraper. Honest sketch (combines additivity + iso-invariance + skyscraper-χ). Transitively `sorryAx`.
- **Added lemma** `\label{lem:euler_char_sheafOf_zero}`/`\lean{…eulerCharacteristic_sheafOf_zero}` — base case `χ(𝒪_C(0)) = 1 − g(C)`. Honest sketch. Transitively `sorryAx` (via `sheafOf_zero`).
- **Added lemma** `\label{lem:euler_char_sheafOf_succ}`/`\lean{…eulerCharacteristic_sheafOf_succ}` — unit step `χ(𝒪_C([Y] + D)) = χ(𝒪_C(D)) + 1`. Honest sketch (closed-point SES → packaged skyscraper additivity). Transitively `sorryAx` (via `sheafOf_ses_single_add`).
- **Added lemma** `\label{lem:euler_char_sheafOf_single_add}`/`\lean{…eulerCharacteristic_sheafOf_single_add}` — general `χ(𝒪_C(n[Y] + D)) = χ(𝒪_C(D)) + n`, `n ∈ ℤ`. Honest sketch (induction on `n`, both signs). Transitively `sorryAx`.

Proof-note policy: `finrank_H0_toModuleKSheaf_eq_one` verified axiom-clean →
"Proved directly in Lean."; the other four verified to carry `sorryAx`
(inherited from the `RR.3` `sheafOf` typed-sorry and the H¹-skyscraper /
`shortExact_add` gaps) → honest informal sketches, each naming its gated
input.

## Cross-references introduced (statement-level `\uses{}`)
- `lem:finrank_H0_toModuleKSheaf_eq_one` → `def:Scheme_HModule`, `def:Scheme_toModuleKSheaf` (both exist in `Cohomology_StructureSheafModuleK.tex`).
- `lem:euler_char_of_shortExact_skyscraper` → `def:eulerChar_curve`, `lem:euler_char_shortExact_add`, `lem:euler_char_iso`, `lem:euler_char_skyscraperSheaf` (all in this chapter).
- `lem:euler_char_sheafOf_zero` → `def:eulerChar_curve`, `lem:finrank_H0_toModuleKSheaf_eq_one`, `lem:sheafOf_zero` (`OcOfD.tex`), `def:genus` (`Genus.tex`).
- `lem:euler_char_sheafOf_succ` → `def:eulerChar_curve`, `lem:euler_char_of_shortExact_skyscraper`, `lem:sheafOf_ses_single_add` (`OcOfD.tex`), `def:sheafOf` (`OcOfD.tex`).
- `lem:euler_char_sheafOf_single_add` → `def:eulerChar_curve`, `lem:euler_char_sheafOf_succ`, `def:sheafOf` (`OcOfD.tex`).

All referenced labels verified to exist. `leandag query --isolated --chapter
RiemannRoch_RRFormula` → 0 results; `unknown_uses` → none.

## References consulted
None opened this session for verbatim quotes. The five blocks are
project-internal Euler-characteristic plumbing lemmas (directive sanctioned a
"proved directly in Lean" note with no external citation; do not fabricate).
No `% SOURCE:`/`% SOURCE QUOTE:` lines were written — only `\textit{...}`
descriptive provenance lines naming the Hartshorne IV.1.3 / I.3.4 *step* each
lemma plays, with no fabricated verbatim quote.

## Macros needed (if any)
None new. Reused existing macros already present and compiling in sibling
chapters: `\Module`, `\HModule`, `\toModuleKSheaf` (used in `Genus.tex` /
`Cohomology_StructureSheafModuleK.tex`), `\mathrm{Div}` (matches this chapter's
existing usage). `\cref` used for all project cross-references (no `REF`
placeholders, no bare label ids).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The five new blocks will receive `\leanok` from the deterministic
  `sync_leanok` phase: `finrank_H0_toModuleKSheaf_eq_one` is axiom-clean;
  the other four are sorry-free in their own bodies but transitively `sorryAx`
  (so `sync_leanok` should mark the statement `\leanok` but leave the proof
  `\leanok` per its sorry analysis — that is sync's call, not mine).
- The main χ-identity theorem `thm:euler_char_eq_deg_plus_one_minus_genus`
  conceptually depends on these new scaffolding lemmas, but its block is
  existing/out-of-scope, so I did not add the (mathematically correct) upward
  `\uses{lem:euler_char_sheafOf_zero, lem:euler_char_sheafOf_single_add}` to
  it. Consider adding those two edges to that theorem's `\uses{}` in a future
  plan-agent prose pass to tighten the cone (the new blocks are already
  non-isolated via their outgoing edges, so this is a refinement, not a fix).
- Pre-existing literal `REF` placeholders remain throughout the chapter's
  older prose (setup section, main-theorem proof). They predate this round and
  were out of scope; flagging for eventual cleanup.

## Strategy-modifying findings
None.
