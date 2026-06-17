Target: blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

Action: Purity pass over this iter's edits (do NOT touch `\leanok`, do NOT change mathematical content). Focus areas:
- `lem:cech_term_pushforward_acyclic` (statement + proof, ~L11700–11760): now carries `[X.IsSeparated]`,`[S.IsSeparated]`,`hres`. Strip any Lean-syntax leakage / project-history phrasing.
- New block `lem:isQuasicoherent_pullback_opens` (~L11634): general-opens restrict–over bridge. Ensure prose is math-only (no Lean tactic names, no `iter-0NN` references).
- `lem:cech_computes_cohomology_affineCover` (~L12031): statement now carries `f` separated + `S` separated with `X` separated DERIVED, plus a `\textbf{Scope.}` paragraph. Keep the math; strip any leakage.
Verify all `% SOURCE`/`% SOURCE QUOTE` blocks are preserved and the verbatim quotes are intact. Confirm LaTeX environments balance. If a referenced source quote is missing for a claim, you may spawn a reference-retriever (references/** is in your write-domain) — but only if a real citation gap exists; Tag 01SG is referenced as prose cross-ref only (no verbatim quote required).

Constraints: math-only; one chapter; no `\leanok`.
